classdef ForwardModel
    properties (SetAccess = private)
        c_args struct = struct();
        in_structure cell = cell(1,3);
        in_sizes uint8 = [0,0,0];
        xu_vects (:,2) double
    end

    methods
        % CONSTRUCTOR
        function this = ForwardModel(varargin)
            [this.c_args, this.in_structure, this.in_sizes] = this.validate_constructor_arguments(varargin{:});
            fprintf("ForwardModel object created with the following constructor arguments:\n\n");
            disp(this.c_args);
            if isempty(this.in_structure{2})
                orient_structure = "";
            else
                orient_structure = strjoin(this.in_structure{2}, ", ");
            end
            fprintf("\nFunction inputs 'M', 'O', and 'chi' expected to be formatted as follows:\n" + ...
                "\tM = [%s]; i.e., an N_train-by-%d matrix of doubles\n" + ...
                "\tO = [%s]; i.e., an N_pump-by-%d matrix of doubles\n" + ...
                "\tchi = [%s]; i.e., a 1-by-%d vector of doubles\n", ...
                strjoin(this.in_structure{1}, ", "), this.in_sizes(1), ...
                orient_structure, this.in_sizes(2), ...
                strjoin(this.in_structure{3}, ", "), this.in_sizes(3));

            if this.c_args.force_sym_solve ...
                    || ~exist("@ForwardModel/private/T0_hat_finite.m", "file") ...
                    || ~exist("@ForwardModel/private/T0_hat_infinite.m", "file")
                solve_system_symbolically();
                rehash;
            end

            if isequal(this.c_args.ift_method, "ifft2")
                if isfield(this.c_args, "dx") && isfield(this.c_args, "Nx")
                    dx = this.c_args.dx;
                    Nx = this.c_args.Nx;
                elseif isfield(this.c_args, "dx")
                    dx = this.c_args.dx;
                    Nx = floor(this.c_args.x_max/dx) * 2 + 1;
                elseif isfield(this.c_args, "Nx")
                    Nx = this.c_args.Nx;
                    dx = this.c_args.x_max / floor(Nx/2);
                end
                steps = -floor(Nx/2) : ceil(Nx/2) - 1;
                x = steps * dx;
                u = steps / (Nx * dx);
                this.xu_vects = [x(:), u(:)];
            end

        % 
        %     % Spatial Domain
        %     x = 0:dx:x_max;
        %     obj.x = [-flip(x), x(2:end)];
        % 
        %     % Frequency Domain
        %     x_freq = 1 ./ (2 .* dx);  % Spatial frequency
        %     Nx = floor(x_max ./ dx) + 1;    % Number of points
        %     xi = x_freq ./ Nx .* (-Nx : Nx-1);  % Frequency vector
        %     [obj.U,obj.V] = meshgrid(xi,xi);  % Frequency matrix
        % 
        % 
        %     if ~(exist("@ForwardModel/T0_hat_finite.m", "file") ...
        %         && exist("@ForwardModel/T0_hat_infinite.m", "file"))
        %         sym_solve = true;
        %     end
        % 
        %     if sym_solve
        %         obj.solve_system_symbolically();
        %         disp("creating methods")
        %     end
        end
    end

    properties (Constant)
        % ISO_OPTIONS - String array of valid isotropy types
        iso_options = ["iso", "simple", "complex", "tensor"];
        
        % ORIENT_OPTIONS - String array of valid orientation types
        orient_options = ["azpol", "uvect", "euler", "uquat", "rotmat"];
        
        % SEQ_OPTIONS - String array of valid Euler-angle rotation sequences
        seq_options = ["ZYZ", "ZXZ", "ZYX", "ZXY", ...
                       "YXY", "YZY", "YXZ", "YZX", ...
                       "XZX", "XYX", "XZY", "XYZ"];

        % VLD - Validation and default specifications for ForwardModel constructor
        %
        %   VLD is a struct containing function handles that define:
        %     - Validation rules for each constructor name-value argument.
        %     - Default value logic for arguments not explicitly provided.
        %     - Cross-validation rules to ensure argument consistency.
        %
        %   Field names of VLD correspond to valid constructor argument names.
        %
        %   Each field value of VLD is a struct with the following subfields:
        %     selfValidate  - Function handle that validates an argument value
        %                     independent of other inputs. Returns the validated
        %                     value or throws an error if invalid.
        %
        %     getDefault    - Function handle that returns the default value when
        %                     the argument is not provided. Takes as input a struct
        %                     of already self-validated user inputs. Throws an 
        %                     error if the argument is required but missing.
        %
        %     crossValidate - (Optional) Function handle that validates an argument
        %                     in the context of all other arguments (validated and
        %                     default-populated). Takes as input a struct of 
        %                     already self-validated and default-populated
        %                     constructor arguments and either
        %                       - Returns the cross-validated struct, ignoring and 
        %                         issuing a warning regarding redundant arguments.
        %                       - Throws an error if arguments are inconsistent.
        %
        %   Example validation flow:
        %     1. Validate each user-input argument name. E.g., name =
        %        validatestring(name, fieldnames(VLD)), or 
        %        mustBeMember(name, fieldnames(VLD))
        %     2. Validate each user-input argument value. E.g.,
        %        c_args.name = VLD.name.selfValidate(value)
        %     3. Populate missing arguments with defaults. E.g.,
        %        c_args.name = VLD.name.getDefault(c_args)
        %     4. Perform cross-validation for each name in c_args. E.g.,
        %        c_args = VLD.name.crossValidate(c_args)
        %
        %   Function handle behavior:
        %     - Enforces presence of required arguments.
        %     - Rejects invalid or inconsistent inputs.
        %     - Ignores and warns about redundant inputs.
        %
        %   See also: ForwardModel.ForwardModel, ForwardModel.c_args,
        %   ForwardModel/private/validate_c_args, validatestring, mustBeMember  
        vld = struct( ...
            "ift_method", struct( ...
                "selfValidate", @(x) validatestring(x, ["ifft2", "integral2"]), ...
                "getDefault", @(~) "ifft2" ...
            ), ...
            "x_max", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(props) ForwardModel.default_x_max(props), ...
                "crossValidate", @(props) ForwardModel.cross_validate_x(props, "x_max") ...
            ), ...
            "Nx", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(props) ForwardModel.default_Nx(props), ...
                "crossValidate", @(props) ForwardModel.cross_validate_x(props, "Nx") ...
            ), ...
            "dx", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(~) [], ...
                "crossValidate", @(props) ForwardModel.cross_validate_x(props, "dx") ...
            ), ...
            "scale", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(~) 1 ...
            ), ...
            "film_isotropy", struct( ...
                "selfValidate", @(x) validatestring(x, ForwardModel.iso_options), ...
                "getDefault", @(~) "tensor" ...
            ), ...
            "sub_isotropy", struct( ...
                "selfValidate", @(x) validatestring(x, ForwardModel.iso_options), ...
                "getDefault", @(~) "tensor" ...
            ), ...
            "film_orient", struct( ...
                "selfValidate", @(x) validatestring(x, ForwardModel.orient_options), ...
                "getDefault", @(props) ForwardModel.default_orient(props, "film"), ...
                "crossValidate", @(props) ForwardModel.cross_validate_orient(props, "film") ...
            ), ...
            "sub_orient", struct( ...
                "selfValidate", @(x) validatestring(x, ForwardModel.orient_options), ...
                "getDefault", @(props) ForwardModel.default_orient(props, "sub"), ...
                "crossValidate", @(props) ForwardModel.cross_validate_orient(props, "sub") ...
            ), ...
            "euler_seq", struct( ...
                "selfValidate", @(x) validatestring(x, ForwardModel.seq_options), ...
                "getDefault", @(props) ForwardModel.default_seq(props), ...
                "crossValidate", @(props) ForwardModel.cross_validate_seq(props) ...
            ), ...
            "inf_sub_thick", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) true ...
            ), ...
            "phase_only", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) false ...
            ), ...
            "force_sym_solve", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) false ...
            ), ...
            "log_args", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) false ...
            ) ...
        );
    end
    
    methods (Static, Access = private)
        function x = enforcePositive(x)
            assert(isnumeric(x) && x > 0, "Input value, '" + x + "', is not a positive numeric value.")
        end
        function x = enforceLogical(x)
            assert(islogical(x), "Input value, '" + x + "', is not a logical data type.")
        end
        function x = default_x_max(props)
            if isequal(props.ift_method, "ifft2")
                if isfield(props, 'dx') || isfield(props, 'x_max')
                    x = [];
                else
                    error("Must provide either values for 'x_max' or 'dx' when ift_method = 'ifft2'.")
                end
            else
                x = [];
            end
        end
        function x = default_Nx(props)
            if isequal(props.ift_method, "ifft2") && ~(isfield(props, 'dx') && isfield(props, 'x_max'))
                x = 256;
            else
                x = [];
            end
        end
        function x = default_orient(props, layer)
            name = layer + "_isotropy";
            isotropy = props.(name);
            if ismember(isotropy, ["simple", "complex"])
                error("Argument '%s_orient' is required when %s = '%s'", layer, name, isotropy)
            else
                x = [];
            end
        end
        function x = default_seq(props)
            if (isfield(props, 'film_orient') && isequal(props.film_orient, 'euler')) ...
                || (isfield(props, 'sub_orient') && isequal(props.sub_orient, 'euler'))
                    x = 'ZYZ';
            else
                x = [];
            end
        end
        function props = cross_validate_x(props, name)
            if isequal(props.ift_method, "integral2")
                warning("Input, %s = %d, ignored because ift_method = 'integral2'.", name, props.(name))
                props = rmfield(props, name);
            end
            if isequal(name, "dx") && isfield(props, "Nx") && isfield(props, 'x_max')
                warning("Input, Nx = %d, ignored because 'dx' and 'x_max' were also provided and take priority.", props.Nx)
                props = rmfield(props, "Nx");
            end
        end
        function props = cross_validate_orient(props, layer)
            iso_name = layer + "_isotropy";
            orient_name = layer + "_orient";
            isotropy = props.(iso_name);
            orientation = props.(orient_name);
            if ismember(isotropy, ["iso", "tensor"])
                warning("Input, %s = '%s', ignored because %s = '%s'", orient_name, orientation, iso_name, isotropy)
                props = rmfield(props, orient_name);
            elseif isequal(isotropy, "complex") && ismember(orientation, ["azpol", "uvect"])
                error("%s = '%s' may not be used when %s = '%s'.", orient_name, orientation, iso_name, isotropy)
            end
        end
        function props = cross_validate_seq(props)
            % euler_seq is unnecessary when neither film_orient nor
            % sub_orient is equal to 'euler'.
            if ~((isfield(props, 'film_orient') && isequal(props.film_orient, 'euler')) ...
                || (isfield(props, 'sub_orient') && isequal(props.sub_orient, 'euler')))
                warning("Input, euler_seq = '%s', ignored because neither film_orient nor sub_orient was set to 'euler'.", props.euler_seq)
                props = rmfield(props, "euler_seq");
            end
        end
        function orient_structure = format_orient(orient_type, subscript, ndims, seq)
            switch orient_type
                case "azpol"
                    orient_structure = ["θ" + subscript + "_az", "θ" + subscript + "_pol"];
                case "uvect"
                    orient_structure = strings(1,3);
                    for i = 1:3, orient_structure(i) = "v" + subscript + i; end
                case "euler"
                    orient_structure = strings(1, ndims);
                    for i = 1:ndims, orient_structure(i) = "θ" + subscript + seq(i) + i; end
                case "uquat"
                    orient_structure = strings(1, 4);
                    for i = 1:4, orient_structure(i) = "q" + subscript + i; end
                case "rotmat"
                    orient_structure = strings(3,3);
                    for j = 1:3
                        for i = 1:3
                            orient_structure(i,j) = "R" + subscript + i + j;
                        end
                    end
                    orient_structure = orient_structure(:)';
            end
        end
        function [k, o] = format_ko(isotropy, orient, subscript, seq)
            switch isotropy
                case "iso"
                    k = "k" + subscript;
                    o = [];
                case "simple"
                    k = ["k" + subscript + "⊥", "k" + subscript + "∥"];
                    o = ForwardModel.format_orient(orient, subscript, 2, seq);
                case "complex"
                    k = strings(1,3);
                    for i = 1:3
                        k(i) = "k" + subscript + "p" + i;
                    end
                    o = ForwardModel.format_orient(orient, subscript, 3, seq);
                case "tensor"
                    k = strings(1,6);
                    count = 1;
                    for i = 1:3
                        for j = i:3
                            k(count) = "k" + subscript + i + j;
                            count = count + 1;
                        end
                    end
                    o = [];
            end
        end
    end
end