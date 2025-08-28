function [K11, K21, K31, K22, K32, K33] = kv2K(obj, k_perp, k_par, v1, v2, v3)
% kperp, kpar (NT-by-1) or (NT-by-N_pump)
% v1, v2, v3 (N_pump-by-1) -> (1-by-N_pump)
% k11, k21, k31, k22, k32, k33 (NT-by-N_pump)
arguments
    obj (1,1) Layer
    k_perp (:,:) double
    k_par (:,:) double
    v1 (1,:) double
    v2 (1,:) double
    v3 (1,:) double
end

k_perp = obj.exp_if_log(k_perp);
k_perp = obj.exp_if_log(k_perp);

kpar_minus_kperp = k_par - k_perp;

K11 = kpar_minus_kperp .* v1 .* v1 + k_perp;
K21 = kpar_minus_kperp .* v2 .* v1;
K31 = kpar_minus_kperp .* v3 .* v1;
K22 = kpar_minus_kperp .* v2 .* v2 + k_perp;
K32 = kpar_minus_kperp .* v3 .* v2;
K33 = kpar_minus_kperp .* v3 .* v3 + k_perp;