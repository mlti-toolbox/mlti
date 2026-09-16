classdef ForwardModel
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        film_2tensor_handle
        sub_2tensor_handle
        T0hat_handle
    end

    methods
        function obj = ForwardModel(film_isotropy, sub_isotropy, inf_sub_thickness)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                film_isotropy (1,1) IsotropyEnum
                sub_isotropy  (1,1) IsotropyEnum
                inf_sub_thickness (1,1) logical = true;
            end
            obj.film_2tensor_handle = film_isotropy.toTensor;
            obj.sub_2tensor_handle = sub_isotropy.toTensor;
            if inf_sub_thickness
                obj.T0hat_handle = @T0hat_infinite;
            else
                obj.T0hat_handle = @T0hat_finite;
            end
        end

        function [T0tilde, Jac] = solve(obj, ...
                film_cond, film_orient, lnCf, lnaf, logitRf, lnhf, ...
                sub_cond,  sub_orient,  lnCs, lnas, logitRs, lnhs, ...
                lnRth, sx, sy, P, f, ifft_x_max, ifft_Nx, Xprobe ...
            )
            arguments
                obj (1,1) ForwardModel
                film_cond
                film_orient
                lnCf
                lnaf
                logitRf
                lnhf
                sub_cond
                sub_orient 
                lnCs 
                lnas 
                logitRs 
                lnhs 
                lnRth 
                sx 
                sy 
                P 
                f 
                ifft_x_max 
                ifft_Nx 
                Xprobe = [];
            end
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here

            if isa(ifft_x_max, "DesignVariable") || isa(ifft_Nx, "DesignVariable") || isa(Xprobe, "DesignVariable")
                error("ForwardModel does not currently support x_max, Nx, or Xprobe as DesignVariable objects")
            end
            
            dx = ifft_x_max ./ floor(ifft_Nx/2);
            du = 1 ./ (ifft_Nx * dx);
            steps = -floor(ifft_Nx/2) : ceil(ifft_Nx/2) - 1;
            x = steps(:) .* dx;
            y = steps(:).' .* dx;
            u = steps(:) .* du;
            v = steps(:).' .* du;

            if nargout < 2
                film_tensor = obj.film_2tensor_handle(film_cond{:}, film_orient{:});
                sub_tensor = obj.sub_2tensor_handle(sub_cond{:}, sub_orient{:});
                                
                T0hat = obj.T0hat_handle( ...
                    film_tensor{:}, lnCf, lnaf, logitRf, lnhf, ...
                    sub_tensor{:},  lnCs, lnas, logitRs, lnhs, ...
                    lnRth, sx, sy, P, f, u, v ...
                );

                T0tilde = ifftshift(ifft2(fftshift(T0hat)))./dx./dx;

                if ~isempty(Xprobe)
                    [~, ~, N, n, Nf] = size(T0tilde);
                    Nprobe = size(Xprobe,1);
                    T0tilde_interp = zeros(Nprobe,N,n,Nf);
                    for i = 1:N
                        xi = min(i, size(x,3));
                        yi = min(i, size(y,3));
                    for j = 1:n
                        xj = min(j, size(x,4));
                        yj = min(j, size(y,4));
                    for k = 1:Nf
                        xk = min(k, size(x,5));
                        yk = min(k, size(y,5));
                    
                        xvec = x(:,1,xi,xj,xk);
                        yvec = y(1,:,yi,yj,yk);
                        V    = T0tilde(:,:,i,j,k);
                    
                        F = griddedInterpolant({xvec, yvec}, V, 'linear', 'none');
                        T0tilde_interp(:,i,j,k) = F(Xprobe(:,1), Xprobe(:,2));
                    end
                    end
                    end
                    
                    T0tilde = T0tilde_interp;
                end
            else
                Jac1 = [];
                [film_tensor, film_tensor_jac] = obj.film_2tensor_handle(film_cond{:}, film_orient{:});
                if ~isempty(film_tensor_jac)
                    Jac1 = [eye(size(film_tensor_jac,2)); film_tensor_jac];
                end
                [sub_tensor, sub_tensor_jac] = obj.sub_2tensor_handle(sub_cond{:}, sub_orient{:});
                if ~isempty(sub_tensor_jac)
                    if isempty(Jac1)
                        Jac1 = eye(size(sub_tensor_jac,2));
                    end
                    Jac1 = [Jac1; sub_tensor_jac];
                end

                if isempty(Jac1)
                    [T0hat, T0hat_jac] = obj.T0hat_handle( ...
                        film_tensor{:}, lnCf, lnaf, logitRf, lnhf, ...
                        sub_tensor{:},  lnCs, lnas, logitRs, lnhs, ...
                        lnRth, sx, sy, P, f, u, v ...
                    );
                else
                    [N2, N1] = size(Jac1);
                    indx = N1;
                    if ~isempty(film_tensor_jac)
                        for i = 1:length(film_tensor)
                            next = indx+numel(film_tensor{i});
                            film_tensor{i} = DesignVariable(film_tensor{i}, reshape(indx+1:next, size(film_tensor{i})), N2);
                            indx = next;
                        end
                    end
                    if ~isempty(sub_tensor_jac)
                        for i = 1:length(sub_tensor)
                            next = indx+numel(sub_tensor{i});
                            sub_tensor{i} = DesignVariable(sub_tensor{i}, reshape(indx+1:next, size(sub_tensor{i})), N2);
                            indx = next;
                        end
                    end

                    args = [ ...
                        film_tensor(:)', ...
                        {newRootLen(lnCf, N2)}, ...
                        {newRootLen(lnaf, N2)}, ...
                        {newRootLen(logitRf, N2)}, ...
                        {newRootLen(lnhf, N2)}, ...
                        sub_tensor(:)', ...
                        {newRootLen(lnCs, N2)}, ...
                        {newRootLen(lnas, N2)}, ...
                        {newRootLen(logitRs, N2)}, ...
                        {newRootLen(lnhs, N2)}, ...
                        {newRootLen(lnRth, N2)}, ...
                        {newRootLen(sx, N2)}, ...
                        {newRootLen(sy, N2)}, ...
                        {newRootLen(P, N2)}, ...
                        {newRootLen(f, N2)}, ...
                        {newRootLen(u, N2)}, ...
                        {newRootLen(v, N2)} ...
                    ];

                    [T0hat, T0hat_jac] = obj.T0hat_handle(args{:});
                    T0hat_jac = T0hat_jac * Jac1;
                end
                [Nx,Ny,N,n,Nf] = size(T0hat);
                T0hat_jac = reshape(full(T0hat_jac), Nx,Ny,N,n,Nf,[]);
                N1 = size(T0hat_jac, 6);

                T0tilde = ifftshift(ifft2(fftshift(T0hat)))./dx./dx;
                T0tilde_jac = ifftshift(ifft2(fftshift(T0hat_jac)))./dx./dx;

                if ~isempty(Xprobe)
                    Nprobe = size(Xprobe,1);
                    T0tilde_interp = zeros(Nprobe,N,n,Nf);
                    T0tilde_jac_interp = zeros(Nprobe,N,n,Nf,N1);
                    for i = 1:N
                        xi = min(i, size(x,3));
                        yi = min(i, size(y,3));
                    for j = 1:n
                        xj = min(j, size(x,4));
                        yj = min(j, size(y,4));
                    for k = 1:Nf
                        xk = min(k, size(x,5));
                        yk = min(k, size(y,5));
                    
                        xvec = x(:,1,xi,xj,xk);
                        yvec = y(1,:,yi,yj,yk);
                        V    = T0tilde(:,:,i,j,k);
                    
                        F = griddedInterpolant({xvec, yvec}, V, 'linear', 'none');
                        T0tilde_interp(:,i,j,k) = F(Xprobe(:,1), Xprobe(:,2));

                        if ~isempty(T0tilde_jac)
                            F_jac = griddedInterpolant({xvec, yvec}, zeros(numel(xvec), numel(yvec)), 'linear', 'none');
                            F_jac.Values = T0tilde_jac(:,:,i,j,k,:);
                            T0tilde_jac_interp(:,i,j,k,:) = F_jac(Xprobe(:,1), Xprobe(:,2));
                        end
                    end
                    end
                    end
                    
                    T0tilde = T0tilde_interp;
                    T0tilde_jac = T0tilde_jac_interp;
                end
                Jac = reshape(T0tilde_jac, [prod(size(T0tilde_jac, 1:ndims(T0tilde_jac)-1)), N1]);
            end
        end
    end
end

function x = newRootLen(x, N)
    if isa(x, "DesignVariable")
        x = DesignVariable(x.value, x.indx, N);
    end
end