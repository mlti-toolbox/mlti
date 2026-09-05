function uniax2tensor_gen()

syms lnkperp lnkpar v1 v2 v3

inputs = [lnkperp lnkpar v1 v2 v3];

kperp = exp(lnkperp);
kpar  = exp(lnkpar);

kpar_minus_kperp = kpar - kperp;

k11 = kpar_minus_kperp .* v1 .* v1 + kperp;
k12 = kpar_minus_kperp .* v2 .* v1;
k13 = kpar_minus_kperp .* v3 .* v1;
k22 = kpar_minus_kperp .* v2 .* v2 + kperp;
k23 = kpar_minus_kperp .* v3 .* v2;
k33 = kpar_minus_kperp .* v3 .* v3 + kperp;
outputs = {k11, k12, k13, k22, k23, k33};
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
    File='uniax2tensor_auto_optimized', ...
    Outputs=[output_names(:); grad_names(:)] ...
);
end