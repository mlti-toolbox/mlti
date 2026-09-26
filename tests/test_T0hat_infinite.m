function tests = test_T0hat_infinite()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([4,7]);
    n = randi([5,8]);
    Nf = randi([6,10]);
    Nx = randi([20,30]);

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
    testCase.TestData.u       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,10,1,1,1,Nx);
    testCase.TestData.v       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,10,1,1,1,Nx);
    
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
    T0hat = T0hat_infinite_auto_optimized( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_infinite_legacy( ...
         Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,exp(lnCf),exp(lnaf),sigmoid(logitRf),exp(lnhf), ...
         Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,exp(lnCs),exp(lnas),sigmoid(logitRs),exp(lnhs), ...
         exp(lnRth),sx,sy,P,f,u,v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_infinite does not agree with T0hat_infinite_legacy")
    end
end

function test_match_legacy(~)
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 lnCf lnaf logitRf lnhf ...
         Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 lnCs lnas logitRs lnhs ...
         lnRth sx sy P f u v
    T0hat = T0hat_infinite( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_infinite_legacy( ...
         Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,exp(lnCf),exp(lnaf),sigmoid(logitRf),exp(lnhf), ...
         Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,exp(lnCs),exp(lnas),sigmoid(logitRs),exp(lnhs), ...
         exp(lnRth),sx,sy,P,f,u,v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_infinite does not agree with T0hat_infinite_legacy")
    end
end

function test_match_auto_optimized(~)
    syms Kf11 Kf12 Kf13 Kf22 Kf23 Kf33 lnCf lnaf logitRf lnhf ...
         Ks11 Ks12 Ks13 Ks22 Ks23 Ks33 lnCs lnas logitRs lnhs ...
         lnRth sx sy P f u v
    T0hat = T0hat_infinite( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    T0hat_auto = T0hat_infinite_auto_optimized( ...
         Kf11, Kf12, Kf13, Kf22, Kf23, Kf33, lnCf, lnaf, logitRf, lnhf, ...
         Ks11, Ks12, Ks13, Ks22, Ks23, Ks33, lnCs, lnas, logitRs, lnhs, ...
         lnRth, sx, sy, P, f, u, v ...
    );
    
    if ~all(isequal(T0hat,T0hat_auto))
        error("T0hat_infinite does not agree with T0hat_infinite_auto_optimized")
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
        T0hat = T0hat_infinite(args{:});
    else
        [T0hat, Jac] = T0hat_infinite(args{:});
    end
end

function T0_hat = T0hat_infinite_legacy(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,sx,sy,P,f0,u,v)
%T0hat_infinite
%    T0_hat = T0hat_infinite(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,AF,Rf,HF,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,AS,Rs,HS,Rth,SX,SY,P,F0,U,V)

%    This function was generated by the Symbolic Math Toolbox version 25.1.
%    19-Sep-2025 13:31:03

%Created by ForwardModel.solve_system_symbolically()
t2 = Kf33.*af;
t3 = Ks33.*as;
t4 = Kf13.*u;
t5 = Ks13.*u;
t6 = Kf23.*v;
t7 = Ks23.*v;
t8 = af.*hf;
t9 = pi.^2;
t12 = sx.^2;
t13 = sy.^2;
t14 = u.^2;
t15 = v.^2;
t16 = 1.0./Kf33;
t17 = Rf-1.0;
t18 = Rs-1.0;
t23 = Cf.*f0.*pi.*2.0i;
t24 = Cs.*f0.*pi.*2.0i;
t43 = Kf12.*u.*v.*7.895683520871486e+1;
t44 = Ks12.*u.*v.*7.895683520871486e+1;
t19 = -t8;
t20 = af.*t2;
t21 = as.*t3;
t27 = t4+t6;
t28 = t5+t7;
t45 = Kf11.*t14.*3.947841760435743e+1;
t46 = Ks11.*t14.*3.947841760435743e+1;
t47 = Kf22.*t15.*3.947841760435743e+1;
t48 = Ks22.*t15.*3.947841760435743e+1;
t49 = t12.*t14.*1.973920880217872e+1;
t50 = t13.*t15.*1.973920880217872e+1;
t22 = exp(t19);
t25 = -t20;
t26 = -t21;
t29 = t27.^2;
t30 = t28.^2;
t31 = t27.*pi.*2.0i;
t32 = t28.*pi.*2.0i;
t35 = af.*t27.*pi.*4.0i;
t36 = as.*t28.*pi.*4.0i;
t51 = -t49;
t52 = -t50;
t55 = t23+t43+t45+t47;
t56 = t24+t44+t46+t48;
t33 = -t31;
t34 = -t32;
t37 = t9.*t29.*4.0;
t38 = t9.*t30.*4.0;
t53 = exp(t51);
t54 = exp(t52);
t57 = Kf33.*t55;
t58 = Ks33.*t56;
t63 = t25+t35+t55;
t64 = t26+t36+t56;
t39 = -t37;
t40 = -t38;
t41 = t2+t33;
t42 = t3+t34;
t59 = -t57;
t67 = 1.0./t63;
t68 = 1.0./t64;
t60 = t39+t57;
t61 = t40+t58;
t62 = t37+t59;
t65 = sqrt(t60);
t66 = sqrt(t61);
t69 = -t65;
t70 = t31+t65;
t81 = (P.*af.*t17.*t22.*t41.*t53.*t54.*t65.*t67)./4.0;
t83 = (P.*as.*t17.*t18.*t22.*t42.*t53.*t54.*t65.*t68)./4.0;
t90 = (P.*af.*t17.*t22.*t53.*t54.*t65.*t66.*t67)./4.0;
t91 = (P.*as.*t17.*t18.*t22.*t53.*t54.*t65.*t66.*t68)./4.0;
t93 = P.*Rth.*af.*t17.*t22.*t41.*t53.*t54.*t65.*t66.*t67.*(-1.0./4.0);
t71 = t31+t69;
t72 = hf.*t16.*t70;
t82 = -t81;
t84 = -t83;
t92 = Rth.*t66.*t81;
t73 = -t72;
t74 = hf.*t16.*t71;
t75 = exp(t73);
t76 = -t74;
t77 = exp(t76);
t78 = t62.*t75;
t86 = t65.*t66.*t75;
t79 = t62.*t77;
t85 = Rth.*t66.*t78;
t89 = t65.*t66.*t77;
t80 = -t79;
t88 = Rth.*t66.*t80;
t94 = t78+t80+t85+t86+t88+t89;
t95 = 1.0./t94;
T0_hat = t95.*(t82+t84+t90+t91+t93+(P.*Rth.*af.*t17.*t41.*t53.*t54.*t67.*t89)./4.0+(P.*af.*t17.*t41.*t53.*t54.*t65.*t67.*t77)./4.0+(P.*af.*t17.*t41.*t53.*t54.*t66.*t67.*t77)./4.0)-t95.*(t81+t83-t90-t91+t92-(P.*Rth.*af.*t17.*t41.*t53.*t54.*t67.*t86)./4.0-(P.*af.*t17.*t41.*t53.*t54.*t65.*t67.*t75)./4.0+(P.*af.*t17.*t41.*t53.*t54.*t66.*t67.*t75)./4.0)-(P.*af.*t17.*t53.*t54.*t67)./4.0;
end
