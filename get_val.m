function out = get_val(var)
    if isa(var, "DesignVariable")
        out = var.value();
    else
        out = var;
    end
end