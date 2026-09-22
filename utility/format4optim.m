function [Kv, Jac] = format4optim(fn, x)
arguments
    fn (1,1) function_handle
    x (:,1) double
end
    if nargout < 2
        Kv = fn(x);
    else
        psi = fn(DesignVariable(x));
        if isa(psi, "DesignVariable")
            Kv = psi.value;
            Jac = psi.Jac;
        else
            Kv = psi;
            Jac = zeros(numel(psi), 0);
        end
    end
end