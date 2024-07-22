classdef Array < glmu.internal.Drawable
    
    properties
        array
        primitive
    end
    
    methods
        function obj = Array(program,primitive,varargin)
            obj@glmu.internal.Drawable(program);
            obj.primitive = obj.Const(primitive,1);
            obj.array = glmu.ArrayPointer(varargin{:});
        end

        function DrawFcn(obj,first,count)
            if nargin < 2, first = 0; end
            if nargin < 3, count = min(cellfun(@(c) c.nbVertex,obj.array.attrib)); end
            obj.array.Bind;
            obj.gl.glDrawArrays(obj.primitive,first,count);
        end
    end
end

