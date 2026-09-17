classdef DesignVariable

    properties (SetAccess = private)
        value   double
        indx    double {mustBePositive, mustBeInteger}
        rootLen (1,1) double {mustBeNonnegative, mustBeInteger}
    end

    methods

        function obj = DesignVariable(value, indx, rootLen)
            arguments
                value   double
                indx    double {mustBePositive, mustBeInteger} = reshape(1:numel(value), size(value))
                rootLen (1,1) double {mustBeNonnegative, mustBeInteger} = numel(value)
            end

            if size(value) ~= size(indx)
                error('value and indx must be the same size.')
            end

            if any(indx > rootLen)
                error('indx cannot exceed rootLen.')
            end

            obj.value = value;
            obj.indx = indx;
            obj.rootLen = rootLen;
        end

        function out = at(obj, indx)
            out = DesignVariable(obj.value(indx), obj.indx(indx), obj.rootLen);
        end

        function obj = reshape(obj, varargin)
            obj.value = reshape(obj.value, varargin{:});
            obj.indx = reshape(obj.indx, varargin{:});
        end

    end
end