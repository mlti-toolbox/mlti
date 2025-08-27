function [phi, A, DC] = solve(fm, M, O, chi, f0, X_probe)
% M N_T-by-N_pump-by-Nm
% O N_pump-by-No
% chi 1-by-N_chi
% f0 Nf-by-1
% SOLVE Summary of this function goes here
%   Detailed explanation goes here
% m = [k-vars, o-vars, C, a, R, h]
length_kof = fm.c_args.film_isotropy.Nk + fm.c_args.film_orient.No;
kof2Kf = fm.c_args.film_isotropy.ko2K(fm.c_args.film_orient);
[Kf{1:6}] = kof2Kf(varargin{1:length_kof});
if fm.c_args.phase_only
    film_cell = {Kf{:}, varargin{length_kof+1:length_kof+3}}
    length_R = 0;
else
    length_R = 1;
end

length_film = length_kof + length_R + 3;



film_cell = 
length_kos = fm.c_args.sub_isotropy.Nk + fm.c_args.sub_orient.No;

kos2Ks = fm.c_args.sub_isotropy.ko2K(fm.c_args.sub_orient);
[Ks{1:6}] = kos2Ks(varargin{length_film+1:length_film+length_kos});

if fm.c_args.inf_sub_thick, length_hs = 0;
else, length_hs = 1; end
assert(isequal(length(varargin), length_kof + length_kos + 3 * length_R + length_hs + 10));

phi = NaN;
A = NaN;
DC = NaN;
end