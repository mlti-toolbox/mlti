function [K11, K21, K31, K22, K32, K33] = uniR2K(k_perp, k_par, R11, R21, R31, R12, R22, R32, R13, R23, R33, exp_if_log)
arguments
    k_perp (:,:) double
    k_par (:,:) double
    R11 (1,:) double
    R21 (1,:) double 
    R31 (1,:) double
    R12 (1,:) double
    R22 (1,:) double
    R32 (1,:) double
    R13 (1,:) double
    R23 (1,:) double
    R33 (1,:) double
    exp_if_log (1,1) function_handle = @(x) x;
end

[K11, K21, K31, K22, K32, K33] = kpR2K(k_perp, k_par, kp3, R11, R21, R31, R12, R22, R32, R13, R23, R33, exp_if_log);