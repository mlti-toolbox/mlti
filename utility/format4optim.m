function [fval, Jac] = format4optim(fn, x)
arguments
    fn (1,1) function_handle
    x (:,1) double
end
    if nargout < 2
        fval = fn(x);
    else
        out = fn(DesignVariable(x));
        if isa(out, "DesignVariable")
            fval = out.value;
            Jac = out.Jac;
        else
            fval = out;
            Jac = zeros(numel(out), 0);
        end
    end
end