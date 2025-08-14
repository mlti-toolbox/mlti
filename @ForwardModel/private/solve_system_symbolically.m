function solve_system_symbolically()
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 Cf af Rf hf
    syms Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 Cs as Rs hs
    syms Rth sx sy P f0 U V
    syms AA BB [6,1]
    syms LAMBDA [2,1]
    syms E [4,1]

    input_vars = [Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 Cf af Rf hf ...
                  Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 Cs as Rs hs ...
                  Rth sx sy P f0 U V];
    
    FF = @(AAi, BBi) [AAi;  AAi * BBi;  (Rth * AAi + 1) * BBi;  0];
    SS = @(AAi, BBi) [0;  -AAi;  -1;  AAi * BBi];
    
    M4 = [FF(AA1, BB1), FF(AA2, BB2), FF(AA3, BB3), SS(AA4, BB4), SS(AA5, BB5), SS(AA6, BB6)];
    C4 = [E(1:2);LAMBDA(1);E(3:4);LAMBDA(2)];
    sol4 = solve(M4*C4==0, E);
    Ep_finite = matlabFunction(sol4.E1, Vars=[AA; BB; LAMBDA; Rth]);
    Em_finite = matlabFunction(sol4.E2, Vars=[AA; BB; LAMBDA; Rth]);

    M3 = M4(1:3,[1:4,6]);
    C3 = C4([1:4,6]);
    sol3 = solve(M3*C3==0, E(1:3));
    Ep_infinite = matlabFunction(sol3.E1, Vars=[AA; BB; LAMBDA; Rth]);
    Em_infinite = matlabFunction(sol3.E2, Vars=[AA; BB; LAMBDA; Rth]);
               
    phu = exp(-2 .* pi.^2 .* sx.^2 .* U.^2);
    phv = exp(-2 .* pi.^2 .* sy.^2 .* V.^2);
    psi  = 0.25;
    
    I0f = P .* (1 - Rf);
    I0s = P .* (1 - Rf) .* (1 - Rs) .* exp(-af .* hf);
    
    lf = 2 .* pi .* (U .* Kf13 + V .* Kf23);
    ls = 2 .* pi .* (U .* Ks13 + V .* Ks23);
    
    gf = 4 .* pi.^2 .* (U.^2 .* Kf11 + 2 .* U .* V .* Kf12 + V.^2 .* Kf22) + pi * 2i .* f0 .* Cf;
    gs = 4 .* pi.^2 .* (U.^2 .* Ks11 + 2 .* U .* V .* Ks12 + V.^2 .* Ks22) + pi * 2i .* f0 .* Cs;
    
    epf = (1i .* lf + sqrt(gf .* Kf33 - lf.^2)) ./ -Kf33;
    emf = (1i .* lf - sqrt(gf .* Kf33 - lf.^2)) ./ -Kf33;
    eps = (1i .* ls + sqrt(gs .* Ks33 - ls.^2)) ./ -Ks33;
    ems = (1i .* ls - sqrt(gs .* Ks33 - ls.^2)) ./ -Ks33;
    
    Lf = phu .* phv .* psi .* af .* I0f ./ (gf + 2i .* lf .* af - Kf33 .* af.^2);
    Ls = phu .* phv .* psi .* as .* I0s ./ (gs + 2i .* ls .* as - Ks33 .* as.^2);
    
    AA_f_ep = 1i .* lf + Kf33 .* epf;
    AA_f_em = 1i .* lf + Kf33 .* emf;
    AA_f_ma = 1i .* lf - Kf33 .* af;
    AA_s_ep = 1i .* ls + Ks33 .* eps;
    AA_s_em = 1i .* ls + Ks33 .* ems;
    AA_s_ma = 1i .* ls - Ks33 .* as;
    
    BB_f_ep = exp(hf .* epf);
    BB_f_em = exp(hf .* emf);
    BB_f_ma = exp(hf .* -af);
    BB_s_ep = exp(hs .* eps);
    BB_s_em = exp(hs .* ems);
    BB_s_ma = exp(hs .* -as);
    
    AA = {AA_f_ep;AA_f_em;AA_f_ma;AA_s_ep;AA_s_em;AA_s_ma};
    BB = {BB_f_ep;BB_f_em;BB_f_ma;BB_s_ep;BB_s_em;BB_s_ma};
    LAMBDA = {Lf,Ls};

    T0_hat_finite   = Ep_finite(AA{:}, BB{:}, LAMBDA{:}, Rth)   + Em_finite(AA{:}, BB{:}, LAMBDA{:}, Rth)   + Lf;
    T0_hat_infinite = Ep_infinite(AA{:}, BB{:}, LAMBDA{:}, Rth) + Em_infinite(AA{:}, BB{:}, LAMBDA{:}, Rth) + Lf;

    matlabFunction(T0_hat_finite, Vars=input_vars, Optimize=true, File='@ForwardModel/private/T0_hat_finite', Outputs="T0_hat", Comments="Created by @ForwardModel/private/solve_system_symbolically");
    matlabFunction(T0_hat_infinite, Vars=input_vars([1:19,21:end]), Optimize=true, File='@ForwardModel/private/T0_hat_infinite', Outputs="T0_hat", Comments="Created by @ForwardModel/private/solve_system_symbolically");
end