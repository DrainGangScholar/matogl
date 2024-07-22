classdef JObj < handle & matlab.mixin.SetGet
    
    properties(SetAccess = protected)
        java
    end
    
    properties
        UserData
    end

    properties(Constant,Abstract)
        isEDT logical
        JClass char
    end
    
    methods
        function obj = JObj(varargin)
            if obj.isEDT
                obj.java = javaObjectEDT(obj.JClass,varargin{:});
            else
                obj.java = javaObject(obj.JClass,varargin{:});
            end
        end

        function v = const(obj,v)
            if isnumeric(v), return, end
            v = obj.java.(upper(v));
        end

        function delete(obj)
            obj.UserData = [];
        end
    end
end
