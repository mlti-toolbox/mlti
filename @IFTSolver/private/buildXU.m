function [x, dx, u] = buildXU(x_max, dx, Nx)

if x_max == 0 && dx == 0
    error("Must provide either 'x_max' or 'dx' as IFTSolver name-value arguments when method = 'ifft2'.");
end
if x_max ~= 0 && dx ~= 0 && Nx ~= 0
    error("Must NOT provide all three ('x_max', 'dx', 'Nx') as IFTSolver name-value arguments.")
end
if Nx == 0
    if x_max ~= 0 && dx ~= 0
        Nx = floor(x_max/dx) * 2 + 1;
    else
        Nx = 256;
    end
end
if dx == 0
    dx = x_max / floor(Nx/2);
end

du = 1 / (Nx * dx);
steps = -floor(Nx/2) : ceil(Nx/2) - 1;
x = steps * dx;
u = steps * du;