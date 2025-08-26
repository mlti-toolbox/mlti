function [K11, K21, K31, K22, K32, K33] = kpR2K(kp1, kp2, kp3, R11, R21, R31, R12, R22, R32, R13, R23, R33)
arguments
    kp1 (:,:) double
    kp2 (:,:) double
    kp3 (:,:) double
    R11 (1,:) double
    R21 (1,:) double 
    R31 (1,:) double
    R12 (1,:) double
    R22 (1,:) double
    R32 (1,:) double
    R13 (1,:) double
    R23 (1,:) double
    R33 (1,:) double
end
% kpR2K - TODO

    % Computes:
    % K = R*diag(kp)*R';
    % K = K(tril(true(size(K))));
    K11 = R11 .* R11 .* kp1 + R12 .* R12 .* kp2 + R13 .* R13 .* kp3;
    K21 = R11 .* R21 .* kp1 + R12 .* R22 .* kp2 + R13 .* R23 .* kp3;
    K31 = R11 .* R31 .* kp1 + R12 .* R32 .* kp2 + R13 .* R33 .* kp3;
    K22 = R21 .* R21 .* kp1 + R22 .* R22 .* kp2 + R23 .* R23 .* kp3;
    K32 = R21 .* R31 .* kp1 + R22 .* R32 .* kp2 + R23 .* R33 .* kp3;
    K33 = R31 .* R31 .* kp1 + R32 .* R32 .* kp2 + R33 .* R33 .* kp3;
end