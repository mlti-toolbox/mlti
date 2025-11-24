function T0tilde = solveifft2(solver, T0hat, X_probe)
arguments
    solver  (1,1)       IFTSolver
    T0hat   (:,:,:,:,:) double
    X_probe (:,2)       double = [];
end

center_indx1 = ceil(size(T0hat,1)/2)+1;
center_indx2 = ceil(size(T0hat,2)/2)+1;

if isnan(T0hat(center_indx1, center_indx2))
    T0hat(center_indx1, center_indx2) = mean([ ...
        T0hat(center_indx1+1, center_indx2), ...
        T0hat(center_indx1, center_indx2+1), ...
        T0hat(center_indx1-1, center_indx2), ...
        T0hat(center_indx1, center_indx2-1) ...
    ]);
end

T0tilde = fftshift(ifft2(ifftshift(T0hat), solver.args{:}))./solver.dx./solver.dy;

if ~isempty(X_probe)
    solver.interp.Values = T0tilde;
    T0tilde = solver.interp(X_probe);
end