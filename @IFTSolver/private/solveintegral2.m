function T0tilde = solveintegral2(solver, T0hat, X_probe)
% T0hat (NT x N_pump x Nf)
% T0tilde (N_probe x NT x N_pump x Nf)
arguments
    solver (1,1) IFTSolver
    T0hat   (:,:,:) sym
    X_probe (:,2) double = [];
end
N_probe = size(X_probe,1);
if N_probe == 0
    T0tilde = @(X_probe) solveintegral2(solver, T0hat, X_probe);
    return
end
NT = size(T0hat,1);
N_pump = size(T0hat,2);
Nf = size(T0hat,3);

T0tilde = zeros([N_probe, NT, N_pump, Nf]);

syms u v real

for i = 1:N_probe
    x = X_probe(i,1);
    y = X_probe(i,2);
    expr1 = exp(2i*pi*(u*x + v*y));
    for j = 1:NT
        for k = 1:N_pump
            for l = 1:Nf
                expr = T0hat(j,k,l) * expr1;
                fhandle = matlabFunction(expr, 'Vars', {u, v});
                T0tilde(i,j,k,l) = 0;
                b = 0.1;
                step = 0.1;
                while true
                    new_val = integral2(fhandle, -b, b, -b, b);
                    if abs(angle(new_val)-angle(T0tilde(i,j,k,l))) < 1e-10
                        break
                    end
                    T0tilde(i,j,k,l) = new_val;
                    b = b + step;
                end
            end
        end
    end
end