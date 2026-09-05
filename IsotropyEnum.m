classdef IsotropyEnum
    enumeration
        isotropic, uniaxial, principal, tensor
    end

    properties (Dependent)
        lambda_handle
        gamma_handle
    end
    
    methods
        function Nk = get.Nk(obj)
            switch obj
                case IsotropyEnum.isotropic
                    Nk = 1;
                case IsotropyEnum.uniaxial
                    Nk = 2;
                case IsotropyEnum.principal
                    Nk = 3;
                case IsotropyEnum.tensor
                    Nk = 6;
            end
        end
    end
end