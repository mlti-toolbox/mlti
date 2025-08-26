classdef OrientEnum
% OrientEnum - Orientation representations for conductivity axes.
%
% OrientEnum is an enumeration class that defines property
% value validation for orientation properties.
%
% OrientEnum Enumerations:
%
%   NA      - Orientation specification not needed
%   AZPOL   - Azimuthal and polar angles (θ_az, θ_pol) of symmetry axis
%   UVECT   - Unit vector (v1, v2, v3) of symmetry axis
%   EULER   - Euler angles (θA1, θB2, θC3) for principal axes orientation; A,B,C ∈ {X,Y,Z}
%   UQUAT   - Unit quaternion (q1, q2, q3, q4) for principal axes orientation
%   ROTMAT  - Rotation matrix (R11, R21, R31, R12, R22, R32, R13, R23, R33) representation of principal axes orientation
%
% See also:
% IsotropyEnum,
% ForwardModel,
% <a href="https://www.mathworks.com/help/matlab/enumeration-classes.html">Enumerations</a>,
% <a href="https://www.mathworks.com/help/matlab/matlab_oop/restrict-property-values-to-enumerations.html">Enumerations for Property Values</a>
% 
% Note: axpol and uvect are only valid for uniaxial conductivity representations.

    enumeration
        na, azpol, uvect, euler, uquat, rotmat
    end

    properties (Dependent)
        No % Length of the orientation vector for this representation.
    end
    
    methods
        function No = get.No(obj)
            switch obj
                case OrientEnum.na
                    No = 0;
                case OrientEnum.azpol
                    No = 2;
                case OrientEnum.uvect
                    No = 3;
                case OrientEnum.euler
                    No = 3;
                case OrientEnum.uquat
                    No = 4;
                case OrientEnum.rotmat
                    No = 9;
            end
        end
    end
end