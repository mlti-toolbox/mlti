function [Kv, Jac] = format_output_for_checkGradients(fn, varargin)
    K = fn(varargin{:});
    if isa(K, "DesignVariable")
        Kv = K.value;
        Jac = K.Jac;
    else
        Kv = K;
        Jac = zeros(numel(K), 0);
    end
end