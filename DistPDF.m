% DistPDF Abstract superclass for independent multivariate distributions.
% Subclasses must implement log_pdfs_vector_no_checks(x), which returns
% a matrix of log-pdf values. This base class provides validated and
% convenient wrappers for computing log-pdf and pdf values.
classdef (Abstract) DistPDF
    properties (SetAccess = protected)
        N % Dimensionality
    end

    methods (Abstract)
        log_pdfs_vector_no_checks(obj, x)
    end

    methods
        function [formatted_params,N] = format_constructor_parameters(~, varargin)
            % FORMAT_CONSTRUCTOR_PARAMETERS ensures each input is a scalar or 1×N.
            % Inputs should be name/value pairs: ('mu', mu, 'kappa', kappa)
            % Each value is reshaped to a row vector, and scalars are expanded to 1×N.
            % Returns a 1×(numPairs) cell array of row vectors.
        
            num_params = numel(varargin);
            if mod(num_params, 2) ~= 0
                error("Arguments must be name/value pairs.");
            end
        
            % Extract values and compute maximum size
            values = varargin(2:2:end);
            lengths = cellfun(@numel, values);
            N = max(lengths);
        
            formatted_params = cell(1, num_params / 2);
        
            for i = 1:2:num_params
                name = varargin{i};
                val = varargin{i + 1};
        
                if ~isvector(val)
                    warning("'%s' will be cast into a row vector: %s", ...
                        name, mat2str(size(val)));
                end
        
                val_row = val(:)';  % force row vector
        
                % Expand scalar to match N
                if isscalar(val_row)
                    val_row = repmat(val_row, 1, N);
                end
        
                % Final check
                if numel(val_row) ~= N
                    error("Parameter '%s' must be a scalar or a 1x%d row vector. Got size %s.", ...
                        name, N, mat2str(size(val_row)));
                end
        
                formatted_params{(i + 1) / 2} = val_row;
            end
        end

        function p = log_pdfs_vector(obj, x)
            % g must be mxN or mx1
            if ~ismatrix(x) || ~(isequal(size(x, 2), obj.N) || isequal(size(x, 2), 1))
                error("x must be an mx%d or mx1 matrix. %s matrix provided.", obj.N, mat2str(size(x)))
            end

            p = obj.log_pdfs_vector_no_checks(x);
        end

        function p = log_pdf_no_checks(obj, x)
            p = sum(obj.log_pdfs_vector_no_checks(x),2);
        end

        function p = log_pdf(obj, x)
            % g must be mxN matrix.
            if ~ismatrix(x) || ~isequal(size(x, 2), obj.N)
                error("x must be an mx%d matrix. %s matrix provided.", obj.N, mat2str(size(x)))
            end

            p = obj.log_pdf_no_checks(x);
        end

        function p = pdfs_vector_no_checks(obj, x)
            p = exp(obj.log_pdfs_vector_no_checks(x));
        end

        function p = pdfs_vector(obj, x)
            p = exp(obj.log_pdfs_vector(x));
        end

        function p = pdf_no_checks(obj,x)
            p = exp(obj.log_pdf_no_checks(x));
        end

        function p = pdf(obj, x)
            p = exp(obj.log_pdf(x));
        end
    end

end