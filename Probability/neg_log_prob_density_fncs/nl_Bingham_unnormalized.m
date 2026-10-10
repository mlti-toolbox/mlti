function psi = nl_Bingham_unnormalized(xi, Q, k)
x = get_val(xi);
if isa(Q, "DesignVariable") || isa(k, "DesignVariable")
    error("This function does not currently DesignVariable inputs for Q nor k.")
end

A = Q * diag([0; k(:)]) * Q.';
psi = x.' * A * x;

if isa(xi, "DesignVariable")
    Jac = sparse(1, xi.indx, 2 * A * x, 1, xi.rootLen);
    psi = DesignVariable(psi, [], xi.rootLen, Jac);
end
end