function tests = test_ForwardModel()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = 2;
    n = 3;
    Nf = 4;
    Nprobe = 5;

    % Isotropic
    testCase.TestData.lnkf      = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnks      = unifrnd(-2,5,1,1,N,1);

    % Uniaxially Anisotropic
    testCase.TestData.lnkf_perp = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnkf_par  = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.vf1     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.vf2     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.vf3     = unifrnd(-1,-1,1,1,1,n);

    testCase.TestData.lnks_perp = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnks_par  = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.vs1     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.vs2     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.vs3     = unifrnd(-1,-1,1,1,1,n);

    % Fully Anisotropic (Principal)
    testCase.TestData.lnkfp1    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnkfp2    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnkfp3    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.qf1     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qf2     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qf3     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qf4     = unifrnd(-1,-1,1,1,1,n);

    testCase.TestData.lnksp1    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnksp2    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.lnksp3    = unifrnd(-2,5,1,1,N,1);
    testCase.TestData.qs1     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qs2     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qs3     = unifrnd(-1,-1,1,1,1,n);
    testCase.TestData.qs4     = unifrnd(-1,-1,1,1,1,n);

    % Fully Anisotropic (Tensor)
    testCase.TestData.Kf11    = unifrnd(0.1,500,1,1,N,n);
    testCase.TestData.Kf22    = unifrnd(0.1,500,1,1,N,n);
    testCase.TestData.Kf33    = unifrnd(0.1,500,1,1,N,n);
    Kf11Kf22 = testCase.TestData.Kf11.*testCase.TestData.Kf22;
    Kf11Kf33 = testCase.TestData.Kf11.*testCase.TestData.Kf33;
    Kf22Kf33 = testCase.TestData.Kf22.*testCase.TestData.Kf33;
    testCase.TestData.Kf12    = unifrnd(-sqrt(Kf11Kf22),sqrt(Kf11Kf22));
    testCase.TestData.Kf13    = unifrnd(-sqrt(Kf11Kf33),sqrt(Kf11Kf33));
    testCase.TestData.Kf23    = unifrnd(-sqrt(Kf22Kf33),sqrt(Kf22Kf33));

    testCase.TestData.Ks11    = unifrnd(0.1,500,1,1,N,n);
    testCase.TestData.Ks22    = unifrnd(0.1,500,1,1,N,n);
    testCase.TestData.Ks33    = unifrnd(0.1,500,1,1,N,n);
    Ks11Ks22 = testCase.TestData.Ks11.*testCase.TestData.Ks22;
    Ks11Ks33 = testCase.TestData.Ks11.*testCase.TestData.Ks33;
    Ks22Ks33 = testCase.TestData.Ks22.*testCase.TestData.Ks33;
    testCase.TestData.Ks12    = unifrnd(-sqrt(Ks11Ks22),sqrt(Ks11Ks22));
    testCase.TestData.Ks13    = unifrnd(-sqrt(Ks11Ks33),sqrt(Ks11Ks33));
    testCase.TestData.Ks23    = unifrnd(-sqrt(Ks22Ks33),sqrt(Ks22Ks33));

    % Other Variables
    testCase.TestData.lnCf    = unifrnd(-0.3,2.3,1,1,N,1);
    testCase.TestData.lnaf    = unifrnd(-5,5);
    testCase.TestData.logitRf = unifrnd(-5,5);
    testCase.TestData.lnhf    = unifrnd(-3,5);

    testCase.TestData.lnCs    = unifrnd(-0.3,2.3,1,1,N,1);
    testCase.TestData.lnas    = unifrnd(-5,5);
    testCase.TestData.logitRs = unifrnd(-5,5);
    testCase.TestData.lnhs    = unifrnd(-3,5);

    testCase.TestData.lnRth   = unifrnd(-14,-7);
    testCase.TestData.sx      = unifrnd(1e-2,1e2);
    testCase.TestData.sy      = unifrnd(1e-2,1e2);
    testCase.TestData.P       = unifrnd(100,1000);
    testCase.TestData.f       = unifrnd(1e-5,1e-1,1,1,1,1,Nf);

    testCase.TestData.ifft_x_max = 250;
    testCase.TestData.ifft_Nx = 32;
    testCase.TestData.Xprobe = unifrnd(0,20,Nprobe,2);
    
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");
end

function teardownOnce(~)
end

function test_checkGradients_random_design_variables(testCase)
    IsotropyTypes = [ ...
        IsotropyEnum.isotropic, ...
        IsotropyEnum.uniaxial, ...
        IsotropyEnum.principal, ...
        IsotropyEnum.tensor ...
    ];
    for filmIsotropy = IsotropyTypes
        for subIsotropy = IsotropyTypes
            for inf_sub_thick = [true, false]
                disp("in:" + string(filmIsotropy) + ", " + string(subIsotropy) + ", " + string(inf_sub_thick))
                args = populate_args(testCase, filmIsotropy, subIsotropy);
                isDesignVariable = logical(randi([0,1],1,length(args)-3));
                x0 = x0_assignment(args, isDesignVariable);
                if ~checkGradients(@(x) obj_fun(args, filmIsotropy, subIsotropy, inf_sub_thick, isDesignVariable, x), x0, testCase.TestData.options, Display="on")
                    testCase.TestData.filmIsotropy = filmIsotropy;
                    testCase.TestData.subIsotropy = subIsotropy;
                    testCase.TestData.inf_sub_thick = inf_sub_thick;
                    testCase.TestData.isDesignVariable = isDesignVariable;
                    logFailure(testCase, string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS")))
                    error("checkGradients Failed!")
                end
            end
        end
    end
end

function args = populate_args(testCase, filmIsotropy, subIsotropy)
arguments
    testCase 
    filmIsotropy (1,1) IsotropyEnum 
    subIsotropy  (1,1) IsotropyEnum 
end
    switch filmIsotropy
    case IsotropyEnum.isotropic
        film_cond = {testCase.TestData.lnkf};
        film_orient = {};
    case IsotropyEnum.uniaxial
        film_cond = { ...
            testCase.TestData.lnkf_perp, ...
            testCase.TestData.lnkf_par ...
        };
        film_orient = { ...
            testCase.TestData.vf1, ...
            testCase.TestData.vf2, ...
            testCase.TestData.vf3 ...
        };
    case IsotropyEnum.principal
        film_cond = { ...
            testCase.TestData.lnkfp1, ...
            testCase.TestData.lnkfp2, ...
            testCase.TestData.lnkfp3, ...
        };
        film_orient = { ...
            testCase.TestData.qf1, ...
            testCase.TestData.qf2, ...
            testCase.TestData.qf3, ...
            testCase.TestData.qf4 ...
        };
    case IsotropyEnum.tensor
        film_cond = { ...
            testCase.TestData.Kf11, ...
            testCase.TestData.Kf12, ...
            testCase.TestData.Kf13, ...
            testCase.TestData.Kf22, ...
            testCase.TestData.Kf23, ...
            testCase.TestData.Kf33 ...
        };
        film_orient = {};
    end

    switch subIsotropy
    case IsotropyEnum.isotropic
        sub_cond = {testCase.TestData.lnks};
        sub_orient = {};
    case IsotropyEnum.uniaxial
        sub_cond = { ...
            testCase.TestData.lnks_perp, ...
            testCase.TestData.lnks_par ...
        };
        sub_orient = { ...
            testCase.TestData.vs1, ...
            testCase.TestData.vs2, ...
            testCase.TestData.vs3 ...
        };
    case IsotropyEnum.principal
        sub_cond = { ...
            testCase.TestData.lnksp1, ...
            testCase.TestData.lnksp2, ...
            testCase.TestData.lnksp3, ...
        };
        sub_orient = { ...
            testCase.TestData.qs1, ...
            testCase.TestData.qs2, ...
            testCase.TestData.qs3, ...
            testCase.TestData.qs4 ...
        };
    case IsotropyEnum.tensor
        sub_cond = { ...
            testCase.TestData.Ks11, ...
            testCase.TestData.Ks12, ...
            testCase.TestData.Ks13, ...
            testCase.TestData.Ks22, ...
            testCase.TestData.Ks23, ...
            testCase.TestData.Ks33 ...
        };
        sub_orient = {};
    end
    args = [ ...
        film_cond(:)', ...
        film_orient(:)', ...
        {testCase.TestData.lnCf}, ...
        {testCase.TestData.lnaf}, ...
        {testCase.TestData.logitRf}, ...
        {testCase.TestData.lnhf}, ...
        sub_cond(:)', ...
        sub_orient(:)', ...
        {testCase.TestData.lnCs}, ...
        {testCase.TestData.lnas}, ...
        {testCase.TestData.logitRs}, ...
        {testCase.TestData.lnhs}, ...
        {testCase.TestData.lnRth}, ...
        {testCase.TestData.sx}, ...
        {testCase.TestData.sy}, ...
        {testCase.TestData.P}, ...
        {testCase.TestData.f}, ...
        {testCase.TestData.ifft_x_max}, ...
        {testCase.TestData.ifft_Nx}, ...
        {testCase.TestData.Xprobe} ...
    ];
end

function NumDesignVariables = countDesignVariables(args, isDesignVariable)
    NumDesignVariables = 0;
    for i = 1:min(length(isDesignVariable), length(args)-3)
        if isDesignVariable(i)
            NumDesignVariables = NumDesignVariables + numel(args{i});
        end
    end
end

function x0 = x0_assignment(args, isDesignVariable)
arguments
    args
    isDesignVariable (1,:) logical
end
    NumDesignVariables = countDesignVariables(args, isDesignVariable);
    x0 = zeros(1,NumDesignVariables);

    indx = 0;
    for i = 1:length(args)
        if i <= length(isDesignVariable) && isDesignVariable(i)
            next = indx + numel(args{i});
            x0(indx+1:next) = args{i}(:).';
            indx = next;
        end
    end
end

function args = design_variable_assignment(args, isDesignVariable, x)
arguments
    args
    isDesignVariable (1,:) logical
    x
end
    NumDesignVariables = 0;
    for i = 1:min(length(isDesignVariable), length(args)-3)
        if isDesignVariable(i)
            NumDesignVariables = NumDesignVariables + numel(args{i});
        end
    end

    indx = 0;
    for i = 1:min(length(isDesignVariable), length(args)-3)
        if isDesignVariable(i)
            next = indx + numel(args{i});
            args{i} = DesignVariable( ...
                reshape(x(indx+1:next), size(args{i})), ...
                reshape(indx+1:next, size(args{i})), ...
                NumDesignVariables);
            indx = next;
        end
    end
end

function args = format_args(args, filmIsotropy, subIsotropy)
    switch filmIsotropy
    case IsotropyEnum.isotropic
        args = {args(1), {}, args{2:end}};
    case IsotropyEnum.uniaxial
        args = {args(1:2), args(3:5), args{6:end}};
    case IsotropyEnum.principal
        args = {args(1:3), args(4:7), args{8:end}};
    case IsotropyEnum.tensor
        args = {args(1:6), {}, args{7:end}};
    end

    switch subIsotropy
    case IsotropyEnum.isotropic
        args = {args{1:6}, args(7), {}, args{8:end}};
    case IsotropyEnum.uniaxial
        args = {args{1:6}, args(7:8), args(9:11), args{12:end}};
    case IsotropyEnum.principal
        args = {args{1:6}, args(7:9), args(10:13), args{14:end}};
    case IsotropyEnum.tensor
        args = {args{1:6}, args(7:12), {}, args{13:end}};
    end
end

function [T0tilde, Jac] = obj_fun(args, filmIsotropy, subIsotropy, inf_sub_thick, isDesignVariable, x)
    fm = ForwardModel(filmIsotropy, subIsotropy, inf_sub_thick);
    args = design_variable_assignment(args, isDesignVariable, x);
    args = format_args(args, filmIsotropy, subIsotropy);
    if nargout < 2
        T0tilde = fm.solve(args{:});
    else
        [T0tilde, Jac] = fm.solve(args{:});
    end
end