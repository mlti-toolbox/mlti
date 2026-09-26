function tests = test_T0hat_finite()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([1,10]);
    n = randi([1,10]);
    Nf = randi([1,10]);
    Nx = randi([1,10]);

    testCase.TestData.Kf11    = unifrnd(0.1,500,N,n);
    testCase.TestData.Kf22    = unifrnd(0.1,500,N,n);
    testCase.TestData.Kf33    = unifrnd(0.1,500,N,n);
    Kf11Kf22 = testCase.TestData.Kf11.*testCase.TestData.Kf22;
    Kf11Kf33 = testCase.TestData.Kf11.*testCase.TestData.Kf33;
    Kf22Kf33 = testCase.TestData.Kf22.*testCase.TestData.Kf33;
    testCase.TestData.Kf12    = unifrnd(-sqrt(Kf11Kf22),sqrt(Kf11Kf22));
    testCase.TestData.Kf13    = unifrnd(-sqrt(Kf11Kf33),sqrt(Kf11Kf33));
    testCase.TestData.Kf23    = unifrnd(-sqrt(Kf22Kf33),sqrt(Kf22Kf33));
    testCase.TestData.lnCf    = unifrnd(-0.3,2.3,N,1);
    testCase.TestData.lnaf    = unifrnd(-5,5);
    testCase.TestData.logitRf = unifrnd(-5,5);
    testCase.TestData.lnhf    = unifrnd(-3,5);
    testCase.TestData.Ks11    = unifrnd(0.1,500,N,n);
    testCase.TestData.Ks22    = unifrnd(0.1,500,N,n);
    testCase.TestData.Ks33    = unifrnd(0.1,500,N,n);
    Ks11Ks22 = testCase.TestData.Ks11.*testCase.TestData.Ks22;
    Ks11Ks33 = testCase.TestData.Ks11.*testCase.TestData.Ks33;
    Ks22Ks33 = testCase.TestData.Ks22.*testCase.TestData.Ks33;
    testCase.TestData.Ks12    = unifrnd(-sqrt(Ks11Ks22),sqrt(Ks11Ks22));
    testCase.TestData.Ks13    = unifrnd(-sqrt(Ks11Ks33),sqrt(Ks11Ks33));
    testCase.TestData.Ks23    = unifrnd(-sqrt(Ks22Ks33),sqrt(Ks22Ks33));
    testCase.TestData.lnCs    = unifrnd(-0.3,2.3,N,1);
    testCase.TestData.lnas    = unifrnd(-5,5);
    testCase.TestData.logitRs = unifrnd(-5,5);
    testCase.TestData.lnhs    = unifrnd(-3,5);
    testCase.TestData.lnRth   = unifrnd(-14,-7);
    testCase.TestData.sx      = unifrnd(1e-2,1e2);
    testCase.TestData.sy      = unifrnd(1e-2,1e2);
    testCase.TestData.P       = unifrnd(100,1000);
    testCase.TestData.f       = unifrnd(1e-5,1e-1,1,1,Nf);
    testCase.TestData.u       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,1,1,1,1,Nx);
    testCase.TestData.v       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,1,1,1,1,Nx);
    
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_match_legacy_v_auto(~)
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 lnCf lnaf logitRf lnhf ...
         Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 lnCs lnas logitRs lnhs ...
         lnRth sx sy P f u v
    T0hat = T0hat_finite_auto_optimized( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_finite_legacy( ...
         Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,exp(lnCf),exp(lnaf),sigmoid(logitRf),exp(lnhf), ...
         Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,exp(lnCs),exp(lnas),sigmoid(logitRs),exp(lnhs), ...
         exp(lnRth),sx,sy,P,f,u,v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_finite does not agree with T0hat_finite_legacy")
    end
end

function test_match_legacy(~)
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 lnCf lnaf logitRf lnhf ...
         Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 lnCs lnas logitRs lnhs ...
         lnRth sx sy P f u v
    T0hat = T0hat_finite( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_finite_legacy( ...
         Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,exp(lnCf),exp(lnaf),sigmoid(logitRf),exp(lnhf), ...
         Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,exp(lnCs),exp(lnas),sigmoid(logitRs),exp(lnhs), ...
         exp(lnRth),sx,sy,P,f,u,v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_finite does not agree with T0hat_finite_legacy")
    end
end

function test_match_auto_optimized(~)
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 lnCf lnaf logitRf lnhf ...
         Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 lnCs lnas logitRs lnhs ...
         lnRth sx sy P f u v
    T0hat = T0hat_finite( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_finite_auto_optimized( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_finite does not agree with T0hat_finite_auto_optimized")
    end
end

function test_checkGradients_all_design_variables(testCase)
    x0 = [ ...
        testCase.TestData.Kf11(:).', ...
        testCase.TestData.Kf12(:).', ...
        testCase.TestData.Kf13(:).', ...
        testCase.TestData.Kf22(:).', ...
        testCase.TestData.Kf23(:).', ...
        testCase.TestData.Kf33(:).', ...
        testCase.TestData.lnCf(:).', ...
        testCase.TestData.lnaf(:).', ...
        testCase.TestData.logitRf(:).', ...
        testCase.TestData.lnhf(:).', ...
        testCase.TestData.Ks11(:).', ...
        testCase.TestData.Ks12(:).', ...
        testCase.TestData.Ks13(:).', ...
        testCase.TestData.Ks22(:).', ...
        testCase.TestData.Ks23(:).', ...
        testCase.TestData.Ks33(:).', ...
        testCase.TestData.lnCs(:).', ...
        testCase.TestData.lnas(:).', ...
        testCase.TestData.logitRs(:).', ...
        testCase.TestData.lnhs(:).', ...
        testCase.TestData.lnRth(:).', ...
        testCase.TestData.sx(:).', ...
        testCase.TestData.sy(:).', ...
        testCase.TestData.P(:).', ...
        testCase.TestData.f(:).', ...
        testCase.TestData.u(:).', ...
        testCase.TestData.v(:).' ...
    ];
    
    if ~checkGradients(@(x) obj_fun(testCase, x), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function [T0hat, Jac] = obj_fun(testCase, x)
    N = size(testCase.TestData.Kf11,1);
    n = size(testCase.TestData.Kf11,2);
    Nf = size(testCase.TestData.f,3);
    Nx = size(testCase.TestData.u,4);
    Nz = length(x);
    args = cell(1,27);
    idx = 0;
    for i = 1:6
        args{i} = DesignVariable(reshape(x(idx+1:idx+N*n),N,n),reshape(idx+1:idx+N*n,N,n),Nz);
        idx = idx + N*n;
    end
    args{7} = DesignVariable(reshape(x(idx+1:idx+N),N,1),reshape(idx+1:idx+N,N,1),Nz);
    idx = idx + N;
    for i = 8:10
        args{i} = DesignVariable(x(idx),idx,Nz);
        idx = idx + 1;
    end
    for i = 11:16
        args{i} = DesignVariable(reshape(x(idx+1:idx+N*n),N,n),reshape(idx+1:idx+N*n,N,n),Nz);
        idx = idx + N*n;
    end
    args{17} = DesignVariable(reshape(x(idx+1:idx+N),N,1),reshape(idx+1:idx+N,N,1),Nz);
    idx = idx + N;
    for i = 18:24
        args{i} = DesignVariable(x(idx),idx,Nz);
        idx = idx + 1;
    end
    args{25} = DesignVariable(reshape(x(idx+1:idx+Nf),1,1,Nf),reshape(idx+1:idx+Nf,1,1,Nf),Nz);
    idx = idx + Nf;
    for i = 26:27
        args{i} = DesignVariable(reshape(x(idx+1:idx+Nx),1,1,1,Nx),reshape(idx+1:idx+Nx,1,1,1,Nx),Nz);
        idx = idx + Nx;
    end

    if nargout < 2
        T0hat = T0hat_finite(args{:});
    else
        [T0hat, Jac] = T0hat_finite(args{:});
    end
end

function T0_hat = T0hat_finite_legacy(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,sx,sy,P,f0,u,v)
%T0hat_finite
%    T0_hat = T0hat_finite(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,AF,Rf,HF,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,AS,Rs,HS,Rth,SX,SY,P,F0,U,V)

%    This function was generated by the Symbolic Math Toolbox version 25.1.
%    19-Sep-2025 13:31:02

%Created by ForwardModel.solve_system_symbolically()
t2 = Kf33.*af;
t3 = Ks33.*as;
t4 = Kf13.*u;
t5 = Ks13.*u;
t6 = Kf23.*v;
t7 = Ks23.*v;
t8 = af.*hf;
t9 = as.*hs;
t10 = pi.^2;
t13 = sx.^2;
t14 = sy.^2;
t15 = u.^2;
t16 = v.^2;
t17 = 1.0./Kf33;
t18 = 1.0./Ks33;
t19 = Rf-1.0;
t20 = Rs-1.0;
t27 = Cf.*f0.*pi.*2.0i;
t28 = Cs.*f0.*pi.*2.0i;
t47 = Kf12.*u.*v.*7.895683520871486e+1;
t48 = Ks12.*u.*v.*7.895683520871486e+1;
t21 = -t8;
t22 = -t9;
t23 = af.*t2;
t24 = as.*t3;
t31 = t4+t6;
t32 = t5+t7;
t49 = Kf11.*t15.*3.947841760435743e+1;
t50 = Ks11.*t15.*3.947841760435743e+1;
t51 = Kf22.*t16.*3.947841760435743e+1;
t52 = Ks22.*t16.*3.947841760435743e+1;
t53 = t13.*t15.*1.973920880217872e+1;
t54 = t14.*t16.*1.973920880217872e+1;
t25 = exp(t21);
t26 = exp(t22);
t29 = -t23;
t30 = -t24;
t33 = t31.^2;
t34 = t32.^2;
t35 = t31.*pi.*2.0i;
t36 = t32.*pi.*2.0i;
t39 = af.*t31.*pi.*4.0i;
t40 = as.*t32.*pi.*4.0i;
t55 = -t53;
t56 = -t54;
t59 = t27+t47+t49+t51;
t60 = t28+t48+t50+t52;
t37 = -t35;
t38 = -t36;
t41 = t10.*t33.*4.0;
t42 = t10.*t34.*4.0;
t57 = exp(t55);
t58 = exp(t56);
t61 = Kf33.*t59;
t62 = Ks33.*t60;
t69 = t29+t39+t59;
t70 = t30+t40+t60;
t43 = -t41;
t44 = -t42;
t45 = t2+t37;
t46 = t3+t38;
t63 = -t61;
t64 = -t62;
t73 = 1.0./t69;
t74 = 1.0./t70;
t65 = t43+t61;
t66 = t44+t62;
t67 = t41+t63;
t68 = t42+t64;
t71 = sqrt(t65);
t72 = sqrt(t66);
t75 = -t71;
t76 = -t72;
t77 = t35+t71;
t78 = t36+t72;
t93 = (P.*as.*t19.*t20.*t25.*t26.*t46.*t57.*t58.*t71.*t72.*t74)./2.0;
t79 = t35+t75;
t80 = t36+t76;
t81 = hf.*t17.*t77;
t82 = hs.*t18.*t78;
t94 = -t93;
t83 = -t81;
t84 = -t82;
t85 = hf.*t17.*t79;
t86 = hs.*t18.*t80;
t87 = exp(t83);
t88 = exp(t84);
t89 = -t85;
t90 = -t86;
t91 = exp(t89);
t92 = exp(t90);
t95 = Rth.*t67.*t68.*t87.*t88;
t96 = t67.*t72.*t87.*t88;
t97 = t68.*t71.*t87.*t88;
t113 = (P.*af.*t19.*t25.*t57.*t58.*t68.*t71.*t73.*t88)./4.0;
t116 = (P.*as.*t19.*t20.*t25.*t57.*t58.*t68.*t71.*t74.*t88)./4.0;
t120 = (P.*af.*t19.*t25.*t45.*t57.*t58.*t71.*t72.*t73.*t88)./4.0;
t124 = (P.*as.*t19.*t20.*t25.*t46.*t57.*t58.*t71.*t72.*t74.*t88)./4.0;
t98 = Rth.*t67.*t68.*t87.*t92;
t99 = Rth.*t67.*t68.*t88.*t91;
t102 = t67.*t72.*t87.*t92;
t103 = t68.*t71.*t87.*t92;
t105 = t68.*t71.*t88.*t91;
t106 = Rth.*t67.*t68.*t91.*t92;
t107 = t68.*t75.*t87.*t92;
t108 = t67.*t76.*t88.*t91;
t110 = t68.*t71.*t91.*t92;
t111 = t67.*t76.*t91.*t92;
t112 = t68.*t75.*t91.*t92;
t114 = -t113;
t115 = (P.*af.*t19.*t25.*t57.*t58.*t68.*t71.*t73.*t92)./4.0;
t117 = -t116;
t118 = (P.*as.*t19.*t20.*t25.*t57.*t58.*t68.*t71.*t74.*t92)./4.0;
t119 = Rth.*t45.*t113;
t122 = P.*Rth.*af.*t19.*t25.*t45.*t57.*t58.*t68.*t71.*t73.*t92.*(-1.0./4.0);
t123 = (P.*af.*t19.*t25.*t45.*t57.*t58.*t71.*t72.*t73.*t92)./4.0;
t125 = (P.*as.*t19.*t20.*t25.*t46.*t57.*t58.*t71.*t72.*t74.*t92)./4.0;
t100 = -t98;
t101 = -t99;
t126 = t95+t96+t97+t100+t101+t102+t105+t106+t107+t108+t111+t112;
t127 = 1.0./t126;
et1 = -t127.*(t94+t114+t115+t117+t118+t119+t120+t122+t123+t124+t125-(P.*Rth.*af.*t19.*t45.*t57.*t58.*t73.*t97)./4.0+(P.*Rth.*af.*t19.*t45.*t57.*t58.*t73.*t103)./4.0+(P.*af.*t19.*t45.*t57.*t58.*t68.*t73.*t87.*t88)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t68.*t73.*t87.*t92)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t71.*t72.*t73.*t87.*t88)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t71.*t72.*t73.*t87.*t92)./4.0);
et2 = -t127.*(t94+t114+t115+t117+t118+t119+t120+t122+t123+t124+t125-(P.*Rth.*af.*t19.*t45.*t57.*t58.*t73.*t105)./4.0+(P.*Rth.*af.*t19.*t45.*t57.*t58.*t73.*t110)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t68.*t73.*t88.*t91)./4.0+(P.*af.*t19.*t45.*t57.*t58.*t68.*t73.*t91.*t92)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t71.*t72.*t73.*t88.*t91)./4.0-(P.*af.*t19.*t45.*t57.*t58.*t71.*t72.*t73.*t91.*t92)./4.0)-(P.*af.*t19.*t57.*t58.*t73)./4.0;
T0_hat = et1+et2;
end
