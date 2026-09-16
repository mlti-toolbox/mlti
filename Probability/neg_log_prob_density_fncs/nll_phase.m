function [psi, Jac] = nll_phase(phi_obsi, phi_predi, kTi, kDi, doSum)
arguments
    phi_obsi 
    phi_predi 
    kTi 
    kDi 
    doSum = true;
end

% Note: log(besseli(n,x,0)) = log(besseli(n,x,1))+abs(real(x))
phi_obs  = get_val(phi_obsi);
phi_pred = get_val(phi_predi);
kT = get_val(kTi);
kD = get_val(kDi);

diff = phi_obs - phi_pred;
c = cos(diff);
kT2 = kT.*kT; kD2 = kD.*kD; kTkD = kT.*kD;
kS = sqrt(kT2 + kD2 + 2*kTkD.*c);
I0Stilde = besseli(0,kS,1);
log_I0S = log(I0Stilde) + kS;

norm_const = log(besseli(0,kT,1)) + kT + log(besseli(0,kD,1)) + kD + log(2*pi);

psi = norm_const - log_I0S;

if doSum
    psi = sum(psi, "all");
end

if nargout > 1
    s = sin(diff);
    kTkD_kS = kTkD./kS;
    I1I0S = besseli(1,kS,1) ./ I0Stilde;

    grad_x = I1I0S .* kTkD_kS .* s;

    Jac = zeros(numel(psi), 0);
    Jac = addGradient(Jac, phi_obsi, @() grad_x);
    Jac = addGradient(Jac, phi_predi, @() -grad_x);
    Jac = addGradient(Jac, kTi, @get_grad_kT);
    Jac = addGradient(Jac, kDi, @get_grad_kD);

    if doSum
        Jac = sum(Jac, 1);
    end
end
function grad_kT = get_grad_kT()
    % ratio I1/I0 at kT (use scaled for stability)
    I1I0T = besseli(1,kT,1) ./ besseli(0,kT,1);

    % reuse existing terms
    dkS_dkT = (kT + kD.*c) ./ kS;

    grad_kT = I1I0T - I1I0S .* dkS_dkT;
end
function grad_kD = get_grad_kD()
    % ratio I1/I0 at kD (use scaled for stability)
    I1I0D = besseli(1,kD,1) ./ besseli(0,kD,1);

    % derivative of kS with respect to kD
    dkS_dkD = (kD + kT.*c) ./ kS;

    grad_kD = I1I0D - I1I0S .* dkS_dkD;
end
end