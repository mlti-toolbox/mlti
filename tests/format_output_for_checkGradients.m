function [Kv, Jac] = format_output_for_checkGradients(fn, varargin)
    if nargout < 2
        for i = 1:numel(varargin)
            varargin{i} = get_val(varargin{i});
        end
    end
    K = fn(varargin{:});
    if isa(K, "DesignVariable")
        Kv = K.value;
        Jac = K.Jac;
    else
        Kv = K;
        Jac = zeros(numel(K), 0);
    end
end