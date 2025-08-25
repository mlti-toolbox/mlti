classdef IFTEnum
% IFTEnum - Inverse Fourier transform evaluation methods
%
% IFTEnum is an enumeration class that defines available methods for
% evaluating the 2D inverse Fourier transform.
%
% IFTEnum Enumerations:
%   IFFT2     - Use MATLAB's built-in ifft2 function
%   INTEGRAL2 - Use MATLAB's built-in integral2 function
%
% See also:
% ifft2, integral2,
% <a href="https://www.mathworks.com/help/matlab/enumeration-classes.html">Enumerations</a>,
% <a href="https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html">Enumerations for Property Values</a>
%
% Notes:
%   - ifft2 requires either 'x_max' or 'dx' (with optional 'Nx').
%   - integral2 ignores 'x_max', 'dx', and 'Nx' fields.

    enumeration
        ifft2
        integral2
    end

    methods
        function options = cross_validate(ift_method, options)
            % cross_validate - Validate that options match IFT method
            %
            % Syntax:
            %   IFTEnum.cross_validate(ift_method, options)
            %   options = IFTEnum.cross_validate(ift_method, options)
            %
            % Inputs:
            %   ift_method - IFTEnum enumeration
            %   options    - Struct of input arguments
            %
            % Description:
            %   Validates that required fields are provided for the chosen
            %   IFT method, and removes unused fields when not needed.
            %
            %   For ifft2:
            %     - Must specify either 'x_max' or 'dx'
            %     - If 'x_max', 'dx', and 'Nx' are all provided, 'Nx' is ignored
            %   For integral2:
            %     - 'x_max', 'dx', and 'Nx' are not used and will be removed
            %
            % Outputs:
            %   options - Updated struct (with unused fields removed)
            %
            % Notes:
            %   - If 'options' is not requested as output, changes are not
            %     assigned back to the struct, and a warning is issued.

            arguments
                ift_method (1,1) IFTEnum
                options struct
            end

            % Track changes
            opts_changed = false;
            
            out_warn_msg = "Field removed, but change not assigned back to the structure.";

            % Helper message generator
            drop_msg = @(name, val, reason) compose( ...
                "Input, %s = %g, ignored because %s.", ...
                name, val, reason ...
            );

            switch ift_method
                case IFTEnum.ifft2
                    % Need either x_max or dx
                    if ~isfield(options, "x_max") && ~isfield(options, "dx")
                        error("Must provide either 'x_max' or 'dx' when ift_method = 'ifft2'.");
                    end

                    % If all three provided, Nx is dropped
                    if all(isfield(options, ["x_max","dx","Nx"]))
                        if options.Nx ~= 256
                            warning(drop_msg("Nx", options.Nx, ...
                                "'dx' and 'x_max' were also provided and take priority"));
                        end
                        options = rmfield(options, "Nx");
                        opts_changed = true;
                    end

                case IFTEnum.integral2
                    % Drop x_max, dx, Nx if present
                    for name = ["x_max", "dx", "Nx"]
                        if isfield(options, name)
                            val = options.(name);
                            options = rmfield(options, name);
                            if name ~= "Nx" || val ~= 256
                                warning(drop_msg(name, val, "ift_method = 'integral2'"));
                            end
                            opts_changed = true;
                        end
                    end
            end

            % Warn if caller didn't capture modified options
            if opts_changed && nargout < 1
                warning(out_warn_msg)
            end
        end
    end
end