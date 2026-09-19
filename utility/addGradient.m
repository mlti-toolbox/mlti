function Jac = addGradient(Jac, x, grad)
    %ADDGRADIENT Add gradient to Jacobian if x is a DesignVariable.

    if ~isa(x, "DesignVariable")
        return
    end

    g = grad();
    Nout = numel(g);

    if isempty(Jac)
        Jac = sparse(Nout, x.rootLen);
    end

    indx = 0;
    r = zeros(Nout,1);
    c = zeros(Nout,1);
    v = zeros(numel(g),1,"like",g);
    ndim = max(ndims(x.value),ndims(g));
    for Jc = 1:numel(x.value)
        [Jisub{1:ndim}] = ind2sub(size(x.value),Jc);
        gi = cell(ndim,1);
        for dim = 1:ndim
            if size(x.value,dim) == size(g,dim)
                gi{dim} = Jisub{dim};
            else
                gi{dim} = 1:size(g,dim);
            end
        end
        gv = g(gi{:});
        [Jrind{1:ndim}] = ndgrid(gi{:});
        Jr = sub2ind(size(g), Jrind{:});

        next = indx + numel(gv);
        subindx = indx+1:next;
        indx = next;
        c(subindx) = Jc;
        r(subindx) = Jr;
        v(subindx) = gv(:);
    end
    Jac = Jac + sparse(r,c,v,Nout,size(x.Jac,1)) * x.Jac;
end