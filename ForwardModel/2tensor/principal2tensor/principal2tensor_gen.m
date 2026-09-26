function principal2tensor_gen()

syms lnkp1 lnkp2 lnkp3 q1 q2 q3 q4 real

inputs = [lnkp1 lnkp2 lnkp3 q1 q2 q3 q4];

kp1 = exp(lnkp1); kp2 = exp(lnkp2); kp3 = exp(lnkp3);

R = [2*(q1^2+q2^2)-1  2*(q2*q3-q1*q4)  2*(q2*q4+q1*q3)
     2*(q2*q3+q1*q4)  2*(q1^2+q3^2)-1  2*(q3*q4-q1*q2)
     2*(q2*q4-q1*q3)  2*(q3*q4+q1*q2)  2*(q1^2+q4^2)-1];

K = R*diag([kp1,kp2,kp3])*R.';

% Check if K is symmetric
if ~isequal(K, K.')
    error("K is not symmetric!")
end

outputs = {K(1,1), K(1,2), K(1,3), K(2,2), K(2,3), K(3,3)};
output_names = ["k11", "k12", "k13", "k22", "k23", "k33"];

grads = cell(length(outputs), length(inputs));
grad_names = "d" + output_names(:) + "_d" + string(inputs);

for i = 1:length(outputs)
    for j = 1:length(inputs)
        grads{i,j} = gradient(outputs{i}, inputs(j));
    end
end

matlabFunction( ...
    outputs{:}, grads{:}, ...
    Vars=inputs, Optimize=true, ...
    File='principal2tensor_auto_optimized', ...
    Outputs=[output_names(:); grad_names(:)] ...
);
end