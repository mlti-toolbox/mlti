function cross_validate(orient, isotropy)
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
        orient (1,1) OrientEnum
        isotropy (1,1) IsotropyEnum
    end

    princ_opts = [OrientEnum.euler, OrientEnum.uquat, OrientEnum.rotmat];
    uni_opts = [OrientEnum.azpol, OrientEnum.uvect, princ_opts];

    reqd_msg = compose( ...
        "\nInput value for 'orient' required when isotropy = '%s'.", ...
        isotropy ...
    );
    not_alwd_msg = compose( ...
        "\nInput value for 'orient' not allowed when isotropy = '%s'.", ...
        isotropy ...
    );
    invalid_msg = compose( ...
        "\nInput, orient = '%s', is invalid when isotropy = '%s'.", ...
        orient, isotropy ...
    );
    vld_opts_msg = @(opts) compose( ...
        "\nValid value options: %s", ...
        strjoin("'" + string(opts) + "'") ...
    );

    switch isotropy
        case IsotropyEnum.uniaxial
            % Orientation required, must not be NA
            if orient == OrientEnum.na
                error(reqd_msg + vld_opts_msg(uni_opts));
            end
        case IsotropyEnum.principal
            % Orientation required, must be EULER/UQUAT/ROTMAT
            if orient == OrientEnum.na
                error(reqd_msg + vld_opts_msg(princ_opts));
            elseif ismember(orient, [OrientEnum.azpol, OrientEnum.uvect])
                error(invalid_msg + vld_opts_msg(princ_opts));
            end
        otherwise
            % Orientation not needed
            if orient ~= OrientEnum.na
                error(not_alwd_msg);
            end
    end
end