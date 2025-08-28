function [length_unit, P_unit, C_unit, f_unit] = scale2units(scale)
%SCALE2UNITS Return formatted SI unit strings based on scaling factor.
%
%   The input scale factor defines the units of forward model variables
%   relative to base SI units:
%       Length vars ~  scale ⋅ m
%       Power       ~  scale ⋅ W
%       Capacity    ~  W / (scale ⋅ m^3 ⋅ K)
%       Frequency   ~  Hz / scale
%
%   Example:
%       >> scale2units(1e-6)
%       ans =
%           "µm"    "µW"    "MW/m^3/K"    "MHz"
%
%   Supports scale ∈ [1e-15, 1e18).

    % Validate input
    if ~isscalar(scale) || ~isnumeric(scale) || scale <= 0
        error('Input must be a positive scalar.');
    end

    % Define SI prefixes (-15:3:15)
    prefixes = ["f","p","n","µ","m","","k","M","G","T","P"];
    exps = -15:3:15;

    % -------- Directly scaled quantities --------
    [num, symbol] = format_with_prefix(scale, exps, prefixes);
    if isempty(num)
    length_unit   = sprintf("%s%sm", "", symbol);
    P_unit        = sprintf("%s%sW", "", symbol);
    else
    length_unit   = sprintf("%s%sm", num2str(num)+"*", symbol);
    P_unit        = sprintf("%s%sW", num2str(num)+"*", symbol);
    end

    % -------- Inversely scaled quantities --------
    invscale = 1/scale;
    [num, symbol] = format_with_prefix(invscale, exps, prefixes);
    if isempty(num)
    f_unit        = sprintf("%sHz%s", symbol, "");
    C_unit        = sprintf("%sW/m^3/K%s", symbol, "");
    else
    f_unit        = sprintf("%sHz%s", symbol, "/"+num2str(1/num));
    C_unit        = sprintf("%sW/m^3/K%s", symbol, "/"+num2str(1/num));
    end

end

function [num, symbol] = format_with_prefix(value, exps, prefixes)
    % Get order of magnitude
    exponent = floor(log10(value));
    % Snap to nearest multiple of 3
    power3   = max(min(3*round(exponent/3), max(exps)), min(exps));
    % Scale value
    num      = value / 10^power3;
    if abs(num-1) < 1e-12
        num = [];
    end
    % Pick prefix
    idx      = (power3 - min(exps))/3 + 1;
    symbol   = prefixes(idx);
end