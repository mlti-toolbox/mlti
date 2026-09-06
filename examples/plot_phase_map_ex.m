clear; clc;

% Isotropic film
lnkf = log(150); % log([W/m/K])
lnCf = log(3);   % log([J/cm^3/K])
lnaf = log(50);  % log([1/um])
logitRf = -inf;  % Rf = 0 (phase is independent of Rf)
lnhf = log(0.1); % log([um])

% Uniaxially anisotropic substrate
lnks_perp = log(15);
lnks_par = log(5);
vs1 = 1/sqrt(2); vs2 = 1/sqrt(2); vs3 = 0; % axis of rev.
lnCs = log(4);
lnas = log(10);
logitRs = -inf;

% Thermal contact resistance
lnRth = log(1e-6);

% Circular heating laser profile
sx = 5;
sy = 5;
P = 1;
f = 100e-6;

% Discretization
Df = exp(lnkf-lnCf); % mm^2/s
Ds = exp(0.5*(lnks_perp+lnks_par)-lnCs); % mm^2/s
Lthf = sqrt(Df ./ pi ./ f); % um
Lths = sqrt(Ds ./ pi ./ f); % um
x_max = 2*max(Lthf, Lths);

Nx = 2^9;

dx = x_max ./ floor(Nx/2);
du = 1 ./ (Nx * dx);
steps = -floor(Nx/2) : ceil(Nx/2) - 1;
x = steps(:)   .* dx;
y = steps(:).' .* dx;
u = steps(:)   .* du;
v = steps(:).' .* du;

% Solve
film_tensor = iso2tensor(lnkf);
substrate_tensor = uniax2tensor(lnks_perp, lnks_par, vs1, vs2,vs3);
T0hat = T0hat_infinite( ...
    film_tensor{:},lnCf,lnaf,logitRf,lnhf, ...
    substrate_tensor{:},lnCs,lnas,logitRs, ...
    lnRth,sx,sy,P,f,u,v ...
);

T0tilde = ifftshift(ifft2(fftshift(T0hat)))./dx./dx;

imagesc(x,y,angle(T0tilde.'))
colormap("hsv")
c = colorbar;
clim([-pi,pi])
axis equal

xlabel("$x$ [micron]", Interpreter="latex")
ylabel("$y$ [minron]", Interpreter="latex")
ylabel(c, "$\phi$ [rad]", Interpreter="latex")
c.Ticks = -pi:pi/4:pi;
c.TickLabels = { ...
    '$-\pi$', '$-{3\pi}/{4}$', '$-{\pi}/{2}$', '$-{\pi}/{4}$', '$0$', ...
    '${\pi}/{4}$', '${\pi}/{2}$', '${3\pi}/{4}$', ...
    '$\pi$'};

c.TickLabelInterpreter = 'latex';