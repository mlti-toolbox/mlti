function [K11, K21, K31, K22, K32, K33] = kpq2K(kp1, kp2, kp3, q1, q2, q3, q4, exp_if_log)
arguments
    kp1 (:,:) double
    kp2 (:,:) double
    kp3 (:,:) double
    q1 (:,1) double
    q2 (:,1) double
    q3 (:,1) double
    q4 (1,1) double
    exp_if_log (1,1) function_handle = @(x) x;
end

R = quat2dcm([q1, q2, q3, q4]);  % 3-by-3-by-N
R = pagetranspose(R);  % Because quat2dcm returns rotation for row vectors.
R = num2cell(R, 3);

[K11, K21, K31, K22, K32, K33] = kpR2K(kp1, kp2, kp3, R{:}, exp_if_log);