function [tensor,Jac] = uniax2tensor(lnkperpi,lnkpari,v1i,v2i,v3i)

lnkperp = get_val(lnkperpi);
lnkpar = get_val(lnkpari);
v1 = get_val(v1i);
v2 = get_val(v2i);
v3 = get_val(v3i);

t2 = exp(lnkpar);
t3 = exp(lnkperp);
t4 = v1.^2;
t5 = v2.^2;
t6 = v3.^2;
t7 = -t3;
t8 = t2+t7;
k11 = t3+t4.*t8;
t9 = t8.*v1;
k12 = t9.*v2;
k13 = t9.*v3;
k22 = t3+t5.*t8;
t10 = t8.*v2;
k23 = t10.*v3;
k33 = t3+t6.*t8;

tensor = {k11, k12, k13, k22, k23, k33};

if nargout > 1
    t11 = t8.*v3;
    sz = [length(lnkperp), length(v1)];
    
    Jac = zeros(numel(k11)*6,0);
    Jac = combineJacobians(Jac, lnkperpi, @get_jac_lnkperp);
    Jac = combineJacobians(Jac, lnkpari, @get_jac_lnkpar);
    Jac = combineJacobians(Jac, v1i, @get_jac_v1);
    Jac = combineJacobians(Jac, v2i, @get_jac_v2);
    Jac = combineJacobians(Jac, v3i, @get_jac_v3);
end
function jac_lnkperp = get_jac_lnkperp()
    dk11_dlnkperp = addGradient([], lnkperpi, @() t3+t4.*t7);
    dk12_dlnkperp = addGradient([], lnkperpi, @() t7.*v1.*v2);
    dk13_dlnkperp = addGradient([], lnkperpi, @() t7.*v1.*v3);
    dk22_dlnkperp = addGradient([], lnkperpi, @() t3+t5.*t7);
    dk23_dlnkperp = addGradient([], lnkperpi, @() t7.*v2.*v3);
    dk33_dlnkperp = addGradient([], lnkperpi, @() t3+t6.*t7);
    jac_lnkperp = [dk11_dlnkperp; dk12_dlnkperp; dk13_dlnkperp; dk22_dlnkperp; dk23_dlnkperp; dk33_dlnkperp];
end
function jac_lnkpar = get_jac_lnkpar()
    dk11_dlnkpar = addGradient([], lnkpari, @() t2.*t4);
    dk12_dlnkpar = addGradient([], lnkpari, @() t2.*v1.*v2);
    dk13_dlnkpar = addGradient([], lnkpari, @() t2.*v1.*v3);
    dk22_dlnkpar = addGradient([], lnkpari, @() t2.*t5);
    dk23_dlnkpar = addGradient([], lnkpari, @() t2.*v2.*v3);
    dk33_dlnkpar = addGradient([], lnkpari, @() t2.*t6);
    jac_lnkpar = [dk11_dlnkpar; dk12_dlnkpar; dk13_dlnkpar; dk22_dlnkpar; dk23_dlnkpar; dk33_dlnkpar];
end
function jac_v1 = get_jac_v1()
    dk11_dv1 = addGradient([], v1i, @() t9.*2);
    dk12_dv1 = addGradient([], v1i, @() t10);
    dk13_dv1 = addGradient([], v1i, @() t11);
    dk22_dv1 = addGradient([], v1i, @() zeros(sz));
    dk23_dv1 = addGradient([], v1i, @() zeros(sz));
    dk33_dv1 = addGradient([], v1i, @() zeros(sz));
    jac_v1 = [dk11_dv1; dk12_dv1; dk13_dv1; dk22_dv1; dk23_dv1; dk33_dv1];
end
function jac_v2 = get_jac_v2()
    dk11_dv2 = addGradient([], v2i, @() zeros(sz));
    dk12_dv2 = addGradient([], v2i, @() t9);
    dk13_dv2 = addGradient([], v2i, @() zeros(sz));
    dk22_dv2 = addGradient([], v2i, @() t10.*2);
    dk23_dv2 = addGradient([], v2i, @() t11);
    dk33_dv2 = addGradient([], v2i, @() zeros(sz));
    jac_v2 = [dk11_dv2; dk12_dv2; dk13_dv2; dk22_dv2; dk23_dv2; dk33_dv2];
end
function jac_v3 = get_jac_v3()
    dk11_dv3 = addGradient([], v3i, @() zeros(sz));
    dk12_dv3 = addGradient([], v3i, @() zeros(sz));
    dk13_dv3 = addGradient([], v3i, @() t9);
    dk22_dv3 = addGradient([], v3i, @() zeros(sz));
    dk23_dv3 = addGradient([], v3i, @() t10);
    dk33_dv3 = addGradient([], v3i, @() t11.*2);
    jac_v3 = [dk11_dv3; dk12_dv3; dk13_dv3; dk22_dv3; dk23_dv3; dk33_dv3];
end
end