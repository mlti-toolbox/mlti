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
        XYX, YXY, ZXY
        XYZ, YXZ, ZXZ
        XZX, YZX, ZYX
        XZY, YZY, ZYZ
    end

    properties (Constant, Access = private)
        Rx = @(t) [];
        Ry = @(t) [];
        Rz = @(t) [];
    end

    methods
        function options = cross_validate(seq, options)
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
                options struct
            end

            out_warn_msg = "Field removed, but change not assigned back to the structure.";
            not_alwd_msg = "Input value for 'euler_seq' not allowed when neither film_orient nor sub_orient equal 'euler'.";

            need_seq = ...
                (isfield(options, "film_orient") && strcmp(options.film_orient, "euler")) || ...
                (isfield(options, "sub_orient")  && strcmp(options.sub_orient, "euler"));
            
            if ~need_seq
                if ~isequal(seq, SeqEnum.ZYZ), error(not_alwd_msg); end
                if isfield(options, "euler_seq")
                    options = rmfield(options, "euler_seq");
                end
                if nargout < 1, warning(out_warn_msg); end
            end
        end
    end
end