function T0tilde = solvevpaintegral(solver, T0hat, X_probe)
% T0hat (NT x N_pump x Nf)
% T0tilde (N_probe x NT x N_pump x Nf)
arguments
    solver (1,1) IFTSolver
    T0hat   (:,:,:) sym
    X_probe (:,2) double = [];
end
N_probe = size(X_probe,1);
if N_probe == 0
    T0tilde = @(X_probe) solvevpaintegral(solver, T0hat, X_probe);
    return
end
NT = size(T0hat,1);
N_pump = size(T0hat,2);
Nf = size(T0hat,3);

syms u v real

T0hat = repmat(shiftdim(T0hat,-1), N_probe, 1, 1, 1);
x = repmat(X_probe(:,1), 1, NT, N_pump, Nf);
y = repmat(X_probe(:,2), 1, NT, N_pump, Nf);

Iu = vpaintegral(T0hat .* exp(2i*pi*(u*x + v*y)), u, -inf, inf, solver.args{:});

T0tilde = vpaintegral(Iu, -inf, 0, solver.args{:}) + vpaintegral(Iu, 0, inf, solver.args{:});