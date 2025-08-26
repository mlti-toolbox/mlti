classdef ForwardModel
    % ForwardModel class description TODO
    properties (SetAccess = private)
        % c_args - Struct of constructor arguments.
        c_args struct = struct();

        % fun_inputs - Input structure for ForwardModel functions.
        fun_inputs struct = struct();

        % xu - Nx-by-2 array of spatial and spatial-frequency vectors.
        xu (:,2) double
    end

    properties (Access = private)
        T0_hat function_handle
    end

    methods
        % CONSTRUCTOR
        function this = ForwardModel(c_args)
            % ForwardModel constructor description TODO
            % See also ForwardModel.private.validate_c_args, ForwardModel
            arguments
                c_args.ift_method (1,1) IFTEnum = IFTEnum.ifft2;
                c_args.x_max (1,1) double {mustBeReal, mustBePositive};
                c_args.Nx (1,1) uint32 {mustBeInteger, mustBePositive} = 256;
                c_args.dx (1,1) double {mustBeReal, mustBePositive};
                c_args.scale (1,1) double {mustBeReal, mustBePositive} = 1;
                c_args.film_isotropy (1,1) IsotropyEnum = IsotropyEnum.tensor;
                c_args.sub_isotropy (1,1) IsotropyEnum = IsotropyEnum.tensor;
                c_args.film_orient (1,1) OrientEnum = OrientEnum.na;
                c_args.sub_orient (1,1) OrientEnum = OrientEnum.na;
                c_args.euler_seq (1,1) SeqEnum = SeqEnum.ZYZ;
                c_args.inf_sub_thick (1,1) logical = true;
                c_args.phase_only (1,1) logical = false;
                c_args.log_args (1,1) logical = false;
                c_args.force_sym_solve (1,1) logical = false;
            end
            c_args = c_args.ift_method.cross_validate(c_args);
            c_args = c_args.film_orient.cross_validate(c_args.film_isotropy, "film", c_args);
            c_args = c_args.sub_orient.cross_validate(c_args.sub_isotropy, "sub", c_args);
            c_args = c_args.euler_seq.cross_validate(c_args);
            this.c_args = c_args;
            fprintf("ForwardModel object created with the following constructor arguments:\n\n");
            disp(this.c_args);

            % Get function input structure
            this.fun_inputs = this.get_input_structure();
            fprintf("\nFunction inputs 'M', 'O', 'chi', 'f0', and 'X_probe' should be formatted as follows:\n\n")
            for name = string(fieldnames(this.fun_inputs))'
                disp(strjoin("    " + splitlines(this.fun_inputs.(name).msg), newline))
            end

            % Construct FFT spatial and spatial-frequency domains:
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
                du = 1 / (Nx * dx);
                steps = -floor(Nx/2) : ceil(Nx/2) - 1;
                x = steps * dx;
                u = steps * du;
                this.xu = [x(:), u(:)];
                fprintf("\nFFT domains are as follows:\n" + ...
                    "    x = y = %g:%g:%g\n" + ...
                    "    u = v = %g:%g:%g\n", ...
                    x(1), dx, x(end), ...
                    u(1), du, u(end));
            end

            % solve for T0_hat symbolically if needed
            if this.c_args.force_sym_solve ...
                    || ~exist("@ForwardModel/private/T0_hat_finite.m", "file") ...
                    || ~exist("@ForwardModel/private/T0_hat_infinite.m", "file")
                solve_system_symbolically();
                rehash;
            end

            if this.c_args.inf_sub_thick
                this.T0_hat = @T0hat_infinite;
            else
                this.T0_hat = @T0hat_finite;
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
        end
    end

    properties (Constant)
        % ISO_OPTIONS - String array of valid isotropy types
        iso_options = ["iso", "simple", "complex", "tensor"];
        
        % ORIENT_OPTIONS - String array of valid orientation types
        orient_options = ["azpol", "uvect", "euler", "uquat", "rotmat"];
        
        % SEQ_OPTIONS - Cell array of valid Euler-angle rotation sequences
        % (1-by-3 character arrays comprised only of 'X', 'Y', or 'Z')
        seq_options = {'ZYZ', 'ZXZ', 'ZYX', 'ZXY', ...
                       'YXY', 'YZY', 'YXZ', 'YZX', ...
                       'XZX', 'XYX', 'XZY', 'XYZ'};

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
            "sweep_method", struct( ...
                "selfValidate", @(x) validatestring(x, ["ndgrid", "broadcast", "loop"]), ...
                "getDefault", @(props) "broadcast" ...
            ), ...
            "inf_sub_thick", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) true ...
            ), ...
            "phase_only", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) false ...
            ), ...
            "log_args", struct( ...
                "selfValidate", @(x) ForwardModel.enforceLogical(x), ...
                "getDefault", @(~) false ...
            ), ...
            "force_sym_solve", struct( ...
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
                    error("Must provide values for either 'x_max' or 'dx' when ift_method = 'ifft2'.")
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
    end
end