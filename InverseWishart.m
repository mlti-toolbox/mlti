classdef InverseWishart
    properties (SetAccess = private)
        N     % dimensionality (real, scalar, integer > 0)
        scale % scale matrix (NxN, real, positive definite)
        df    % degrees of freedom (real, scalar > N - 1)
        log_norm_const % stores the log normalizing constant
        DI    % the transpose of the inverse of the Cholesky factor of 'scale', so that DI'*DI = inv(scale)
        mean
        mode
        covar
    end

    methods
        function obj = InverseWishart(scale, df)
            % check that 'scale' is real, symmetric, and positive definite
            if ~(isreal(scale) && isequal(scale, scale'))
                error("'scale' must be real and symmetric.")
            end
            [~, p] = chol(scale);
            if p ~= 0
                error("'scale' must be positive definite.")
            end

            obj.N = size(scale, 1);
            obj.scale = scale;

            if ~(isreal(df) && isscalar(df) && (df > obj.N - 1))
                error("'df' must be a real scalar > %d.", obj.N - 1)
            end

            obj.df = df;

            N = obj.N;
            log_multi_gamma = N * (N - 1) * log(pi) / 4 + ...
                sum(arrayfun(@(j) gammaln((df + 1 - j)/2), 1:N));

            obj.log_norm_const = df * log(det(scale)) / 2 ...
                               - df * N * log(2) / 2 ...
                               - log_multi_gamma;

            obj.mode = scale/(df + obj.N + 1);

            if df >= obj.N
                [~, obj.DI] = iwishrnd(scale,df);
            else
                obj.DI = NaN;
            end

            if df > obj.N + 1
                obj.mean = scale / (df - obj.N - 1);
            else
                obj.mean = NaN;
            end

            % Wikipedia and ChatGPT disagree here.  Check the library for Anderson, T. W. (2003).
            % An Introduction to Multivariate Statistical Analysis (3rd ed.). Wiley.
            if df > obj.N + 3
                const = (df - obj.N + 1) / ((df - obj.N) * (df - obj.N - 1)^2 * (df - obj.N - 3));
                obj.covar = @(i,j,k,l) const * (scale(i,k) * scale(j,l) + scale(i,l) * scale(j,k));
            else
                obj.covar = NaN;
            end


        end

        function log_prob = log_pdf(obj, X)
            if ~(isreal(X) && isequal(X, X') && isequal(size(X,1), obj.N))
                error("'X' must be a %dx%d real, symmetric matrix. Got %s", obj.N, obj.N, mat2str(X))
            end

            [~, p] = chol(X);
            if p ~= 0
                warning("'X' is not positive definite. Returning -inf.");
                log_prob = -inf;
                return
            end

            log_prob = obj.log_pdf_no_checks(X);
        end

        function log_prob = log_pdf_no_checks(obj, X)
            log_prob = obj.log_norm_const ...
                     - (obj.df + obj.N + 1) * log(det(X)) / 2 ...
                     - trace(obj.scale / X) / 2;
        end

        function log_probs = log_pdfs(obj, X)
            if iscell(X)
                log_probs = arrayfun(@(i) obj.log_pdf(X{i}), 1:length(X));
            elseif isequal(size(X,2), size(X,3), obj.N)
                log_probs = arrayfun(@(i) obj.log_pdf(squeeze(X(i,:,:))), 1:size(X,1));
            elseif isequal(size(X,1), size(X,2), obj.N)
                log_probs = arrayfun(@(i) obj.log_pdf(X(:,:,i)), 1:size(X,3));
            else
                error("'X' must be a cell of %dx%d matrices or an mx%dx%d or %dx%dxm matrix.", ...
                      obj.N, obj.N, obj.N, obj.N, obj.N, obj.N)
            end
        end

        function samples = sample(obj, num_samples)
            samples = arrayfun(@(~) iwishrnd(obj.scale,obj.df,obj.DI), 1:num_samples, UniformOutput=false);
        end
    end
end