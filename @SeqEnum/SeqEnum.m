classdef SeqEnum
% SeqEnum - Euler angle rotation sequence representations
%
% SeqEnum is an enumeration class that defines possible axis sequences
% for Euler angle rotations. These sequences determine the order of
% successive rotations about coordinate axes (X, Y, Z).
%
% SeqEnum Enumerations:
%   XYX, YXY, ZXY
%   XYZ, YXZ, ZXZ
%   XZX, YZX, ZYX
%   XZY, YZY, ZYZ
%
% See also:
% OrientationRepresentation,
% <a href="https://www.mathworks.com/help/matlab/enumeration-classes.html">Enumerations</a>,
% <a href="https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html">Enumerations for Property Values</a>
%
% Notes:
%   - Euler sequences are only required when orientation representation
%     is specified as 'euler' (see OrientationRepresentation).
%   - If not required, SeqEnum defaults to ZYZ and other values are ignored.

    enumeration
        na
        XYX, YXY, ZXY
        XYZ, YXZ, ZXZ
        XZX, YZX, ZYX
        XZY, YZY, ZYZ
    end

    methods
        function cross_validate(seq, orient)
            % CROSS_VALIDATE Ensures consistency of Euler sequence options.
            %
            % If Euler orientations are not required, the sequence must be ZYZ.
            % Removes 'euler_seq' from options if unnecessary.
            %
            % Inputs:
            %   seq     - SeqEnum value (Euler sequence candidate)
            %   options - struct with optional fields:
            %               film_orient: orientation type for film
            %               sub_orient : orientation type for substrate
            %               euler_seq  : stored Euler sequence
            %
            % Outputs:
            %   options - validated and possibly cleaned struct

            arguments
                seq (1,1) SeqEnum
                orient (1,1) OrientEnum
            end

            reqd_msg = compose( ...
                "\nInput value for 'euler_seq' required " + ...
                "when orient = 'euler'." ...
            );
            not_alwd_msg = compose( ...
                "\nInput value for 'euler_seq' not allowed " + ...
                "when orient ~= 'euler'." ...
            );

            if orient == OrientEnum.euler && seq == SeqEnum.na
                error(reqd_msg)
            end
            if orient ~= OrientEnum.euler && seq ~= SeqEnum.na
                error(not_alwd_msg);
            end
        end
    end
end