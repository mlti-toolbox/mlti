function tests = test_nl_vM()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([1,5]); n = randi([1,5]); Nf = randi([1,5]); Nprobe = randi([1,5]);
    testCase.TestData.x = unifrnd(-pi,pi);
    testCase.TestData.mu = unifrnd(-pi,pi,N,n,Nf,Nprobe);
    testCase.TestData.kappa = unifrnd(0,500,N,n,Nf,Nprobe);
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_checkGradients_all_design_variables(testCase)
    [N,n,Nf,Nprobe] = size(testCase.TestData.mu);
    x0 = [testCase.TestData.x(:).', testCase.TestData.mu(:).', testCase.TestData.kappa(:).'];
    if ~checkGradients(@(y) format4optim(@(x) nl_vM( ...
            x(1), ...
            reshape(x(2:N*n*Nf*Nprobe+1), [N,n,Nf,Nprobe]), ...
            reshape(x(N*n*Nf*Nprobe+2:2*N*n*Nf*Nprobe+1), [N,n,Nf,Nprobe]) ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_no_design_variables(testCase)
    x0 = [];
    if ~checkGradients(@(y) format4optim(@(x) nl_vM( ...
            testCase.TestData.x, ...
            testCase.TestData.mu, ...
            testCase.TestData.kappa ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_every_other_design_variables(testCase)
    [N,n,Nf,Nprobe] = size(testCase.TestData.mu);
    x0 = [testCase.TestData.x(:).', testCase.TestData.kappa(:).'];
    if ~checkGradients(@(y) format4optim(@(x) nl_vM( ...
            x(1), ...
            testCase.TestData.mu, ...
            reshape(x(2:N*n*Nf*Nprobe+1), [N,n,Nf,Nprobe]) ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end