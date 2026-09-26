function tests = test_nl_Bingham_unnormalized()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([2,10]);
    testCase.TestData.x = unifrnd(-1,1, N, 1);
    mu = unifrnd(-1,1, N, 1);
    mu = mu / norm(mu);
    testCase.TestData.Q = [mu, null(mu.')];
    testCase.TestData.k = unifrnd(0,500, N-1, 1);
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_checkGradients_no_design_variables(testCase)
    x0 = [];
    if ~checkGradients(@(x) nl_Bingham_unnormalized( ...
            testCase.TestData.x, ...
            testCase.TestData.Q, ...
            testCase.TestData.k ...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_x_design_variable(testCase)
    x0 = testCase.TestData.x;
    if ~checkGradients(@(x) nl_Bingham_unnormalized( ...
            DesignVariable(x), ...
            testCase.TestData.Q, ...
            testCase.TestData.k ...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end