function out = hyper_sphere(varargin)
    out = 0;
    Jac = [];

    for i = 1:numel(varargin)
        v = get_val(varargin{i});

        out = out + v.*v;
        Jac = addGradient(Jac, varargin{i}, @() 2*v);
    end

    out = out - 1;

    if ~isempty(Jac)
        out = DesignVariable(out, [], size(Jac,2), Jac);
    end
end