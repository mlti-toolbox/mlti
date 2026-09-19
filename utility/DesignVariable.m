classdef DesignVariable

    properties (SetAccess = private)
        value   double
        indx    double {mustBePositive, mustBeInteger}
        rootLen (1,1) double {mustBeNonnegative, mustBeInteger}
        Jac     (:,:) double
    end

    methods

        function obj = DesignVariable(value, indx, rootLen, Jac)
            if nargin < 2
                indx = reshape(1:numel(value), size(value));
            elseif ~isequal(size(value), size(indx)) && ~isempty(indx)
                try
                    indx = reshape(indx, size(value));
                catch exception
                    error('value and indx must have the same number of elements.')
                end
            end

            if nargin < 3 || isempty(rootLen)
                rootLen = numel(value);
            end

            if any(indx > rootLen)
                error('indx cannot exceed rootLen.')
            end

            if nargin < 4 || isempty(Jac)
                Jac = sparse(1:numel(value),indx(:),1,numel(value),rootLen);
            elseif ~isequal(size(Jac), [numel(value),rootLen])
                error('Jac must have size [numel(value), rootLen].')
            end

            obj.value = value;
            obj.indx = indx;
            obj.rootLen = rootLen;
            obj.Jac = Jac;
        end

        function out = at(obj, indx)
            out = DesignVariable(obj.value(indx), obj.indx(indx), obj.rootLen, obj.Jac(indx,:));
        end

        function obj = reshape(obj, varargin)
            obj.value = reshape(obj.value, varargin{:});
            obj.indx  = reshape(obj.indx, varargin{:});
        end

        function out = exp(obj)
            expx = exp(obj.value);
            out = DesignVariable(expx, [], obj.rootLen, expx*obj.Jac);
        end
    end
end