function solve_system_symbolically(~)
    syms AA BB [6,1]
    syms LAMBDA [2,1]
    syms Rth
    syms E [4,1]
    syms obj
    syms m [24,1]
    syms f0 U V
    
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

    C_s  = m(7);  % Substrate mass density times specific heat capacity [J./m.^3./K]
    alpha_s  = m(8);  % Substrate optical absorption coefficient [1./m]
    R_s      = m(9);  % Substrate optical reflectivity [-]
    h_s = m(10);
    
    C_f  = m(17); % Film mass density times specific heat capacity [J./m.^3./K]
    alpha_f  = m(18); % Film optical absorption coefficient [1./m]
    R_f      = m(19); % Film optical reflectivity [-]
    h_f      = m(20); % Film thickness in the z-direction [m]
    
    Rth     = m(21); % Film-Substrate thermal contact resistance [m.^2.*K./W]
    
    s_x      = m(22); % Heating laser standard deviation in the x-direction [m]
    s_y      = m(23); % Heating laser standard deviation in the y-direction [m]
    P        = m(24); % Heating laser power [W]

    
    k_s11 = m(1); % Substrate thermal conductivity in the x1 direction [W./m./K]
    k_s22 = m(2); % Substrate thermal conductivity in the x1-x2 direction [W./m./K]
    k_s33 = m(3); % Substrate thermal conductivity in the x1-x3 direction [W./m./K]
    k_s12 = m(4); % Substrate thermal conductivity in the x2 direction [W./m./K]
    k_s13 = m(5); % Substrate thermal conductivity in the x2-x3 direction [W./m./K]
    k_s23 = m(6); % Substrate thermal conductivity in the x3 direction [W./m./K]
    
    k_f11 = m(11); % Film thermal conductivity in the x1 direction [W./m./K]
    k_f22 = m(12); % Film thermal conductivity in the x1-x2 direction [W./m./K]
    k_f33 = m(13); % Film thermal conductivity in the x1-x3 direction [W./m./K]
    k_f12 = m(14); % Film thermal conductivity in the x2 direction [W./m./K]
    k_f13 = m(15); % Film thermal conductivity in the x2-x3 direction [W./m./K]
    k_f23 = m(16); % Film thermal conductivity in the x3 direction [W./m./K]
                
    phu = exp(-2 .* pi.^2 .* s_x.^2 .* U.^2);
    phv = exp(-2 .* pi.^2 .* s_y.^2 .* V.^2);
    psi  = 0.25;
    
    I0f = P .* (1 - R_f);
    I0s = P .* (1 - R_f) .* (1 - R_s) .* exp(-alpha_f .* h_f);
    
    lf = 2 .* pi .* (U .* k_f13 + V .* k_f23);
    ls = 2 .* pi .* (U .* k_s13 + V .* k_s23);
    
    gf = 4 .* pi.^2 .* (U.^2 .* k_f11 + 2 .* U .* V .* k_f12 + V.^2 .* k_f22) + pi * 2i .* f0 .* C_f;
    gs = 4 .* pi.^2 .* (U.^2 .* k_s11 + 2 .* U .* V .* k_s12 + V.^2 .* k_s22) + pi * 2i .* f0 .* C_s;
    
    epf = (1i .* lf + sqrt(gf .* k_f33 - lf.^2)) ./ -k_f33;
    emf = (1i .* lf - sqrt(gf .* k_f33 - lf.^2)) ./ -k_f33;
    eps = (1i .* ls + sqrt(gs .* k_s33 - ls.^2)) ./ -k_s33;
    ems = (1i .* ls - sqrt(gs .* k_s33 - ls.^2)) ./ -k_s33;
    
    Lf = phu .* phv .* psi .* alpha_f .* I0f ./ (gf + 2i .* lf .* alpha_f - k_f33 .* alpha_f.^2);
    Ls = phu .* phv .* psi .* alpha_s .* I0s ./ (gs + 2i .* ls .* alpha_s - k_s33 .* alpha_s.^2);
    
    AA_f_ep = 1i .* lf + k_f33 .* epf;
    AA_f_em = 1i .* lf + k_f33 .* emf;
    AA_f_ma = 1i .* lf - k_f33 .* alpha_f;
    AA_s_ep = 1i .* ls + k_s33 .* eps;
    AA_s_em = 1i .* ls + k_s33 .* ems;
    AA_s_ma = 1i .* ls - k_s33 .* alpha_s;
    
    BB_f_ep = exp(h_f .* epf);
    BB_f_em = exp(h_f .* emf);
    BB_f_ma = exp(h_f .* -alpha_f);
    BB_s_ep = exp(h_s .* eps);
    BB_s_em = exp(h_s .* ems);
    BB_s_ma = exp(h_s .* -alpha_s);
    
    AA = {AA_f_ep;AA_f_em;AA_f_ma;AA_s_ep;AA_s_em;AA_s_ma};
    BB = {BB_f_ep;BB_f_em;BB_f_ma;BB_s_ep;BB_s_em;BB_s_ma};
    LAMBDA = {Lf,Ls};

    matlabFunction(Ep_finite(AA{:}, BB{:}, LAMBDA{:}, Rth)   + Em_finite(AA{:}, BB{:}, LAMBDA{:}, Rth)   + Lf, Vars=[obj; m; f0; U; V], Optimize=true, File='@ForwardModel/T0_hat_finite');
    matlabFunction(Ep_infinite(AA{:}, BB{:}, LAMBDA{:}, Rth) + Em_infinite(AA{:}, BB{:}, LAMBDA{:}, Rth) + Lf, Vars=[obj; m; f0; U; V], Optimize=true, File='@ForwardModel/T0_hat_infinite');
end