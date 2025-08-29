classdef IFTSolver
    properties
        method
        x (:,1) double {mustBeReal}
        y (:,1) double {mustBeReal}
        u (:,1) double {mustBeReal}
        v (:,1) double {mustBeReal}
    end
    methods
        function solver = IFTSolver(method, options)
            % IFTSolver  Inverse Fourier Transform solver
            %
            % Syntax:
            %   solver = IFTSolver(method)
            %   solver = IFTSolver(method,Name,Value)
            %
            %   % Valid syntax when method="integral2"
            %   solver = IFTSolver("integral2")
            %
            %   % Valid syntaxes when method="ifft2"
            %   solver = IFTSolver("ifft2","x_max",x_max)
            %   solver = IFTSolver("ifft2","x_max",x_max,"dx",dx)
            %   solver = IFTSolver("ifft2","x_max",x_max,"Nx",Nx)
            %   solver = IFTSolver("ifft2","dx",dx)
            %   solver = IFTSolver("ifft2","dx",dx,"Nx",Nx)
            arguments
                method        (1,1) IFTEnum = IFTEnum.ifft2;
                options.x_max (1,2) double {mustBeReal,    mustBeNonnegative, IFTSolver.need_opts(method, options.x_max)} = 0;
                options.dx    (1,2) double {mustBeReal,    mustBeNonnegative, IFTSolver.need_opts(method, options.dx)}    = 0;
                options.Nx    (1,2) double {mustBeInteger, mustBeNonnegative, IFTSolver.need_opts(method, options.Nx)}    = 0;
            end
            solver.method = method;
            [solver.x,solver.u] = IFTSolver.buildXU(options.x_max(1), options.dx(1), options.Nx(1));
            [solver.y,solver.v] = IFTSolver.buildXU(options.x_max(2), options.dx(2), options.Nx(2));
            
        end
        function disp(solver)
            fprintf('<a href = "https://k-joshua-kelley.github.io/MLTI/IFTSolver">IFTSolver</a> with properties:\n\n');
            fprintf("  method = '%s'\n", string(solver.method));
            fprintf("  x %s\n", IFTSolver.vector_display(solver.x));
            fprintf("  y %s\n", IFTSolver.vector_display(solver.y));
            fprintf("  u %s\n", IFTSolver.vector_display(solver.u));
            fprintf("  v %s\n\n", IFTSolver.vector_display(solver.v));
        end
    end
    methods (Static, Access = private)
        function need_opts(method, value)
            assert( ...
                isequal(method, IFTEnum.ifft2) || all(value == 0), ...
                "Not allowed when method is not 'ifft2'" ...
            );
        end
        function [x, u] = buildXU(x_max, dx, Nx)
            arguments (Output)
                x (:,1) double {mustBeReal}
                u (:,1) double {mustBeReal}
            end

            if x_max == 0 && dx == 0
                error("Must provide either 'x_max' or 'dx' when method = 'ifft2'.");
            end
            if x_max ~= 0 && dx ~= 0 && Nx ~= 0
                error("Must not provide all three: 'x_max', 'dx', 'Nx'.")
            end
            if Nx == 0
                if x_max ~= 0 && dx ~= 0
                    Nx = floor(x_max/dx) * 2 + 1;
                else
                    Nx = 256;
                end
            end
            if dx == 0
                dx = x_max / floor(Nx/2);
            end

            du = 1 / (Nx * dx);
            steps = -floor(Nx/2) : ceil(Nx/2) - 1;
            x = steps * dx;
            u = steps * du;

        end
        function str = vector_display(x)
            str = compose("(%s) = %.3g:%.3g:%.3g", strjoin(string(size(x)),","), x(1), x(2)-x(1), x(end));
        end
    end
end