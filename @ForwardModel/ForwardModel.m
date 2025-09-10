classdef ForwardModel
    % ForwardModel class description TODO
    properties (SetAccess = private)
        % c_args - Struct of constructor arguments.
        c_args struct = struct();

        % fun_inputs - Input structure for ForwardModel functions.
        fun_inputs struct = struct();

        % xu - Nx-by-2 array of spatial and spatial-frequency vectors.
        xu (:,2) double

        ift_solver
        film
        substrate
    end

    properties (Access = private)
        T0_hat function_handle
        getRf  function_handle = @(x) 0;
        getRs  function_handle = @(x) 0;
        getP   function_handle = @(x) 1;
        exp_if_log function_handle = @(x) x;
    end

    methods
        % CONSTRUCTOR
        function this = ForwardModel(ift_solver, film, substrate, options)
            % ForwardModel constructor description TODO
            % See also ForwardModel.private.validate_c_args, ForwardModel
            arguments
                ift_solver (1,1) IFTSolver;
                film       (1,1) Layer = Layer();
                substrate  (1,1) Layer = Layer();

                options.scale (1,1) double {mustBeReal, mustBePositive} = 1;

                options.inf_sub_thick   (1,1) logical = true;
                options.phase_only      (1,1) logical = false;
                options.log_args        (1,1) logical = false;
                options.force_sym_solve (1,1) logical = false;
            end

            this.ift_solver = ift_solver;
            this.film = film;
            this.substrate = substrate;

            if options.log_args
                this.exp_if_log = @exp;
            end

            if ~options.phase_only
                this.getRf = @(film_args) film_args{length(film.inputStr)+3};
                this.getRs = @(sub_args)  sub_args{length(substrate.inputStr)+3};
                this.getP  = @(ex_args)   ex_args{3};
            end

            % solve for T0_hat symbolically if needed
            if options.force_sym_solve ...
                    || ~exist("@ForwardModel/private/T0_hat_finite.m", "file") ...
                    || ~exist("@ForwardModel/private/T0_hat_infinite.m", "file")
                solve_system_symbolically();
                rehash;
            end

            if options.inf_sub_thick
                this.T0_hat = @T0_hat_infinite;
            else
                this.T0_hat = @T0_hat_finite;
            end
            % 
            % 
            % 
            % fprintf("ForwardModel object created with the following constructor arguments:\n\n");
            % disp(options);
            % this.c_args = options;
            % 
            % % Get function input structure
            % this.fun_inputs = this.get_input_structure();
            % fprintf("\nFunction inputs 'M', 'O', 'chi', 'f0', and 'X_probe' should be formatted as follows:\n\n")
            % for name = string(fieldnames(this.fun_inputs))'
            %     disp(strjoin("    " + splitlines(this.fun_inputs.(name).msg), newline))
            % end
        end
    end
end