function fh = ko2K(k_type, o_type)
    arguments
        k_type (1,1) IsotropyEnum;
        o_type (1,1) OrientEnum = OrientEnum.na;
    end

    switch k_type
        case IsotropyEnum.isotropic
            fh = @iso2K;
        case IsotropyEnum.uniaxial
            switch o_type
                case OrientEnum.azpol
                    fh = @(k_perp, k_par, t_az, t_pol) kpEuler2K(k_perp, k_perp, k_par, t_az, t_pol, zeros(size(t_az)), 'ZYZ');
                case OrientEnum.uvect
                    fh = @kv2K;
                case OrientEnum.euler
                    fh = @(k_perp, k_par, t1, t2) kpEuler2K(k_perp, k_perp, k_par, t1, t2, zeros(size(t1)), seq);
                case OrientEnum.uquat
                    fh = @(k_perp, k_par, q1, q2, q3, q4) kpq2K(k_perp, k_perp, k_par, q1, q2, q3, q4);
                case OrientEnum.rotmat
                    fh = @(k_perp, k_par, R11, R21, R31, R12, R22, R32, R13, R23, R33) kpR2K(k_perp, k_perp, k_par, R11, R21, R31, R12, R22, R32, R13, R23, R33);
                otherwise
                    error("Invalid OrientEnum with uniaxial IsotropyEnum.")
            end
        case IsotropyEnum.principal
            switch o_type
                case OrientEnum.euler
                    fh = @kpEuler2K;
                case OrientEnum.uquat
                    fh = @kpq2K;
                case OrientEnum.rotmat
                    fh = @kpR2K;
                otherwise
                    error("Invalid OrientEnum with principal IsotropyEnum.")
            end
        case IsotropyEnum.tensor
            fh = @(varargin) varargin{:};
        otherwise
            error("'OrientEnum.ko2K' only support uniaxial and principal conductivity representations.")
    end
end