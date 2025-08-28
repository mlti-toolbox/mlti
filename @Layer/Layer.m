classdef Layer < handle
    properties
        isotropy, orient, euler_seq, inf_thick, phase_only, log_args
    end
    properties (Access = private)
        getLast4   (1,1) function_handle = @() NaN;
        ko2K       (1,1) function_handle = @() NaN;
        exp_if_log (1,1) function_handle = @() NaN;
        Nin (1,1) uint8;
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

            if obj.log_args
                obj.exp_if_log = @(x) exp(x);
            else
                obj.exp_if_log = @(x) x;
            end

            [obj.getLast4, sz1] = obj.getLast4Handle();
            [obj.ko2K,     sz2] = obj.getFirst6Handle();
            obj.Nin = sz1 + sz2 + 1;
        end
    end
    methods (Static, Access = public)
        function runTests(), tests(); end
    end
end