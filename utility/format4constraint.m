function [ineqnonlin,eqnonlin,Gineqnonlin,Geqnonlin] = format4constraint(ineqfn, eqfn, x)
    if nargout < 3
        if isempty(ineqfn)
            ineqnonlin = [];
        else
            ineqnonlin = format4optim(ineqfn, x);
        end
    
        if isempty(eqfn)
            eqnonlin = [];
        else
            eqnonlin = format4optim(eqfn, x);
        end
    else
        if isempty(ineqfn)
            ineqnonlin = [];
            Gineqnonlin = [];
        else
            [ineqnonlin, Gineqnonlin] = format4optim(ineqfn, x);
        end
    
        if isempty(eqfn)
            eqnonlin = [];
            Geqnonlin = [];
        else
            [eqnonlin, Geqnonlin] = format4optim(eqfn, x);
        end
    end
end