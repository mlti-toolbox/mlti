classdef ForwardModel
    methods (Static, Access = private)
        function x = enforcePositive(x)
            assert(isnumeric(x) && x > 0, "Input value, '" + x + "', is not a positive numeric value.")
        end
        function x = enforceLogical(x)
            assert(islogical(x), "Input value, '" + x + "', is not a logical data type.")
        end
        function x = default_x_max(props)
            if isequal(props.ift_method, "ifft2")
                error("Argument 'x_max' is required when ift_method = 'ifft2'.")
            else
                x = [];
            end
        end
        function x = default_x_N(props)
            if isequal(props.ift_method, "ifft2") && ~isfield(props, 'x_step')
                x = 100;
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
            if isequal(name, "x_step") && isfield(props, "x_N")
                warning("Input, x_N = %d, ignored because 'x_step' was also provided and takes priority.", props.x_N)
                props = rmfield(props, "x_N");
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
    properties (Constant)
        iso_options = ["iso", "simple", "complex", "tensor"];
        orient_options = ["azpol", "uvect", "euler", "uquat", "rotmat"];
        seq_options = {'ZYZ', 'ZXZ', 'ZYX', 'ZXY', 'YXY', 'YZY', 'YXZ', 'YZX', 'XYX', 'XZX', 'XYZ', 'XZY'}
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
            "x_N", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(props) ForwardModel.default_x_N(props), ...
                "crossValidate", @(props) ForwardModel.cross_validate_x(props, "x_N") ...
            ), ...
            "x_step", struct( ...
                "selfValidate", @(x) ForwardModel.enforcePositive(x), ...
                "getDefault", @(~) [], ...
                "crossValidate", @(props) ForwardModel.cross_validate_x(props, "x_step") ...
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
            ) ...
        );
    end

    properties (SetAccess = private)
        % Input Name-Value Arguments
        ift_method (1,1) string {mustBeMember(ift_method, ["ifft2", "integral2"])} = "ifft2"
        x_max (1,1) double
        x_N (1,1) double {mustBePositive} = 100
        x_step (1,1) double
        film_isotropy (1,1) string {mustBeMember(film_isotropy, ["iso", "simple", "complex", "tensor"])} = "tensor"
        sub_isotropy (1,1) string {mustBeMember(sub_isotropy, ["iso", "simple", "complex", "tensor"])} = "tensor"
        film_orient (1,1) string
        sub_orient (1,1) string
        euler_seq (1,3) char {mustBeMember(euler_seq, {'ZYZ', 'ZXZ', 'ZYX', 'ZXY', 'YXY', 'YZY', 'YXZ', 'YZX', 'XYX', 'XZX', 'XYZ', 'XZY'})} = 'ZYZ'
        inf_sub_thick (1,1) logical = 1
        phase_only (1,1) logical = 0
        force_sym_solve (1,1) logical = 0


        input_props struct = struct()
        eval_input_names
        eval_input_sizes
    end

    methods
        % CONSTRUCTOR
        function obj = ForwardModel(varargin)
            for k = 1:2:length(varargin)
                name = lower(varargin{k});
                assert(ismember(name, obj.NameOptions));
                value = varargin{k+1};
                obj.input_props.(name) = value;
            end
        %     if ~(isequal(size(x_probe, 2), 2) || isequal(size(x_probe, 1), 2))
        %         error("'x_probe' must be an nx2 or 2xn matrix. %s matrix provided.", mat2str(size(x_probe)))
        %     end
        %     if isequal(size(x_probe), [2,2])
        %         warning("Interpreting provided 'x_probe' as [x(1), y(1); x(2), y(2)].");
        %     end
        %     if ~isvector(f)
        %         warning("'f' will be cast into an %dx1 vector.", numel(f));
        %     end
        % 
        %     obj.f = f(:);
        % 
        %     if isequal(size(x_probe, 2), 2)
        %         obj.x_probe = x_probe;
        %     else
        %         obj.x_probe = x_probe';
        %     end
        % 
        %     % default values
        %     sym_solve = false;
        %     x_max = 15 * max(x_probe(:));
        %     x_N = 100;
        % 
        %     % First, store all inputs
        %     params = struct();
        %     for k = 1:2:length(varargin)
        %         name = varargin{k};
        %         value = varargin{k+1};
        %         params.(name) = value;
        %     end
        % 
        %     % Now process in desired order
        %     if isfield(params, 'sym_solve')
        %         sym_solve = logical(params.sym_solve);
        %     end
        % 
        %     if isfield(params, 'force_sym_solve')
        %         sym_solve = logical(params.force_sym_solve);
        %     end
        % 
        %     if isfield(params, 'x_max')
        %         if ~isscalar(params.x_max)
        %             error("'x_max' must be a scalar. %s matrix provided.", mat2str(size(params.x_max)))
        %         end
        %         x_max = params.x_max;
        %     end
        % 
        %     if isfield(params, 'x_N')
        %         if ~isscalar(params.x_N)
        %             error("'x_N' must be a scalar. %s matrix provided.", mat2str(size(params.x_N)))
        %         end
        %         x_N = params.x_N;
        %     end
        % 
        %     x_step = x_max / x_N;
        % 
        %     if isfield(params, 'x_step')
        %         if ~isscalar(params.x_step)
        %             error("'x_step' must be a scalar. %s matrix provided.", mat2str(size(params.x_step)))
        %         end
        %         x_step = params.x_step;  % Overrides the computed one, if any
        %     end
        % 
        %     obj.x_step = x_step;
        % 
        %     % Spatial Domain
        %     x = 0:x_step:x_max;
        %     obj.x = [-flip(x), x(2:end)];
        % 
        %     % Frequency Domain
        %     x_freq = 1 ./ (2 .* x_step);  % Spatial frequency
        %     x_N = floor(x_max ./ x_step) + 1;    % Number of points
        %     xi = x_freq ./ x_N .* (-x_N : x_N-1);  % Frequency vector
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
end