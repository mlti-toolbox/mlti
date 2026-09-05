function tests = test_iso2tensor()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    N = randi([4,7]);
    testCase.TestData.lnk = unifrnd(-5,5,N,1);
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");
end

function teardownOnce(~)
end

function test_checkGradients_all_design_variables(testCase)
    x0 = testCase.TestData.lnk(:);
    if ~checkGradients(@(x) obj_fun( ...
            DesignVariable(x)...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_no_design_variables(testCase)
    x0 = [];
    if ~checkGradients(@(x) obj_fun( ...
            testCase.TestData.lnk ...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function [out, Jac] = obj_fun(lnk)
    if nargout < 2
        tensor = iso2tensor(lnk);
    else
        [tensor, Jac] = iso2tensor(lnk);
    end
    out = horzcat(tensor{:});
    out = out(:);
end