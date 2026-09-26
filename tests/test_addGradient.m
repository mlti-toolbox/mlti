function tests = test_addGradient()
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_scalar_val(testCase)
    Jac = [];
    x = DesignVariable(2, 15, 20);
    grad = rand(2,3,4,5);
    expected = sparse(1:numel(grad), 15*ones(1,numel(grad)), grad(:), numel(grad), 20);

    testCase.verifyEqual(addGradient(Jac, x, @() grad), expected);
end

% Does not currently support the following functionality
% function test_reduced_dim_grad(testCase)
%     Jac = [];
%     x = DesignVariable(rand, 5, 11);
%     grad = rand(2,3,4); % full dim would be [2,3,4,5]
%     grade = repmat(grad, 1, 1, 1, 5);
%     expected = sparse(1:numel(grade), 5*ones(1,numel(grade)), grade(:), numel(grade), 11);
%     testCase.verifyEqual(addGradient(Jac, x, @() grad), expected);
% end