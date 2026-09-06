function [tensor,Jac] = tensor2tensor(k11i, k12i, k13i, k22i, k23i, k33i)
k11 = get_val(k11i);
k12 = get_val(k12i);
k13 = get_val(k13i);
k22 = get_val(k22i);
k23 = get_val(k23i);
k33 = get_val(k33i);

tensor = {k11,k12,k13,k22,k23,k33};
if nargout > 1
    N = numel(k11);
    Jac = zeros(6*N,0);
    Jac = combineJacobians(Jac, k11i, @() sparse(0*N+1:1*N, k11i.indx, 1, 6*N, k11i.rootLen));
    Jac = combineJacobians(Jac, k12i, @() sparse(1*N+1:2*N, k12i.indx, 1, 6*N, k11i.rootLen));
    Jac = combineJacobians(Jac, k13i, @() sparse(2*N+1:3*N, k13i.indx, 1, 6*N, k11i.rootLen));
    Jac = combineJacobians(Jac, k22i, @() sparse(3*N+1:4*N, k22i.indx, 1, 6*N, k11i.rootLen));
    Jac = combineJacobians(Jac, k23i, @() sparse(4*N+1:5*N, k23i.indx, 1, 6*N, k11i.rootLen));
    Jac = combineJacobians(Jac, k33i, @() sparse(5*N+1:6*N, k33i.indx, 1, 6*N, k11i.rootLen));
end