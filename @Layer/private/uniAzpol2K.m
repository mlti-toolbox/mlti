function [K11, K21, K31, K22, K32, K33] = uniAzpol2K(k_perp, k_par, t_az, t_pol, exp_if_log)
arguments
    k_perp (:,:) double
    k_par (:,:) double
    t_az (1,:) double
    t_pol (1,:) double
    exp_if_log (1,1) function_handle = @(x) x;
end

z = zeros(size(t_az));

R = angle2dcm(t_az, t_pol, z, "ZYZ");  % 3-by-3-by-N
R = pagetranspose(R);  % Because quat2dcm returns rotation for row vectors.
R = num2cell(R, 3);

[K11, K21, K31, K22, K32, K33] = kpR2K(k_perp, k_perp, k_par, R{:}, exp_if_log);