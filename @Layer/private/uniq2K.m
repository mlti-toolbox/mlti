function [K11, K21, K31, K22, K32, K33] = uniq2K(k_perp, k_par, q1, q2, q3, q4, exp_if_log)
arguments
    k_perp (:,:) double
    k_par (:,:) double
    q1 (:,1) double
    q2 (:,1) double
    q3 (:,1) double
    q4 (1,1) double
    exp_if_log (1,1) function_handle = @(x) x;
end

[K11, K21, K31, K22, K32, K33] = kpq2K(k_perp, k_perp, k_par, q1, q2, q3, q4, exp_if_log);