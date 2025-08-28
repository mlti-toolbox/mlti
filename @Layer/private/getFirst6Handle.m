function [ko2K, sz] = getFirst6Handle(obj)
    switch obj.isotropy
        case IsotropyEnum.isotropic
            ko2K = @(args) obj.iso2K(args{1});
            sz = 1;
        case IsotropyEnum.uniaxial
            switch obj.orient
                case OrientEnum.azpol
                    ko2K = @(args) obj.kpEuler2K(args{1}, args{1}, args{2}, args{3}, args{4}, zeros(size(args{4})), SeqEnum.ZYZ);
                    sz = 4;
                case OrientEnum.uvect
                    ko2K = @(args) obj.kv2K(args{1:4});
                    sz = 4;
                case OrientEnum.euler
                    ko2K = @(args) obj.kpEuler2K(args{1}, args{1}, args{2}, args{3}, args{4}, zeros(size(args{4})), obj.euler_seq);
                    sz = 4;
                case OrientEnum.uquat
                    ko2K = @(args) obj.kpq2K(args{1}, args{1}, args{2:6});
                    sz = 6;
                case OrientEnum.rotmat
                    ko2K = @(args) obj.kpR2K(args{1}, args{1}, args{2:11});
                    sz = 11;
                otherwise
                    error("Invalid OrientEnum with uniaxial IsotropyEnum.")
            end
        case IsotropyEnum.principal
            switch obj.orient
                case OrientEnum.euler
                    ko2K = @(args) obj.kpEuler2K(args{1:6}, obj.euler_seq);
                    sz = 6;
                case OrientEnum.uquat
                    ko2K = @(args) obj.kpq2K(args{1:7});
                    sz = 7;
                case OrientEnum.rotmat
                    ko2K = @(args) obj.kpR2K(args{1:12});
                    sz = 12;
                otherwise
                    error("Invalid OrientEnum with principal IsotropyEnum.")
            end
        case IsotropyEnum.tensor
            ko2K = @(args) deal(obj.exp_if_log(args{1}), args{2}, args{3}, obj.exp_if_log(args{4}), args{5}, obj.exp_if_log(args{6}));
            sz = 6;
        otherwise
            error("'OrientEnum.ko2K' only support uniaxial and principal conductivity representations.")
    end
end