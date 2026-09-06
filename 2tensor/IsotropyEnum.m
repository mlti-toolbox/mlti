classdef IsotropyEnum
    enumeration
        isotropic, uniaxial, principal, tensor
    end

    properties (Dependent)
        toTensor
    end
    
    methods
        function toTensor = get.toTensor(obj)
            switch obj
            case IsotropyEnum.isotropic
                toTensor = @iso2tensor;
            case IsotropyEnum.uniaxial
                toTensor = @uniax2tensor;
            case IsotropyEnum.principal
                toTensor = @principal2tensor;
            case IsotropyEnum.tensor
                toTensor = @tensor2tensor;
            end
        end
    end
end