function [K11, K21, K31, K22, K32, K33] = iso2K(obj, kiso)
arguments
    obj (1,1) Layer
    kiso (:,:) double
end

kiso = obj.exp_if_log(kiso);
z = zeros(size(kiso));

K11 = kiso; 
K21 = z;    K22 = kiso;
K31 = z;    K32 = z;    K33 = kiso;