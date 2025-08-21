function inputs = get_input_structure(fm)
% get_input_structure returns a struct with the following field names:
% M, O, chi, f0, X_probe, where each field value is another struct with the
% following fields:
%   ncols: number of columns; uint8 scalar
%   cols: variable representation of each column; 1-by-ncols string array
%   units: units of each column (pre-log transformation if
%          fm.c_args.log_args is true); 1-by-ncols string array

    % Get scaled units
    [length_unit, P_unit, C_unit, f_unit] = scale2units(fm.c_args.scale);

    % Other units
    Rth_units = "m^2*K/W";
    unitless = "-";

    % Format with ln(...) where relevant
    if fm.c_args.log_args, log_wrap = @(x) "ln(" + x + ")";
    else, log_wrap = @(x) x; end

    % Get cols and units for thermal conductivity and orientation
    [kf, of] = get_ko_structure(fm, "film", log_wrap);
    [ks, os] = get_ko_structure(fm, "sub", log_wrap);

    % Handle inf_sub_thick condition
    if fm.c_args.inf_sub_thick, hs = make_field("");
    else, hs = make_field(log_wrap("hs"), length_unit); end

    % Handle phase_only condition
    if fm.c_args.phase_only
        P = make_field("");
        Rf = make_field("");
        Rs = make_field("");
    else
        P = make_field(log_wrap("P"), P_unit);
        Rf = make_field(log_wrap("Rf"), unitless);
        Rs = make_field(log_wrap("Rs"), unitless);
    end

    % Build 'inputs'
    inputs = struct( ...
        "M", make_field( ...
            [ ...
                kf.cols, ...
                log_wrap(["Cf", "αf"]), ...
                Rf.cols, ...
                log_wrap("hf"), ...
                ks.cols, ...
                log_wrap(["Cs", "αs"]), ...
                Rs.cols, hs.cols, ...
                log_wrap("Rth"), ...
            ], ...
            [ ...
                kf.units, C_unit, "1/"+length_unit, Rf.units, length_unit, ...
                ks.units, C_unit, "1/"+length_unit, Rs.units, hs.units, Rth_units ...
            ] ...
        ), ...
        "O", make_field( ...
            [of.cols, os.cols], ...
            [of.units, os.units] ...
        ), ...
        "chi", make_field( ...
            [log_wrap(["sx", "sy"]), P.cols], ...
            [repmat(length_unit, 1, 2), P.units] ...
        ) ...
    );

    all_values = cellfun(@(fn) [inputs.(fn).cols, inputs.(fn).units], fieldnames(inputs), 'UniformOutput', false);
    all_values = horzcat(all_values{:});

    pad_n = max(strlength(all_values));

    inputs.msg = compose( ...
        "Function inputs 'M', 'O', 'chi', 'f0', and 'X_probe' should be formatted as follows:\n" ...
        ) + input_msg(inputs.M, "M", "N", pad_n) ...
        + input_msg(inputs.O, "O", "N_pump", pad_n) ...
        + input_msg(inputs.chi, "chi", "1", pad_n) ...
        + compose("f0: (N_f-by-1) [%s]\n\n", f_unit) ...
        + compose("X_probe: (N_probe-by-2) [%s]\n\n", length_unit);
    disp(inputs.msg)
end

%% ----------------- Helper Functions -------------------
function out = input_msg(s, name, nrows, pad_n)
    if s.ncols == 0
        out = compose("%s: []; i.e., empty array\n\n", name);
    else
        out = compose( ...
            "%s: (%s-by-%d)\n" + ...
            "    Column: | %s |\n" + ...
            "    Value:  | %s |\n" + ...
            "    Units:  | %s |\n\n", ...
            name, nrows, s.ncols, ...
            strjoin(pad(string(1:s.ncols), pad_n), " | "), ...
            strjoin(pad(s.cols, pad_n), " | "), ...
            strjoin(pad(s.units, pad_n), " | ") ...
        );
    end
end

function s = make_field(cols, units)
    if nargin < 2, units = ""; end
    if isempty(cols) || all(cols == "")
        s = struct("ncols", uint8(0), "cols", strings(1,0), "units", strings(1,0));
    else
        s = struct("ncols", uint8(numel(cols)), "cols", cols, "units", units);
    end
end

function [k, o] = get_ko_structure(fm, layer, log_wrap)
% get_ko_structure returns 2 structs with the following fields:
%   ncols: number of columns; uint8 scalar
%   cols: variable representation of each column; 1-by-ncols string array
%   units: units of each column (pre-log transformation if
%          fm.c_args.log_args is true); 1-by-ncols string array
%
% Inputs:
%   fm: ForwardModel object with validated constructor arguments (c_args)
%   layer: layer specification; "film" | "sub"

    % Thermal conductivity units
    k_units = "W/m/K";

    % Validate 'layer'
    layer = validatestring(layer, ["film", "sub"]);

    % Get subscript from 'layer'
    subscript = extractBefore(layer, 2);

    % Default o for 'iso' and 'tensor'
    o = make_field("","");

    % Format k and o based on constructor arguments
    switch fm.c_args.(layer+"_isotropy")
        case "iso"
            k = make_field( ...
                log_wrap("k" + subscript), ...
                k_units ...
            );
        case "simple"
            k = make_field( ...
                log_wrap("k" + subscript + ["⊥", "∥"]), ...
                repmat(k_units, 1, 2) ...
            );
            o = get_o_structure(fm, layer, 2);
        case "complex"
            k = make_field( ...
                log_wrap("kp" + subscript + (1:3)), ...
                repmat(k_units, 1, 3) ...
            );
            o = get_o_structure(fm, layer, 3);
        case "tensor"
            [i,j] = ndgrid(1:3,1:3);
            k_str = "k" + subscript + i + j;
            
            % Wrap diagonal elements in ln(...)
            k_str(i == j) = log_wrap(k_str(i == j));
            
            % Keep only lower triangle
            k_str = k_str(tril(true(size(k_str))));

            k = make_field(k_str', repmat(k_units, 1, 6));
    end
end

function o = get_o_structure(fm, layer, ndims)
% get_o_structure returns a structs with the following fields:
%   ncols: number of columns; uint8 scalar
%   cols: variable representation of each column; 1-by-ncols string array
%   units: units of each column (pre-log transformation if
%          fm.c_args.log_args is true); 1-by-ncols string array
%
% Inputs:
%   fm: ForwardModel object with validated constructor arguments (c_args)
%   layer: layer specification; "film" | "sub"
%   ndims: number of principal thermal conductivities

    % Angle and unitless units
    theta_units = "rad";
    unitless = "-";

    % Get subscript from 'layer'
    subscript = extractBefore(layer, 2);

    % Format o based on constructor arguments
    switch fm.c_args.(layer+"_orient")
        case "azpol"
            o = make_field( ...
                "θ" + subscript + ["_az", "_pol"], ...
                repmat(theta_units, 1, 2) ...
            );
        case "uvect"
            o = make_field( ...
                "v" + subscript + (1:3), ...
                repmat(unitless, 1, 3) ...
            );
        case "euler"
            o = make_field( ...
                "θ" + subscript + string(fm.c_args.euler_seq(1:ndims)')' + (1:ndims), ...
                repmat(theta_units, 1, ndims) ...
            );
        case "uquat"
            o = make_field( ...
                "q" + subscript + (1:4), ...
                repmat(unitless, 1, 4) ...
            );
        case "rotmat"
            [i,j] = ndgrid(1:3,1:3);
            o = make_field( ...
                "R" + subscript + i(:)' + j(:)', ...
                repmat(unitless, 1, 9) ...
            );
    end
end