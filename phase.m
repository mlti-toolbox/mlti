function [phi, Jac] = phase(T0tilde, Jac_T0tilde)

    phi = angle(T0tilde);

    if nargout > 1
        Jac = imag(conj(T0tilde(:)) .* Jac_T0tilde) ...
            ./ abs(T0tilde(:)).^2;
    end

end