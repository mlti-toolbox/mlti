classdef IsotropyEnum
    enumeration
        isotropic, uniaxial, principal, tensor
    end

    properties (Dependent)
        Nk % Number of independent thermal conductivity values for this representation.
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