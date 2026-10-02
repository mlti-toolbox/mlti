function tests = test_hyper_sphere()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    d = randi([3,4]);
    n = randi([30,90]);

    % Uniform HyperSphere Sampling
    testCase.TestData.O = randn(n,d);
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function out = obj_fun(x,n,d)
    x = reshape(x,n,d);
    xc = cell(1,d);
    for i = 1:d
        xc{i} = x((sub2ind(size(x), 1, i):sub2ind(size(x), n, i))');
    end
    out = hyper_sphere(xc{:});
end

function test_checkGradients_all_design_variables(testCase)
    [n,d] = size(testCase.TestData.O);
    x0 = testCase.TestData.O(:);
    if ~checkGradients(@(x) format4optim(@(xi) obj_fun(xi, n, d), x), ...
            x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_output_is_0(testCase)
    O = testCase.TestData.O ./ vecnorm(testCase.TestData.O, 2, 2);
    [n,d] = size(O);
    assert(max(abs(format4optim(@(xi) obj_fun(xi, n, d), O(:))))<1e-12)
end