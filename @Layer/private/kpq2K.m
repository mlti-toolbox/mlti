function [K11, K21, K31, K22, K32, K33] = kpq2K(obj, kp1, kp2, kp3, q1, q2, q3, q4)
arguments
    obj (1,1) Layer
    kp1 (:,:) double
    kp2 (:,:) double
    kp3 (:,:) double
    q1 (:,1) double
    q2 (:,1) double
    q3 (:,1) double
    q4 (1,1) double
end

kp1 = obj.exp_if_log(kp1);
kp2 = obj.exp_if_log(kp2);
kp3 = obj.exp_if_log(kp3);

R = quat2dcm([q1, q2, q3, q4]);  % 3-by-3-by-N
R = pagetranspose(R);  % Because quat2dcm returns rotation for row vectors.
R = num2cell(R, 3);
[K11, K21, K31, K22, K32, K33] = kpR2K(kp1, kp2, kp3, R{:});