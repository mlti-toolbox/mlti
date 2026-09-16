function [psi, Jac] = nl_vM(xi, mui, ki)
% Note: log(besseli(n,x,0)) = log(besseli(n,x,1))+abs(real(x))
% -log(vM) = -k * cos(x - mu) + ln(2 * pi * besseli(0,k,1)) + k

x = get_val(xi);
mu = get_val(mui);
k = get_val(ki);

diff = x - mu;
c = cos(diff);
I0tilde = besseli(0,k,1);
psi = log(2*pi*I0tilde) + k .* (1 - c);

if nargout > 1
    ks = k .* sin(diff);

    Jac = zeros(numel(psi), 0);
    Jac = addGradient(Jac, xi, @() ks);
    Jac = addGradient(Jac, mui, @() - ks);
    Jac = addGradient(Jac, ki, @() besseli(1,k,1) ./ I0tilde - c);
end