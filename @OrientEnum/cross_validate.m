function options = cross_validate(or, cr, layer, options)
    % cross_validate - Validate that orientation representation matches conductivity representation
    %
    % Syntax:
    %   OrientEnum.cross_validate(or, cr, layer)
    %   options = OrientEnum.cross_validate(or, cr, layer, options)
    %
    % Inputs:
    %   or      - OrientEnum enum
    %   cr      - IsotropyEnum enum
    %   layer   - String specifying the layer (used to construct field names)
    %   options - Struct of input arguments, may contain orientation fields
    %
    % Description:
    %   Checks that the orientation representation is compatible with the
    %   conductivity representation:
    %       - NA orientation is invalid for uniaxial/principal
    %       - azpol/uvect are only valid for uniaxial
    %       - Orientation fields are removed if not required
    %
    % Outputs:
    %   options - Updated struct (orientation field removed if not required)
    %
    % Note: If 'options' is not requested, the function will validate but
    % will not modify or return the struct.


    arguments
        or (1,1) OrientEnum
        cr (1,1) IsotropyEnum
        layer (1,1) string
        options struct
    end

    oname = layer + "_orient";
    iname = layer + "_isotropy";

    princ_opts = [OrientEnum.euler, OrientEnum.uquat, OrientEnum.rotmat];
    uni_opts = [OrientEnum.azpol, OrientEnum.uvect, princ_opts];

    reqd_msg = compose( ...
        "Input value for '%s' required when %s = '%s'.", ...
        oname, iname, cr ...
    );
    not_alwd_msg = compose( ...
        "Input value for '%s' not allowed when %s = '%s'.", ...
        oname, iname, cr ...
    );
    invalid_msg = compose( ...
        "Input, %s = '%s', is invalid when %s = '%s'.", ...
        oname, or, iname, cr ...
    );
    vld_opts_msg = @(opts) compose( ...
        "\nValid value options: %s", ...
        strjoin("'" + string(opts) + "'") ...
    );
    out_warn_msg = "Field removed, but change not assigned back to the structure.";

    switch cr
        case IsotropyEnum.uniaxial
            % Orientation required, must not be NA
            if or == OrientEnum.na
                error(reqd_msg + vld_opts_msg(uni_opts));
            end
        case IsotropyEnum.principal
            % Orientation required, must be EULER/UQUAT/ROTMAT
            if or == OrientEnum.na
                error(reqd_msg + vld_opts_msg(princ_opts));
            elseif ismember(or, [OrientEnum.azpol, OrientEnum.uvect])
                error(invalid_msg + vld_opts_msg(princ_opts));
            end
        otherwise
            % Orientation not needed
            if or ~= OrientEnum.na
                error(not_alwd_msg);
            end
            if nargin > 3 && isfield(options, oname)
                options = rmfield(options, oname);
                if nargout < 1
                    warning(out_warn_msg)
                end
            end
    end
end