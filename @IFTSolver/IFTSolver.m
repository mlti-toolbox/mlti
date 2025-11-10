classdef IFTSolver
    properties (SetAccess = private)
        method
        args
        x (:,1) double {mustBeReal}
        y (1,:) double {mustBeReal}
        dx (1,1) double {mustBeReal}
        dy (1,1) double {mustBeReal}
        u (:,1) {mustBeReal}
        v (1,:) {mustBeReal}
        interp (1,1) griddedInterpolant
        solve (1,1) function_handle = @(x) x;
    end
    methods
        function solver = IFTSolver(method, args, options)
            arguments
                method        (1,1) IFTEnum;
                args          (1,:) cell = {};
                options.x_max (1,2) double {mustBeReal,    mustBeNonnegative, IFTSolver.need_opts(method, options.x_max)} = 0;
                options.dx    (1,2) double {mustBeReal,    mustBeNonnegative, IFTSolver.need_opts(method, options.dx)}    = 0;
                options.Nx    (1,2) double {mustBeInteger, mustBeNonnegative, IFTSolver.need_opts(method, options.Nx)}    = 0;
                options.interp_methods (1,2) string = ["linear", "none"];
            end
            solver.method = method;
            solver.args = args;
            syms u v real
            switch method
                case IFTEnum.ifft2
                    [solver.x,solver.dx,solver.u] = buildXU( ...
                        options.x_max(1), options.dx(1), options.Nx(1) ...
                    );
                    [solver.y,solver.dy,solver.v] = buildXU( ...
                        options.x_max(2), options.dx(2), options.Nx(2) ...
                    );
                    solver.interp = griddedInterpolant( ...
                        {solver.x, solver.y}, ...
                        zeros(length(solver.x), length(solver.y)), ...
                        options.interp_methods(1), ...
                        options.interp_methods(2) ...
                    );
                    solver.solve = @solver.solveifft2;
                case IFTEnum.integral2
                    solver.solve = @solver.solveintegral2;
                    solver.u = u;
                    solver.v = v;
                case IFTEnum.vpaintegral
                    solver.solve = @solver.solvevpaintegral;
                    solver.u = u;
                    solver.v = v;
            end
        end
        function disp(solver)
            fprintf('<a href = "https://mlti-toolbox.github.io/Documentation/IFTSolver">IFTSolver</a> with properties:\n\n');
            if solver.method == IFTEnum.ifft2
                l = strlength(strjoin(string(size(solver.x)),","));
                fprintf("%smethod: %s\n", string(blanks(l)), string(solver.method));
                fprintf("  x %s\n", IFTSolver.vector_display(solver.x));
                fprintf("  y %s\n", IFTSolver.vector_display(solver.y));
                fprintf("  u %s\n", IFTSolver.vector_display(solver.u));
                fprintf("  v %s\n", IFTSolver.vector_display(solver.v));
                fprintf("%sinterp: griddedInterpolant\n\n", string(blanks(l)));
            else
                fprintf("  method: %s\n\n", string(solver.method));
            end
        end
    end
    methods (Static, Access = private)
        function need_opts(method, value)
            assert( ...
                isequal(method, IFTEnum.ifft2) || all(value == 0), ...
                "Not allowed when method is not 'ifft2'" ...
            );
        end
        function str = vector_display(x)
            str = compose( ...
                "(%s): %.3g:%.3g:%.3g", ...
                strjoin(string(size(x)),"×"), ...
                x(1), x(2)-x(1), x(end) ...
            );
        end
    end
end