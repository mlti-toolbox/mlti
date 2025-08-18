function K6 = Rkp2K6(R,kp)
% Rkp2K6 constructs the thermal conductivity tensor from rotation matrix
% and principal conductivities.
% Inputs:
%   - R (N_probe-by-9) double = [R11,R21,R31,R12,R22,R32,R13,R23,R33]
%   - kp (N_train-by-3) double = [kp1, kp2, kp3]
% Outputs:
%   - K6 (N_probe-by-N_train-by-6) double = [K11, K12, K13, K22, K23, K33]

K11 = R(:,1).^2.*kp(:,1).'+R(:,4).^2.*kp(:,2).'+R(:,7).^2.*kp(:,3).';
K12 = R(:,1).*R(:,2).*kp(:,1).'+R(:,4).*R(:,5).*kp(:,2).'+R(:,7).*R(:,8).*kp(:,3).';
K13 = R(:,1).*R(:,3).*kp(:,1).'+R(:,4).*R(:,6).*kp(:,2).'+R(:,7).*R(:,9).*kp(:,3).';
K22 = R(:,2).^2.*kp(:,1).'+R(:,5).^2.*kp(:,2).'+R(:,8).^2.*kp(:,3).';
K23 = R(:,2).*R(:,3).*kp(:,1).'+R(:,5).*R(:,6).*kp(:,2).'+R(:,8).*R(:,9).*kp(:,3).';
K33 = R(:,3).^2.*kp(:,1).'+R(:,6).^2.*kp(:,2).'+R(:,9).^2.*kp(:,3).';
K6 = cat(3, K11, K12, K13, K22, K23, K33);
end