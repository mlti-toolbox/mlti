function [tensor,Jac] = iso2tensor(lnki)
lnk = get_val(lnki);

k11 = exp(lnk); k12 = zeros(size(lnk)); k13 = k12;
k22 = k11;      k23 = k12;
k33 = k11;
tensor = {k11,k12,k13,k22,k23,k33};

if nargout > 1
    if isa(lnki, "DesignVariable")
        N = length(lnk);
        r = [1:N, 3*N+1:4*N, 5*N+1:6*N];
        c = [1:N, 1:N, 1:N];
        Jac = sparse(r,c,[k11;k11;k11]);
    else
        Jac = zeros(numel(k11)*6, 0);
    end
end