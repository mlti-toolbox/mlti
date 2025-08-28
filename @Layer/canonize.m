function [K11, K21, K31, K22, K32, K33, C, a, R, h] = canonize(obj, varargin)
    assert(nargin == obj.Nin, "Invalid number of input arguments. Expected %d, got %d.", obj.Nin, nargin)
    [K11, K21, K31, K22, K32, K33] = obj.ko2K(varargin);
    [C, a, R, h] = obj.getLast4(varargin);
end