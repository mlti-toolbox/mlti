function Jac = addGradient(Jac, x, grad)
    %ADDGRADIENT Add gradient to Jacobian if x is a DesignVariable.

    if ~isa(x, "DesignVariable")
        return
    end

    g = grad();
    Nin = x.rootLen;
    Nout = numel(g);

    if isempty(Jac)
        Jac = sparse(Nout, Nin);
    end

    count = 0;
    r = zeros(Nout,1);
    c = zeros(Nout,1);
    v = zeros(numel(g),1,"like",g);
    for Jc = 1:numel(x.indx)
        [i,j,k,l] = ind2sub(size(x.value),Jc);
        Jisub = [i,j,k,l];
        gi = cell(4,1);
        for dim = 1:4
            if size(x.value,dim) == size(g,dim)
                gi{dim} = Jisub(dim);
            else
                gi{dim} = 1:size(g,dim);
            end
        end
        gv = g(gi{:});
        [A,B,C,D] = ndgrid(gi{:});
        Jr = sub2ind(size(g), A,B,C,D);

        subindx = count*numel(gv)+1:(count+1)*numel(gv);
        count = count + 1;
        c(subindx) = x.indx(Jc);
        r(subindx) = Jr;
        v(subindx) = gv(:);
    end
    Jac = Jac + sparse(r,c,v,Nout, Nin);
end