function Jac = combineJacobians(Jac, x, jac_fun)
    if ~isa(x, "DesignVariable")
        return
    end

    J = jac_fun();

    if isempty(Jac)
        Jac = J;
    else
        Jac = Jac + J;
    end
end