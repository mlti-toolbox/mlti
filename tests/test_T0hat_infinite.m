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
    testCase.TestData.u       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,1,1,1,1,Nx);
    testCase.TestData.v       = (randi([0 1],1,1,1,Nx)*2 - 1) .* unifrnd(0.01,1,1,1,1,Nx);
    
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
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