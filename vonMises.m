classdef vonMises < DistPDF
    properties (SetAccess = private)
        mu % mean (1xN).
        kappa % concentration (1xN)
        log_norm_const % stores the normalizing constant (1xN)
    end

    methods
        function obj = vonMises(mu, kappa)
            [format_params, obj.N] = obj.format_constructor_parameters('mu', mu, 'kappa', kappa);
            [obj.mu,obj.kappa] = deal(format_params{:});
            obj.log_norm_const = log(2*pi*besseli(0, obj.kappa, 1)); % '1' for scaled
        end

        function p = log_pdfs_vector_no_checks(obj, x)
            % x is mx1 or m×N matrix, where each row is an N-dimensional observation
            p = obj.kappa .* (cos(x - obj.mu) - 1) - obj.log_norm_const;
        end
    end
end