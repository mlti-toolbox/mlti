function [tensor,Jac] = iso2tensor(lnki)
lnk = get_val(lnki);

k11 = exp(lnk); k12 = zeros(size(lnk)); k13 = k12;
k22 = k11;      k23 = k12;
k33 = k11;
tensor = {k11,k12,k13,k22,k23,k33};

if nargout > 1
    Jac = zeros(numel(k11)*6,0);
    Jac = combineJacobians(Jac, lnki, @get_jac_lnk);
end

function jac_lnk = get_jac_lnk()
    sz = size(k11);
    dk11_dlnk = addGradient([], lnki, @() k11);
    dk12_dlnk = addGradient([], lnki, @() zeros(sz));
    dk13_dlnk = addGradient([], lnki, @() zeros(sz));
    dk22_dlnk = addGradient([], lnki, @() k11);
    dk23_dlnk = addGradient([], lnki, @() zeros(sz));
    dk33_dlnk = addGradient([], lnki, @() k11);
    jac_lnk = [dk11_dlnk; dk12_dlnk; dk13_dlnk; dk22_dlnk; dk23_dlnk; dk33_dlnk];
end
end