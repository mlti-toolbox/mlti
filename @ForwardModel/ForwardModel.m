classdef ForwardModel
    properties (SetAccess = private)
        
        x
        x_step
        U
        V
    end

    methods
        % CONSTRUCTOR
        function obj = ForwardModel(f, x_probe, varargin)
            if ~(isequal(size(x_probe, 2), 2) || isequal(size(x_probe, 1), 2))
                error("'x_probe' must be an nx2 or 2xn matrix. %s matrix provided.", mat2str(size(x_probe)))
            end
            if isequal(size(x_probe), [2,2])
                warning("Interpreting provided 'x_probe' as [x(1), y(1); x(2), y(2)].");
            end
            if ~isvector(f)
                warning("'f' will be cast into an %dx1 vector.", numel(f));
            end
            
            obj.f = f(:);

            if isequal(size(x_probe, 2), 2)
                obj.x_probe = x_probe;
            else
                obj.x_probe = x_probe';
            end

            % default values
            sym_solve = false;
            x_max = 15 * max(x_probe(:));
            x_N = 100;

            % First, store all inputs
            params = struct();
            for k = 1:2:length(varargin)
                name = varargin{k};
                value = varargin{k+1};
                params.(name) = value;
            end
            
            % Now process in desired order
            if isfield(params, 'sym_solve')
                sym_solve = logical(params.sym_solve);
            end
            
            if isfield(params, 'force_sym_solve')
                sym_solve = logical(params.force_sym_solve);
            end
            
            if isfield(params, 'x_max')
                if ~isscalar(params.x_max)
                    error("'x_max' must be a scalar. %s matrix provided.", mat2str(size(params.x_max)))
                end
                x_max = params.x_max;
            end
            
            if isfield(params, 'x_N')
                if ~isscalar(params.x_N)
                    error("'x_N' must be a scalar. %s matrix provided.", mat2str(size(params.x_N)))
                end
                x_N = params.x_N;
            end

            x_step = x_max / x_N;
            
            if isfield(params, 'x_step')
                if ~isscalar(params.x_step)
                    error("'x_step' must be a scalar. %s matrix provided.", mat2str(size(params.x_step)))
                end
                x_step = params.x_step;  % Overrides the computed one, if any
            end

            obj.x_step = x_step;

            % Spatial Domain
            x = 0:x_step:x_max;
            obj.x = [-flip(x), x(2:end)];

            % Frequency Domain
            x_freq = 1 ./ (2 .* x_step);  % Spatial frequency
            x_N = floor(x_max ./ x_step) + 1;    % Number of points
            xi = x_freq ./ x_N .* (-x_N : x_N-1);  % Frequency vector
            [obj.U,obj.V] = meshgrid(xi,xi);  % Frequency matrix


            if ~(exist("@ForwardModel/T0_hat_finite.m", "file") ...
                && exist("@ForwardModel/T0_hat_infinite.m", "file"))
                sym_solve = true;
            end

            if sym_solve
                obj.solve_system_symbolically();
                disp("creating methods")
            end
        end
    end
end