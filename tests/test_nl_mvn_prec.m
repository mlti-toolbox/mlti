function tests = test_nl_mvn_prec()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([2,10]);
    testCase.TestData.x = unifrnd(-1,1, N, 1);
    testCase.TestData.mu = unifrnd(-1,1, N, 1);
    A = randn(N);
    P = inv(A*A.' + 0.1*eye(N));
    testCase.TestData.P = 0.5*(P+P.');
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_checkGradients_all_design_variables(testCase)
    N = numel(testCase.TestData.x);
    x0 = [testCase.TestData.x(:).', testCase.TestData.mu(:).', testCase.TestData.P(:).'];
    if ~checkGradients(@(y) format4optim(@(x) nl_mvn_prec( ...
            x(1:N).', ...
            x(N+1:2*N).', ...
            reshape(x(2*N+1:2*N+N*N), [N,N]) ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_no_design_variables(testCase)
    x0 = [];
    if ~checkGradients(@(y) format4optim(@(x) nl_mvn_prec( ...
            testCase.TestData.x, ...
            testCase.TestData.mu, ...
            testCase.TestData.P ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_every_other_design_variables(testCase)
    N = numel(testCase.TestData.x);
    x0 = [testCase.TestData.x(:).', testCase.TestData.P(:).'];
    if ~checkGradients(@(y) format4optim(@(x) nl_mvn_prec( ...
            x(1:N).', ...
            testCase.TestData.mu, ...
            reshape(x(N+1:N+N*N), [N,N]) ...
        ), y), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_mvn_correctness(testCase)
    N = numel(testCase.TestData.x);
    diff = testCase.TestData.x(:)-testCase.TestData.mu(:);
    p = (2*pi)^(-N/2) * sqrt(det(testCase.TestData.P)) * exp(-1/2*diff.'*testCase.TestData.P*diff);
    psi = nl_mvn_prec(testCase.TestData.x, testCase.TestData.mu, testCase.TestData.P);
    testCase.verifyEqual(psi,-log(p), ...
    'AbsTol',1e-12, ...
    'RelTol',1e-12);
    p = mvnpdf(testCase.TestData.x, testCase.TestData.mu, inv(testCase.TestData.P));
    testCase.verifyEqual(psi,-log(p), ...
    'AbsTol',1e-12, ...
    'RelTol',1e-12);
end