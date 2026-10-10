function tests = test_nll_log_amp()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([1,5]); n = randi([1,5]); Nf = randi([1,5]); Nprobe = randi([1,5]);
    testCase.TestData.lnA_pred = unifrnd(-2,2,N,n,Nf,Nprobe);
    testCase.TestData.lnA_obs = unifrnd(-2,2,N,n,Nf,Nprobe);
    testCase.TestData.sigmaT = unifrnd(1,2,1,1);
    testCase.TestData.sigmaD = unifrnd(1,2,N,n,Nf,Nprobe);
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_checkGradients_all_design_variables(testCase)
    [N,n,Nf,Nprobe] = size(testCase.TestData.lnA_pred);
    x0 = [testCase.TestData.lnA_pred(:).', testCase.TestData.lnA_obs(:).', testCase.TestData.sigmaT(:).', testCase.TestData.sigmaD(:).'];
    if ~checkGradients(@(x) format4optim(@(xi) nll_log_amp( ...
            xi(1:N*n*Nf*Nprobe), ...
            xi(N*n*Nf*Nprobe+1:2*N*n*Nf*Nprobe), ...
            xi(2*N*n*Nf*Nprobe+1), ...
            xi(2*N*n*Nf*Nprobe+2:3*N*n*Nf*Nprobe+1) ...
        ), x), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_no_design_variables(testCase)
    x0 = [];
    if ~checkGradients(@(x) format4optim(@(xi) nll_log_amp( ...
            testCase.TestData.lnA_pred, ...
            testCase.TestData.lnA_obs, ...
            testCase.TestData.sigmaT, ...
            testCase.TestData.sigmaD ...
        ), x), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_every_other_design_variables(testCase)
    [N,n,Nf,Nprobe] = size(testCase.TestData.lnA_pred);
    x0 = [testCase.TestData.lnA_pred(:).', testCase.TestData.sigmaT(:).'];
    if ~checkGradients(@(x) format4optim(@(xi) nll_log_amp( ...
            reshape(xi(1:N*n*Nf*Nprobe), [N,n,Nf,Nprobe]), ...
            testCase.TestData.lnA_obs, ...
            xi(N*n*Nf*Nprobe+1), ...
            testCase.TestData.sigmaD ...
        ), x), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end