classdef ForwardModel
    properties
        f       % nx1 vector of frequencies at which to evaluate the forward model.
        x_probe % nx2 matrix [x_probe(1:n), y_probe(1:n)] of probe ofset locations.
        x
        x_step
        U
        V
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

            % default values
            sym_solve = false;
            x_max = 15 * max(x_probe(:));
            x_N = 100;

            % First, store all inputs
            params = struct();
            for k = 1:2:length(varargin)
                name = varargin{k};
                value = varargin{k+1};
                params.(name) = value;
            end
            
            % Now process in desired order
            if isfield(params, 'sym_solve')
                sym_solve = logical(params.sym_solve);
            end
            
            if isfield(params, 'force_sym_solve')
                sym_solve = logical(params.force_sym_solve);
            end
            
            if isfield(params, 'x_max')
                if ~isscalar(params.x_max)
                    error("'x_max' must be a scalar. %s matrix provided.", mat2str(size(params.x_max)))
                end
                x_max = params.x_max;
            end
            
            if isfield(params, 'x_N')
                if ~isscalar(params.x_N)
                    error("'x_N' must be a scalar. %s matrix provided.", mat2str(size(params.x_N)))
                end
                x_N = params.x_N;
            end

            x_step = x_max / x_N;
            
            if isfield(params, 'x_step')
                if ~isscalar(params.x_step)
                    error("'x_step' must be a scalar. %s matrix provided.", mat2str(size(params.x_step)))
                end
                x_step = params.x_step;  % Overrides the computed one, if any
            end

            obj.x_step = x_step;

            % Spatial Domain
            x = 0:x_step:x_max;
            obj.x = [-flip(x), x(2:end)];

            % Frequency Domain
            x_freq = 1 ./ (2 .* x_step);  % Spatial frequency
            x_N = floor(x_max ./ x_step) + 1;    % Number of points
            xi = x_freq ./ x_N .* (-x_N : x_N-1);  % Frequency vector
            [obj.U,obj.V] = meshgrid(xi,xi);  % Frequency matrix


            if ~(exist("@ForwardModel/T0_hat_finite.m", "file") ...
                && exist("@ForwardModel/T0_hat_infinite.m", "file"))
                sym_solve = true;
            end

            if sym_solve
                obj.solve_system_symbolically();
                disp("creating methods")
            end
        end
        
        function [phi, A] = transform_iFFT(obj, T0hat)
            % T0hat must be a square matrix of complex doubles
            T0 = ifftshift(ifft2(fftshift(T0hat)))/obj.x_step^2;  % Perform the inverse FFT
            PHI = angle(T0);  % Convert temperature data to phase lag
            phi = PHI(2:end,2:end);
            AMP = 2*abs(T0);
            A = AMP(2:end,2:end);
        end

        function [phi, A] = transform_int(obj, T0hat)
            % T0hat must be a function handle @(U,V)
            % T0 = @(x,y) integral2(@(U,V) T0hat(U,V) .* exp(2i * pi * (U .* x + V .* y)), -inf, inf, -inf, inf);
            epsilon = 1e-10;  % small radius around the singularity

            T0 = @(x, y) integral2(@(U, V) ...
                (U.^2 + V.^2 > epsilon^2) .* T0hat(U, V) .* exp(2i * pi * (U .* x + V .* y)), ...
                -inf, inf, -inf, inf, 'AbsTol',1e-10,'RelTol',1e-6);
            T0_at_x_probe = arrayfun(@(i) T0(obj.x_probe(i,1), obj.x_probe(i,2)), 1:size(obj.x_probe,1)).';
            phi = angle(T0_at_x_probe);
            A = 2*abs(T0_at_x_probe);
        end

        function [phi_at_f_x_probe, A_at_f_x_probe, dT_DC_at_x_probe] = eval_iFFT_infinite(obj, m)
            [X,Y] = meshgrid(obj.x);
            mc = num2cell(m);
            phi_at_f_x_probe = zeros(length(obj.f),length(obj.x_probe(:,1)));
            A_at_f_x_probe = zeros(length(obj.f),length(obj.x_probe(:,1)));

            for i = 1:length(obj.f)
                T0_hat = obj.T0_hat_infinite(mc{:}, obj.f(i), obj.U, obj.V);
                [phi, A] = obj.transform_iFFT(T0_hat);

                % Convert Z to complex representation
                phi_complex = exp(1i * phi);
                
                % Interpolate real and imaginary parts separately
                Re_interp = interp2(X, Y, real(phi_complex), obj.x_probe(:,1), obj.x_probe(:,2));
                Im_interp = interp2(X, Y, imag(phi_complex), obj.x_probe(:,1), obj.x_probe(:,2));
                
                % Recover the interpolated angle
                phi_at_f_x_probe(i,:) = atan2(Im_interp, Re_interp);

                A_at_f_x_probe(i,:) = interp2(X, Y, A, obj.x_probe(:,1), obj.x_probe(:,2));                
            end

            T0_hat = obj.T0_hat_infinite(mc{:}, 0, obj.U, obj.V);
            [~, dT_DC] = obj.transform_iFFT(T0_hat);
            dT_DC_at_x_probe = interp2(X, Y, dT_DC, obj.x_probe(:,1), obj.x_probe(:,2));
        end

        function [phi_at_f_x_probe, A_at_f_x_probe, dT_DC_at_x_probe] = eval_int_infinite(obj, m)
            mc = num2cell(m);
            phi_at_f_x_probe = zeros(length(obj.f),length(obj.x_probe(:,1)));
            A_at_f_x_probe = zeros(length(obj.f),length(obj.x_probe(:,1)));

            syms u v

            for i = 1:length(obj.f)
                T0_hat = matlabFunction(obj.T0_hat_infinite(mc{:}, obj.f(i), u, v), Vars=[u,v]);
                [phi, A] = obj.transform_int(T0_hat);
                phi_at_f_x_probe(i,:) = phi;
                A_at_f_x_probe(i,:) = A;                
            end

            T0_hat = matlabFunction(obj.T0_hat_infinite(mc{:}, 0, u, v), Vars=[u,v]);
            [~, dT_DC_at_x_probe] = obj.transform_int(T0_hat);
        end

        function phi = plot_phase(obj, m, f0, varargin)
            mc = num2cell(m);

            T0_hat = obj.T0_hat_infinite(mc{:}, f0, obj.U, obj.V);
            [phi, ~] = obj.transform_iFFT(T0_hat);

            plot_type = 'imagesc';
            x_units = 'micron';
            phi_units = 'rad';

            for k = 1:2:length(varargin)
                switch lower(varargin{k})
                    case 'plot_type'
                        plot_type = varargin{k+1};
                    case 'x_units'
                        x_units = varargin{k+1};
                    case 'phi_units'
                        phi_units = varargin{k+1};
                    case 'phase_units'
                        phi_units = varargin{k+1};
                    otherwise
                        error('Unsupported name-value pair: %s - %s', varargin{k}, varargin{k+1})
                end
            end

            x_plt = obj.x;
            
            if ismember(x_units, {'micron', 'um', 'micrometer'})
                x_plt = x_plt * 1e6;
                x_label = "$x$ [micron]";
                y_label = "$y$ [micron]";
            elseif ismember(x_units, {'mm', 'millimeter'})
                x_plt = x_plt * 1e3;
                x_label = "$x$ [mm]";
                y_label = "$y$ [mm]";
            elseif ismember(x_units, {'m', 'meter'})
                x_label = "$x$ [m]";
                y_label = "$y$ [m]";
            else
                error("Unsupported 'x_units': %s", x_units)
            end

            if ismember(phi_units, {'rad', 'radian', 'radians'})
                phi_label = "$\phi$ [rad]";
                phi_lim = [-pi,pi];
                phi_ticks = -pi:pi/4:pi;
                phi_tick_labels = {'-\pi', '-3\pi/4', '-\pi/2', '-\pi/4', '0', '\pi/4', '\pi/2', '3\pi/4', '\pi'};
            elseif ismember(phi_units, {'deg', 'degree', 'degrees'})
                phi = rad2deg(phi);
                phi_label = "$\phi$ [deg]";
                phi_lim = [-180,180];
                phi_ticks = -180:45:180;
                phi_tick_labels = num2cell(phi_ticks);
            elseif ismember(phi_units, {'rev', 'revolution', 'revolutions', 'cycle', 'cycles'})
                phi = phi/2/pi;
                phi_label = "$\phi$ [rev]";
                phi_lim = [-0.5,0.5];
                phi_ticks = -0.5:1/8:0.5;
                phi_tick_labels = {'-1/2', '-3/8', '-1/4','-1/8', '0', '1/8', '1/4', '3/8', '1/2'};
            else
                error("Unsupported 'phi_units': %s", phi_units)
            end

            if ismember(plot_type, {'imagesc', 'image'})
                imagesc(x_plt,x_plt,phi);
                axis xy equal
            elseif ismember(plot_type, {'contour'})
                contour(x_plt,x_plt,phi);
                axis xy equal
            elseif ismember(plot_type, {'surf', 'surface'})
                [X,Y] = meshgrid(x_plt);
                surf(X,Y,phi);
                shading interp
            else
                error("Unsupported 'plot_type': %s", plot_type)
            end

            xlim([min(x_plt),max(x_plt)])
            ylim([min(x_plt),max(x_plt)])
            xlabel(x_label, 'Interpreter', 'latex')
            ylabel(y_label, 'Interpreter', 'latex')
            
            colormap(hsv(360));
            c = colorbar;
            c.Ticks = phi_ticks;
            c.TickLabels = phi_tick_labels;
            clim(phi_lim)
            ylabel(c, phi_label, 'Interpreter', 'latex')
        end
    end
end