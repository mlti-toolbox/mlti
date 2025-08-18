function phi = plot(fm, M, Theta, chi, f0, varargin)
% PLOT summary TODO

    if mod(length(varargin), 2) == 0 % length(varargin) is even
        x_probe = []; % user called plot(fm, M, Theta, chi, f0, varargin)
    else
        % user called plot(fm, M, Theta, chi, f0, x_probe, varargin)
        x_probe = varargin{1};
        varargin = varargin(2:end);
    end

    % parse varargin
    plot_type = 'imagesc';
    phase_units = 'rad';

    for k = 1:2:length(varargin)
        switch lower(varargin{k})
            case 'plot_type'
                plot_type = varargin{k+1};
            case 'phase_units'
                phase_units = varargin{k+1};
            otherwise
                error('Unsupported name-value pair: %s - %s', varargin{k}, varargin{k+1})
        end
    end
    
    if fm.cargs.phase_only
        phi = fm.solve(M, Theta, chi, f0);
    else
        [phi, A, DC] = fm.solve(M, Theta, chi, f0);
    end

    if ismember(phase_units, {'rad', 'radian', 'radians'})
        phi_label = "$\phi$ [rad]";
        phi_lim = [-pi,pi];
        phi_ticks = -pi:pi/4:pi;
        phi_tick_labels = {'-\pi', '-3\pi/4', '-\pi/2', '-\pi/4', '0', '\pi/4', '\pi/2', '3\pi/4', '\pi'};
    elseif ismember(phase_units, {'deg', 'degree', 'degrees'})
        phi = rad2deg(phi);
        phi_label = "$\phi$ [deg]";
        phi_lim = [-180,180];
        phi_ticks = -180:45:180;
        phi_tick_labels = num2cell(phi_ticks);
    elseif ismember(phase_units, {'rev', 'revolution', 'revolutions', 'cycle', 'cycles'})
        phi = phi/2/pi;
        phi_label = "$\phi$ [rev]";
        phi_lim = [-0.5,0.5];
        phi_ticks = -0.5:1/8:0.5;
        phi_tick_labels = {'-1/2', '-3/8', '-1/4','-1/8', '0', '1/8', '1/4', '3/8', '1/2'};
    else
        error("Unsupported 'phi_units': %s", phase_units)
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

    if ~isempty(x_probe)
        hold on
        scatter(x_probe(:,1), x_probe(:,2), 3, 'k', 'filled')
    end

    xlim([min(fm.x),max(fm.x)])
    ylim([min(fm.x),max(fm.x)])
    xunit = scale2xunit(fm.scale);
    xlabel("$x$ " + xunit, 'Interpreter', 'latex')
    ylabel("$y$ " + xunit, 'Interpreter', 'latex')
    
    colormap(hsv(360));
    c = colorbar;
    c.Ticks = phi_ticks;
    c.TickLabels = phi_tick_labels;
    clim(phi_lim)
    ylabel(c, phi_label, 'Interpreter', 'latex')
end