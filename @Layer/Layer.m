classdef Layer
    properties
        isotropy, orient, euler_seq, inf_thick, phase_only, log_args
    end
    methods 
        function obj = Layer(isotropy, orient, euler_seq, options)
            arguments
                isotropy  (1,1) IsotropyEnum = IsotropyEnum.tensor;
                orient    (1,1) OrientEnum   = OrientEnum.na;
                euler_seq (1,1) SeqEnum      = SeqEnum.ZYZ;
                options.inf_thick  (1,1) logical = false;
                options.phase_only (1,1) logical = false;
                options.log_args   (1,1) logical = false;
            end
            obj.isotropy   = isotropy;
            obj.orient     = orient;
            obj.euler_seq  = euler_seq;
            obj.inf_thick  = options.inf_thick;
            obj.phase_only = options.phase_only;
            obj.log_args   = options.log_args;
        end
        % inputs: k-vars, o-vars, C, a, (R), (h)
    end
end