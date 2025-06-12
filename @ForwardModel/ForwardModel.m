classdef ForwardModel
    properties
        f       % nx1 vector of frequencies at which to evaluate the forward model.
        x_probe % nx2 matrix [x_probe(1:n), y_probe(1:n)] of probe ofset locations.
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

            sym_solve = false;

            % Parse varargin
            for k = 1:2:length(varargin)
                name = varargin{k};
                value = varargin{k+1};
                switch name
                    case 'sym_solve'
                        sym_solve = logical(value);
                    case 'force_sym_solve'
                        sym_solve = logical(value);
                    otherwise
                        error('Unknown parameter: %s', name);
                end
            end

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