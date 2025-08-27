function [K11, K21, K31, K22, K32, K33] = iso2K(kiso)
arguments
    kiso (:,:) double
end

    K11 = kiso; K22 = kiso; K33 = kiso;

    z = zeros(size(kiso));
    K21 = z; K31 = z; K32 = z;

end
