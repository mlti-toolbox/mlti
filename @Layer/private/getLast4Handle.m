function [getLast4, sz] = getLast4Handle(obj)
    if obj.inf_thick
        if obj.phase_only
            getLast4 = @(args) deal( ...
                obj.exp_if_log(args{end-1}), ... % C
                obj.exp_if_log(args{end}), ...   % alpha
                0, ...                           % R
                inf ...                          % h
            );
            sz = 2;
        else
            getLast4 = @(args) deal( ...
                obj.exp_if_log(args{end-2}), ... % C
                obj.exp_if_log(args{end-1}), ... % alpha
                args{end}, ...                   % R
                inf ...                          % h
            );
            sz = 3;
        end
    else
        if obj.phase_only
            getLast4 = @(args) deal( ...
                obj.exp_if_log(args{end-2}), ... % C
                obj.exp_if_log(args{end-1}), ... % alpha
                0, ...                           % R
                obj.exp_if_log(args{end}) ...    % h
            );
            sz = 3;
        else
            getLast4 = @(args) deal( ...
                obj.exp_if_log(args{end-3}), ... % C
                obj.exp_if_log(args{end-2}), ... % alpha
                args{end-1}, ...                 % R
                obj.exp_if_log(args{end}) ...    % h
            );
            sz = 4;
        end
    end
end
