clear; clc; close all

T = 500;

true_params = load("true_params.mat");
lnkf = reshape(log(polyval(true_params.gold_film.k, T)),1,1,[]);
lnCf = reshape(log(polyval(true_params.gold_film.c, T)) ...
     + log(polyval(true_params.gold_film.rho, T)), 1,1,[]);
lnaf = log(true_params.gold_film.alpha);
lnhf = log(true_params.gold_film.h);

lnks = log(polyval(true_params.YSZ.k, T));
lnCs = log(polyval(true_params.YSZ.c, T)) ...
         + log(polyval(true_params.YSZ.rho, T));
lnas = log(true_params.YSZ.alpha);

logitR = -inf;  % R = 0 (phase is independent of R)
lnRth = -inf;
sx = 2;
sy = 2;
P = 1000;
f = reshape(10.^(-5:-1),1,1,1,1,[]);

x_max = 100;

Nx = 384;

xprobe = linspace(0,x_max,1001);
Xprobe = [xprobe(:), xprobe(:)];

fm = ForwardModel("iso", "iso", true);

T0tilde = fm.solve( ...
    {lnkf}, {}, lnCf, lnaf, logitR, lnhf, ...
    {lnks}, {}, lnCs, lnas, logitR, [], ...
    lnRth, sx, sy, P, f, x_max, Nx, Xprobe);

plot(sqrt(Xprobe(:,1).^2+Xprobe(:,2).^2), squeeze(angle(T0tilde)))
hold on;
COMSOL = load("isoisoex_COMSOL_output.mat");
plot(COMSOL.r, unwrap(angle(squeeze(COMSOL.T0tilde(:,3,1,1:4:end)))), 'k')
xlim([0,30])
