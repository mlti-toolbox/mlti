function T0hat = T0hatRepmat(T0hat_fh,varargin)
    sz = [size(varargin{1}), length(varargin{25})];
    args = cell(size(varargin));
    for i = 1:length(varargin)
        if i == 25
            pause(1);
        end
        args{i} = extend(varargin{i}, sz);
    end
    T0hat = T0hat_fh(args{:});
end
function x = extend(x, sz)
    szx = size(x);
    x = repmat(x, sz ./ [szx, ones(1, length(sz) - length(szx))]);
end