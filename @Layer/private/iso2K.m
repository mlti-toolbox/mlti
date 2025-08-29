function [K11, K21, K31, K22, K32, K33] = iso2K(kiso, exp_if_log)
arguments
    kiso (:,:) double
    exp_if_log (1,1) function_handle = @(x) x;
end
nargin

kiso = exp_if_log(kiso);
z = zeros(size(kiso));

K11 = kiso; 
K21 = z;    K22 = kiso;
K31 = z;    K32 = z;    K33 = kiso;