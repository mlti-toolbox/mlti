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

Df = exp(get_val(lnkf)-get_val(lnCf)); % mm^2/s
Ds = exp(get_val(lnks)-get_val(lnCs)); % mm^2/s
Lthf = sqrt(reshape(Df,1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
Lths = sqrt(reshape(Ds,1,1,[]) ./ pi ./ reshape(f,1,1,1,1,[])); % um
x_max = 200;

Nx = 160;

xprobe = linspace(0,30,101);
Xprobe = [xprobe(:), xprobe(:)];

fm = ForwardModel("iso", "iso", true);

T0tilde = fm.solve( ...
    {lnkf}, {}, lnCf, lnaf, logitR, lnhf, ...
    {lnks}, {}, lnCs, lnas, logitR, [], ...
    lnRth, sx, sy, P, f, x_max, Nx, Xprobe);

colors = colororder;
COMSOL = load("isoisoex_COMSOL_output.mat");
subplot(2,1,1)
plot(COMSOL.r, unwrap(angle(squeeze(COMSOL.T0tilde(:,3,1,1:4:end)))), Color=colors(1,:))
hold on;
plot(sqrt(Xprobe(:,1).^2+Xprobe(:,2).^2), unwrap(squeeze(angle(T0tilde))), "--", Color=colors(2,:))
xlim([0,30])

subplot(2,1,2)
plot(COMSOL.r, unwrap(abs(squeeze(COMSOL.T0tilde(:,3,1,1:4:end)))), Color=colors(1,:))
hold on;
plot(sqrt(Xprobe(:,1).^2+Xprobe(:,2).^2), unwrap(squeeze(2*abs(T0tilde))), "--", Color=colors(2,:))
xlim([0,30])
yscale log
