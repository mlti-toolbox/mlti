function phi = phase(T0tildei)
    T0tilde = get_val(T0tildei);
    phi = angle(T0tilde);

    if isa(T0tildei, "DesignVariable")
        Jac = imag(conj(T0tilde(:)) .* T0tildei.Jac) ...
            ./ abs(T0tilde(:)).^2;
        phi = DesignVariable(phi, [], size(Jac,2), Jac);
    end
end