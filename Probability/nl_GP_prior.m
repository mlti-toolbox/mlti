function [psi, Jac] = nl_GP_prior(x, f, mu, K)
    if nargout < 2
        fx = f(x);
        mux = mu(x);
        Kxx = K(x,x);
        psi = nl_mvn_cov(fx,mux,Kxx);
    else
        inputs = cell(3,1);
        Jacs = cell(3,1);

        [inputs{1}, Jacs{1}] = f(x);
        [inputs{2}, Jacs{2}] = mu(x);
        [inputs{3}, Jacs{3}] = K(x,x);
        
        Jac_f_mu_K_x = vertcat(Jacs{:});
        N = size(Jac_f_mu_K_x,1);

        indx = 0;
        for i = 1:length(inputs)
        if ~isempty(Jacs{i})
            next = indx+numel(inputs{i});
            inputs{i} = DesignVariable(inputs{i}, reshape(indx+1:next, size(inputs{i})), N);
            indx = next;
        end
        end

        [psi, Jac] = nl_mvn_cov(inputs{:});
        if ~isempty(Jac)
            Jac = Jac * Jac_f_mu_K_x;
        end
    end
end