function c_args = validate_c_args(fm, varargin)
% validate_c_args - Validates and populates constructor arguments
%
%   c_args = validate_c_args(fm, varargin) validates, default-populates,
%   and cross-validates name-value pair inputs for the ForwardModel 
%   constructor using the fm.vld struct for argument specification.
%
%   This method uses the validation and default rules stored in fm.vld 
%   (see ForwardModel.vld documentation) to:
%     1. Validate user-provided argument names.
%     2. Validate user-provided argument values independently.
%     3. Populate missing arguments with default values, if available.
%     4. Cross-validate arguments in the context of all other arguments.
%     5. Return arguments as a struct with fields ordered consistently 
%        with fm.vld.
%
%   Input Arguments:
%     fm       - ForwardModel object containing the vld specification.
%     varargin - Name-value pairs of constructor arguments to validate.
%
%   Output Arguments:
%     c_args   - Struct containing validated and default-populated 
%                constructor arguments, ordered to match fieldnames(fm.vld).
%
%   Validation Process:
%     Step 1: Name validation
%       - Ensures each provided name matches a valid field in fm.vld using
%         name = validatestring(name, fieldname(fm.vld))
%     Step 2: Independent value validation
%       - Calls fm.vld.(name).selfValidate(value) for each input value.
%     Step 3: Default assignment
%       - For missing names, calls fm.vld.(name).getDefault(c_args).
%       - Skips if getDefault returns an empty array.
%     Step 4: Cross-validation
%       - If defined, calls fm.vld.(name).crossValidate(c_args_temp) for
%         each populated argument.
%     Step 5: Output ordering
%       - Returns arguments in the same order as fieldnames(fm.vld).
%
%   See also: ForwardModel.ForwardModel, ForwardModel.VLD, validatestring

    name_options = fieldnames(fm.vld);
    c_args_temp = struct();

    for i = 1:2:length(varargin)
        % Validate each user-input argument name.
        name = validatestring(varargin{i}, name_options);

        % Validate each user-input argument value.
        c_args_temp.(name) = fm.vld.(name).selfValidate(varargin{i+1});
    end
    
    for i = 1:length(name_options)
        name = name_options{i};

        % Populate missing arguments with defaults.
        if ~isfield(c_args_temp, name)
            default_value = fm.vld.(name).getDefault(c_args_temp);
            if ~isempty(default_value)
                c_args_temp.(name) = default_value;
            end
        end

        % Perform cross-validation for each name in c_args.
        if isfield(c_args_temp, name) && isfield(fm.vld.(name), 'crossValidate')
            c_args_temp = fm.vld.(name).crossValidate(c_args_temp);
        end
    end

    % sort c_args for clean display
    c_args = struct();
    for i = 1:length(name_options)
        fld = name_options{i};
        if isfield(c_args_temp, fld)
            c_args.(fld) = c_args_temp.(fld);
        end
    end
end