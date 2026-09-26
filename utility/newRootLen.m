function x = newRootLen(x, N)
    if isa(x, "DesignVariable")
        x = DesignVariable(x.value, x.indx, N);
    end
end