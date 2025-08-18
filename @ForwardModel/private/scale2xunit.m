function out = scale2xunit(x)
    % scale2xunit Format a number with SI prefix.
    % Supports inputs roughly in ±[1e-15, 1e18).
    % Example: format_number(0.00012) -> "120µ"

    % Validate input
    if ~isscalar(x)
        error('Input must be a scalar.');
    end
    
    % Define SI prefixes for powers -15 to +15, step 3
    symbols = ["f", "p", "n", "µ", "m", "", "k", "M", "G", "T", "P"];
    
    exponent = floor(log10(x));
    power3 = floor(exponent / 3);
    
    % Clamp power3 to valid range: -5 to +5 corresponding to symbols indices 1..11
    power3 = max(min(power3, 5), -5);
    
    % Calculate index into symbols array (offset by 6)
    indx = power3 + 6;
    
    % Scale number accordingly
    out_x = x / 10^(power3 * 3);

    if out_x - 1 < 1e-12
        out_x = [];
    end
    
    % Format output string: numeric + symbol
    out = sprintf('[%.3g%sm]', out_x, symbols(indx));
end