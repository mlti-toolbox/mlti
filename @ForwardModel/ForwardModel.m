classdef ForwardModel
    % ForwardModel class description TODO
    properties (SetAccess = private)
        solver
        film
        substrate
        options
    end

    properties %(Access = private)
        T0hat function_handle
        getR  function_handle = @(x) 0;
        getP  function_handle = @(x) 1;
        geths function_handle = @(x) inf;
        exp_if_log function_handle = @(x) x;
    end

    methods
        % CONSTRUCTOR
        function fm = ForwardModel(solver, film, substrate, options)
            % ForwardModel constructor description TODO
            % See also ForwardModel.private.validate_c_args, ForwardModel
            arguments
                solver    (1,1) IFTSolver;
                film      (1,1) Layer = Layer();
                substrate (1,1) Layer = Layer();

                options.scale (1,1) double {mustBeReal, mustBePositive} = 1;

                options.inf_sub_thick   (1,1) logical = true;
                options.phase_only      (1,1) logical = false;
                options.log_args        (1,1) logical = false;
                options.force_sym_solve (1,1) logical = false;
            end

            fm.solver = solver;
            fm.film = film;
            fm.substrate = substrate;
            fm.options = options;

            if options.log_args
                fm.exp_if_log = @exp;
            end

            if ~options.phase_only
                fm.getR = @(args)    args{3};
                fm.getP = @(ex_args) ex_args{3};
            end



            % solve for T0_hat symbolically if needed
            if options.force_sym_solve ...
                    || ~exist("@ForwardModel/private/T0hat_finite.m", "file") ...
                    || ~exist("@ForwardModel/private/T0hat_infinite.m", "file")
                solve_system_symbolically();
                rehash;
            end

            if options.inf_sub_thick
                if solver.method == IFTEnum.ifft2
                    fm.T0hat = @(args) T0hatBroadcast(@T0hat_infinite, args{:});
                else
                    fm.T0hat = @(args) T0hatRepmat(@T0hat_infinite, args{:});
                end
            else
                if solver.method == IFTEnum.ifft2
                    fm.T0hat = @(args) T0hatBroadcast(@T0hat_finite, args{:});
                else
                    fm.T0hat = @(args) T0hatRepmat(@T0hat_finite, args{:});
                end
            end
        end
    end
end