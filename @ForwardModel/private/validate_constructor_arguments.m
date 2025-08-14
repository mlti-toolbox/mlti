function [sortedProps, in_structure, in_sizes] = validate_constructor_params(obj, varargin)
    name_options = fieldnames(obj.vld);
    props = struct();

    % Validate input arguments independently and store in `props`.
    for i = 1:2:length(varargin)
        name = validatestring(varargin{i}, name_options);
        props.(name) = obj.vld.(name).selfValidate(varargin{i+1});
    end
    
    for i = 1:length(name_options)
        name = name_options{i};
        % Assign default values to 'props' where appropriate.
        if ~isfield(props, name)
            default_value = obj.vld.(name).getDefault(props);
            if ~isempty(default_value)
                props.(name) = default_value;
            end
        end
        % Validate input arguments against fully populated 'props'.
        if isfield(props, name) && isfield(obj.vld.(name), 'crossValidate')
            props = obj.vld.(name).crossValidate(props);
        end
    end

    % sort props for clean display
    sortedProps = struct();
    for i = 1:length(name_options)
        fld = name_options{i};
        if isfield(props, fld)
            sortedProps.(fld) = props.(fld);
        end
    end

    % generate in_structure TODO make this more elegant
    % TODO handle log_args
    if isfield(sortedProps, "film_orient")
        film_orient = sortedProps.film_orient;
    else
        film_orient = [];
    end

    if isfield(sortedProps, "sub_orient")
        sub_orient = sortedProps.sub_orient;
    else
        sub_orient = [];
    end

    if isfield(sortedProps, "euler_seq")
        seq = sortedProps.euler_seq;
    else
        seq = [];
    end

    [kf, of] = obj.format_ko(sortedProps.film_isotropy, film_orient, 'f', seq);
    [ks, os] = obj.format_ko(sortedProps.sub_isotropy, sub_orient, 's', seq);

    if sortedProps.inf_sub_thick
        hs = [];
    else
        hs = "hs";
    end

    if sortedProps.phase_only
        P = [];
        Rf = [];
        Rs = [];
    else
        P = "P";
        Rf = "Rf";
        Rs = "Rs";
    end

    in_structure{1} = [kf, "Cf", "αf", Rf, "hf", ks, "Cs", "αs", Rs, hs];
    in_structure{2} = [of, os];
    in_structure{3} = ["sx", "sy", P];

    in_sizes = [length(in_structure{1}), length(in_structure{2}), length(in_structure{3})];
end