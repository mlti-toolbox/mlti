function tests = test_nl_GP_prior()
    tests = functiontests(localfunctions);
end

function [fx, jac_f_x] = F(xi,ai)
    x = get_val(xi);
    a = get_val(ai);

    fx = sin(a.*x) - a.^3.*x + x.^2./a;
    if nargout > 1
        jac_f_x = zeros(numel(fx), 0);
        jac_f_x = addGradient(jac_f_x, xi, @() a.*cos(a.*x) + (2.*x)./a - a.^3);
        jac_f_x = addGradient(jac_f_x, ai, @() x.*cos(a.*x) - 3.*a.^2.*x - x.^2./a.^2);
    end
end

function [mu, jac_mu_x] = MU(xi, ai, bi)
    x = get_val(xi);
    a = get_val(ai);
    b = get_val(bi);
    mu = (a + b)*ones(size(x));
    if nargout > 1
        jac_mu_x = zeros(numel(mu),0);
        jac_mu_x = addGradient(jac_mu_x, xi, @() zeros(numel(mu), 1));
        jac_mu_x = addGradient(jac_mu_x, ai, @() ones(numel(mu), 1));
        jac_mu_x = addGradient(jac_mu_x, bi, @() ones(numel(mu), 1));
    end
end

function setupOnce(testCase)
    N = 5;
    testCase.TestData.x = (1:N).';
    testCase.TestData.lnsigma = log(unifrnd(0.5,2,N,1));
    testCase.TestData.lnell = log(2);
    testCase.TestData.a = rand;
    testCase.TestData.b = rand + 3;
    testCase.TestData.options = optimoptions("fminunc", FiniteDifferenceType="central");

    timestamp = string(datetime("now", Format="uuuu-MM-dd_HH-mm-ss.SSS"));
    testCase.onFailure(@() logFailure(testCase, timestamp));
end

function teardownOnce(~)
end

function test_checkGradients_all_design_variables(testCase)
    Ns = [  numel(testCase.TestData.lnsigma)
            numel(testCase.TestData.lnell(:));
            numel(testCase.TestData.a(:));
            numel(testCase.TestData.b(:)) ];
    x0 = [  testCase.TestData.lnsigma(:);
            testCase.TestData.lnell(:);
            testCase.TestData.a(:);
            testCase.TestData.b(:) ];
    lnsigma = @(x) DesignVariable(x(1:Ns(1)),(1:Ns(1))',sum(Ns));
    lnell = @(x) DesignVariable(x(Ns(1)+1:sum(Ns(1:2))),(Ns(1)+1:sum(Ns(1:2)))',sum(Ns));
    a = @(x) DesignVariable(x(sum(Ns(1:2))+1:sum(Ns(1:3))),(sum(Ns(1:2))+1:sum(Ns(1:3)))',sum(Ns));
    b = @(x) DesignVariable(x(sum(Ns(1:3))+1:sum(Ns)),(sum(Ns(1:3))+1:sum(Ns))',sum(Ns));
    if ~checkGradients(@(x) nl_GP_prior( ...
            testCase.TestData.x, ...
            @(y) F(y, a(x)), ...
            @(y) MU(y, a(x), b(x)), ...
            @(y, yp) RBFKernel(y, yp, lnsigma(x), lnsigma(x), lnell(x)) ...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end
function test_checkGradients_no_design_variables(testCase)
    if ~checkGradients(@(x) nl_GP_prior( ...
            testCase.TestData.x, ...
            @(y) F(y, testCase.TestData.a), ...
            @(y) MU(y, testCase.TestData.a, testCase.TestData.b), ...
            @(y, yp) RBFKernel(y, yp, testCase.TestData.lnsigma, testCase.TestData.lnsigma, testCase.TestData.lnell) ...
        ), [], testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end

function test_checkGradients_every_other_design_variables(testCase)
    Ns = [  numel(testCase.TestData.lnsigma)
            numel(testCase.TestData.a(:))];
    x0 = [  testCase.TestData.lnsigma(:);
            testCase.TestData.a(:)];
    lnsigma = @(x) DesignVariable(x(1:Ns(1)),(1:Ns(1))',sum(Ns));
    a = @(x) DesignVariable(x(Ns(1)+1:sum(Ns(1:2))),(Ns(1)+1:sum(Ns(1:2)))',sum(Ns));
    if ~checkGradients(@(x) nl_GP_prior( ...
            testCase.TestData.x, ...
            @(y) F(y, a(x)), ...
            @(y) MU(y, a(x), testCase.TestData.b), ...
            @(y, yp) RBFKernel(y, yp, lnsigma(x), lnsigma(x), testCase.TestData.lnell) ...
        ), x0, testCase.TestData.options, Display="on")
        error("checkGradients Failed!")
    end
end