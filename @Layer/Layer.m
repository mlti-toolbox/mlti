classdef Layer < handle
    properties
        isotropy, orient, euler_seq
        toTensor
        inputStr
        inputLen
    end
    methods 
        function layer = Layer(isotropy, orient, euler_seq)
            arguments
                isotropy  (1,1) IsotropyEnum = IsotropyEnum.tensor;
                orient    (1,1) OrientEnum {cross_validate(orient, isotropy)}  = OrientEnum.na;
                euler_seq (1,1) SeqEnum    {cross_validate(euler_seq, orient)} = SeqEnum.na;
            end
            layer.isotropy   = isotropy;
            layer.orient     = orient;
            layer.euler_seq  = euler_seq;

            [layer.toTensor, layer.inputStr] = layer.getko2K();
            layer.inputLen = length(layer.inputStr);
        end
        function disp(layer)
            fprintf('  <a href = "https://k-joshua-kelley.github.io/MLTI/Documentation/Layer">Layer</a> with properties:\n\n');
            fprintf("     isotropy: %s\n", layer.isotropy);
            fprintf("       orient: %s\n", layer.orient);
            fprintf("    euler_seq: %s\n", layer.euler_seq);
            fprintf('     inputStr: ["%s"]', strjoin(layer.inputStr, '", "'));
        end
    end
    methods (Static, Access = public)
        function runTests(), tests(); end
    end
end