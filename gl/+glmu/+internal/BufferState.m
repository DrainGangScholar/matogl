classdef BufferState < glmu.internal.ObjectState
    
    properties
        newFcn = @glGenBuffers
        delFcn = @glDeleteBuffers
    end
    
    properties(Access=private)
        sizeofcache
    end
    
    methods
        
        function id = New(obj,varargin)
            id = obj.Gen(varargin{:});
        end

        function Bind(obj,target,id)
            i = find(target == obj.targets,1);
            if isempty(i)
                i = numel(obj.targets)+1;
                obj.targets(i) = target;
                obj.current(i) = 0;
            end
            if obj.current(i) == id, return, end
            obj.gl.glBindBuffer(target,id);
            obj.current(i) = id;
        end

        function Delete(obj,id)
            obj.DeleteN(id);
        end

        function nbytes = sizeof(obj,type)
            if isempty(obj.sizeofcache)
                C = {
                    'GL_BYTE'           1
                    'GL_SHORT'          2
                    'GL_INT'            4
                    'GL_LONG'           8
                    'GL_UNSIGNED_BYTE'  1
                    'GL_UNSIGNED_SHORT' 2
                    'GL_UNSIGNED_INT'   4
                    'GL_UNSIGNED_LONG'  8
                    'GL_FLOAT'          4
                    'GL_DOUBLE'         8
                    };
                C = cellfun(@(str,v) tryconst(@obj.Const,str,v),C(:,1),C(:,2),'uni',0);
                obj.sizeofcache = vertcat(C{:});
            end
            i = type == obj.sizeofcache(:,1);
            nbytes = obj.sizeofcache(i,2);
        end
    end
end

function val = tryconst(f,c,b)
    try
        val = [f(c) b];
    catch
        val = [];
    end
end

