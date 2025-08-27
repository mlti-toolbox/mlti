function [K11, K21, K31, K22, K32, K33] = kpEuler2K(kp1, kp2, kp3, t1, t2, t3, seq)
arguments
    kp1 (:,:) double
    kp2 (:,:) double
    kp3 (:,:) double
    t1 (:,1) double
    t2 (:,1) double
    t3 (:,1) double
    seq (1,1) SeqEnum
end

R = angle2dcm(t1, t2, t3, string(seq));  % 3-by-3-by-N
R = pagetranspose(R);  % Because quat2dcm returns rotation for row vectors.
R = num2cell(R, 3);
[K11, K21, K31, K22, K32, K33] = kpR2K(kp1, kp2, kp3, R{:});