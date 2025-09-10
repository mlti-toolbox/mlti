function [phi, A] = solve(fm, film_args, sub_args, Rth, ex_args, f0, X_probe)
    [kf{1:6}] = fm.film.toTensor(film_args{1:length(fm.film.inputStr)}, fm.exp_if_log);
    Cf = fm.exp_if_log(film_args{length(fm.film.inputStr)+1});
    af = fm.exp_if_log(film_args{length(fm.film.inputStr)+2});
    Rf = fm.getRf(film_args);
    hf = fm.exp_if_log(film_args{end});

    [ks{1:6}] = fm.substrate.toTensor(sub_args{1:length(fm.substrate.inputStr)}, fm.exp_if_log);
    Cs = fm.exp_if_log(sub_args{length(fm.film.inputStr)+1});
    as = fm.exp_if_log(sub_args{length(fm.film.inputStr)+2});
    Rs = fm.getRs(sub_args);
    % if fm.inf_sub_thick
    %     hs = {};
    % else
    %     hs = fm.exp_if_log(sub_args{end});
    % end
    hs = {};

    Rth = fm.exp_if_log(Rth);

    sx = fm.exp_if_log(ex_args{1});
    sy = fm.exp_if_log(ex_args{2});
    P  = fm.getP(ex_args);

    T0_hat = fm.T0_hat(kf{:},Cf,af,Rf,hf,ks{:},Cs,as,Rs,hs{:},Rth,sx,sy,P,f0,fm.ift_solver.u,fm.ift_solver.v);
    % T0 = fm.ift_sover.solve(T0_hat);
    T0 = ifftshift(ifft2(fftshift(T0_hat))) / (fm.ift_solver.x(2)-fm.ift_solver.x(1)) / (fm.ift_solver.y(2)-fm.ift_solver.y(1));  % Perform the inverse FFT
    phi = angle(T0);  % Convert temperature data to phase lag
    A = 2*abs(T0);

    if nargin > 6
        % interpolate with X_probe
    end
end