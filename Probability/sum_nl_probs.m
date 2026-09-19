function psi = sum_nl_probs(varargin)
    psi = 0;
    Jac = [];
    for i = 1:length(varargin)
        if isa(varargin{i}, "DesignVariable")
            psi = psi + varargin{i}.value;
            if isempty(Jac)
                Jac = varargin{i}.Jac;
                rootLen = varargin{i}.rootLen;
            else
                Jac = Jac + varargin{i}.Jac;
            end
        end
    end
    psi = DesignVariable(psi, [], rootLen, Jac);
end