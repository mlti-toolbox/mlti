clear; clc;

disp("Test Case 1")
for i = 1:10
    x0 = rand(1,28);
    x0(1:10) = x0(1:10) * 10 - 5;
    x0(11:end) = x0(11:end) * 2 - 1;
    
    options = optimoptions("fminunc", FiniteDifferenceType="central");
    if ~checkGradients(@obj_fun, x0, options, Display="on")
        error("checkGradients Failed!")
    end
end

disp("Test Case 2")
for i = 1:10
    x0 = rand(1,10) * 10 - 5;
    v1 = rand(1,6) * 2 - 1;
    v2 = rand(1,6) * 2 - 1;
    v3 = rand(1,6) * 2 - 1;
    
    options = optimoptions("fminunc", FiniteDifferenceType="central");
    if ~checkGradients(@(z) obj_fun2(z,v1,v2,v3), x0, options, Display="on")
        error("checkGradients Failed!")
    end
end

disp("Test Case 3")
for i = 1:10
    x0 = rand(1,18) * 2 - 1;
    k1 = rand(5,1) * 10 - 5;
    k2 = rand(5,1) * 10 - 5;
    
    options = optimoptions("fminunc", FiniteDifferenceType="central");
    if ~checkGradients(@(x) obj_fun3(x,k1,k2), x0, options, Display="on")
        error("checkGradients Failed!")
    end
end

disp("Test Case 4")
for i = 1:10
    x0 = rand(1,17);
    x0(1:5) = x0(1:5) * 10 - 5;
    x0(6:end) = x0(6:end) * 2 - 1;
    k2 = rand(5,1) * 10 - 5;
    v2 = rand(1,6) * 2 - 1;
    
    options = optimoptions("fminunc", FiniteDifferenceType="central");
    if ~checkGradients(@(x) obj_fun4(x,k2,v2), x0, options, Display="on")
        error("checkGradients Failed!")
    end
end

function [out, Jac] = obj_fun(x)
    [tensor, Jac] = uniax2tensor( ...
        DesignVariable(x(1:5)', (1:5)', 28), ...
        DesignVariable(x(6:10)', (6:10)', 28), ...
        DesignVariable(x(11:16), 11:16, 28), ...
        DesignVariable(x(17:22), 17:22, 28), ...
        DesignVariable(x(23:28), 23:28, 28) ...
    );
    out = horzcat(tensor{:});
    out = out(:);
end

function [out, Jac] = obj_fun2(x,v1,v2,v3)
    [tensor, Jac] = uniax2tensor( ...
        DesignVariable(x(1:5)', (1:5)', 10), ...
        DesignVariable(x(6:10)', (6:10)', 10), ...
        v1,v2,v3);
    out = horzcat(tensor{:});
    out = out(:);
end

function [out, Jac] = obj_fun3(x,k1,k2)
    [tensor, Jac] = uniax2tensor( ...
        k1,k2, ...
        DesignVariable(x(1:6), 1:6, 18), ...
        DesignVariable(x(7:12), 7:12, 18), ...
        DesignVariable(x(13:18), 13:18, 18) ...
    );
    out = horzcat(tensor{:});
    out = out(:);
end

function [out, Jac] = obj_fun4(x,k2,v2)
    [tensor, Jac] = uniax2tensor( ...
        DesignVariable(x(1:5)', (1:5)', 17), ...
        k2, ...
        DesignVariable(x(6:11), 6:11, 17), ...
        v2, ...
        DesignVariable(x(12:17), 12:17, 17) ...
    );
    out = horzcat(tensor{:});
    out = out(:);
end