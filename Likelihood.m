classdef Likelihood < DistPDF
    properties (SetAccess = private)
        phi_obs % observed phase lag (1xN)
        kappa_T % concentration for theoretical prediction (1xN)
        kappa_D % concentration for observations (1xN)
        log_norm_const % stores the normalizing constant (1xN)
    end

    methods
        function obj = Likelihood(phi_obs, kappa_T, kappa_D)
            [format_params, obj.N] = obj.format_constructor_parameters('phi_obs', phi_obs, 'kappa_T', kappa_T, 'kappa_D', kappa_D);
            [obj.phi_obs,obj.kappa_T,obj.kappa_D] = deal(format_params{:});
            obj.log_norm_const = log(besseli(0,obj.kappa_T,1)) ...
                               + log(besseli(0,obj.kappa_D,1)) ...
                               + log(2*pi) + obj.kappa_T + obj.kappa_D;
        end

        function p = log_pdfs_vector_no_checks(obj, g)
            % g is mx1 or m×N matrix, where each row is an N-dimensional observation
            kappa_star = abs(obj.kappa_T .* exp(1i * g) + obj.kappa_D .* exp(1i * obj.phi_obs));
            p = log(besseli(0,kappa_star,1)) + kappa_star - obj.log_norm_const;
        end
    end
end