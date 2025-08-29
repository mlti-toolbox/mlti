function [K11, K21, K31, K22, K32, K33] = K2K(K11, K21, K31, K22, K32, K33, exp_if_log)
arguments
    K11 (:,:) double
    K21 (:,:) double
    K31 (:,:) double
    K22 (:,:) double
    K32 (:,:) double
    K33 (:,:) double
    exp_if_log (1,1) function_handle = @(x) x;
end

K11 = exp_if_log(K11);
K22 = exp_if_log(K22);
K33 = exp_if_log(K33);