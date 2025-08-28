function [K11, K21, K31, K22, K32, K33] = uniEuler2K(k_perp, k_par, t_az, t_pol, seq, exp_if_log)
arguments
    k_perp (:,:) double
    k_par (:,:) double
    t_az (1,:) double
    t_pol (1,:) double
    seq (1,1) SeqEnum
    exp_if_log (1,1) function_handle = @(x) x;
end

z = zeros(size(t_az));

[K11, K21, K31, K22, K32, K33] = kpEuler2K(k_perp, k_perp, k_par, t_az, t_pol, z, seq, exp_if_log);