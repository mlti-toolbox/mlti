clear; clc; clf;

currentDirectory = pwd;

load("isoisoex_COMSOL_output.mat")

rprobe = [5,10,20];

phi_COMSOL = angle(interp1(r, T0tilde, rprobe));

xprobe = sqrt(rprobe.^2/2);

Xprobe = [xprobe(:), xprobe(:)];

save("isoisoex_data_noise_free.mat", "T", "f", "Xprobe", "phi_COMSOL")