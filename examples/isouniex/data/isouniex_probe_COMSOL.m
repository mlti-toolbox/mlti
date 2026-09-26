clear; clc;

load("isouniex_COMSOL_output.mat")

vartheta = deg2rad((0:15:90)).';
dr = [5,10,20];
xq = dr.*cos(vartheta);
yq = dr.*sin(vartheta);
xq = xq(:);
yq = yq(:);
Xprobe = [xq, yq];

F = scatteredInterpolant(xprobe, yprobe, T0tilde, 'linear', 'none');

phi_COMSOL = angle(F(xq,yq));

save("isouniex_data_noise_free.mat", "T", "f", "Xprobe", "phi_COMSOL")