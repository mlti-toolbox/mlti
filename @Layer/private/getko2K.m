function [ko2K, str] = getko2K(layer)
    switch layer.isotropy
        case IsotropyEnum.isotropic
            ko2K = @iso2K;
            str = "k";
        case IsotropyEnum.uniaxial
            [ko2K, str] = getko2K_helper(layer, "uni", "k" + ["⊥", "∥"]);
        case IsotropyEnum.principal
            [ko2K, str] = getko2K_helper(layer, "kp", "kp" + (1:3));
        case IsotropyEnum.tensor
            ko2K = @K2K;
            [i,j] = ndgrid(1:3,1:3);
            str = "k" + i + j;
            str = str(tril(true(size(str))))';
        otherwise
            error("Developer Error: Isotropy type exists in IsotropyEnum, but not supported in getko2K.")
    end
    assert(ismember(nargin(ko2K), [length(str) + 1, -1]), "Developer Error: length(str) != narargin - 1.")
end

function [ko2K, str] = getko2K_helper(layer, funpre, k_str)
    switch layer.orient
        case OrientEnum.azpol
            ko2K = str2func(funpre + "Azpol2K");
            str = [k_str, "θ" + ["_az", "_pol"]];
        case OrientEnum.uvect
            ko2K = str2func(funpre + "v2K");
            str = [k_str, "v" + (1:3)];
        case OrientEnum.euler
            N = length(k_str);
            if N == 2, ko2K = @layer.uniEuler2K;
            else, ko2K = @layer.kpEuler2K; end
            seq_str_arr = string(char(layer.euler_seq)')';
            str = [k_str, "θ" + seq_str_arr(1:N) + (1:N)];
        case OrientEnum.uquat
            ko2K = str2func(funpre + "q2K");
            str = [k_str, "q" + (1:4)];
        case OrientEnum.rotmat
            ko2K = str2func(funpre + "R2K");
            [i,j] = ndgrid(1:3,1:3);
            str = [k_str, "R" + i(:)' + j(:)'];
        otherwise
            error("Developer Error: Invalid OrientEnum with uniaxial IsotropyEnum not caught in Layer constructor.")
    end
end