classdef VertexAttrib < glmu.internal.Base
    
    properties
        buffer
        offset

        nbytes

        nbDims
        nbVertex
        type

        glslType; % 'float' / normalized / integer / double

    end
    
    methods
        function obj = VertexAttrib(buffer,offset,type,nbDims,nbVertex,glslType)
            if isa(buffer,'glmu.VertexAttrib'), obj = buffer; return, end
            if nargin < 6, glslType = 'float'; end

            obj.buffer = buffer;
            obj.offset = offset;
            obj.type = obj.Const(type);
            obj.nbDims = nbDims;
            obj.nbVertex = nbVertex;
            obj.glslType = glslType;

            bytePerValue = obj.buffer.state.buffer.sizeof(obj.type);
            obj.nbytes = bytePerValue * obj.nbDims * obj.nbVertex;

        end

        function out = Get(obj)
            b = javabuffer(zeros(obj.nbDims,obj.nbVertex,0,'uint8'));
            out = obj.buffer.Get(b);
        end

    end

    methods(Static)
        function obj = FromData(data,target,usage,glslType)
            if nargin < 2, target = 'GL_ARRAY_BUFFER'; end
            if nargin < 3, usage = 'GL_STATIC_DRAW'; end
            if nargin < 4, glslType = 'float'; end
            if iscell(data)
                n = numel(data);
                target = cellexpand(target,n);
                usage = cellexpand(usage,n);
                glslType = cellexpand(glslType,n);
                obj = cellfun(@glmu.VertexAttrib.FromData,data(:),target(:),usage(:),glslType(:),'uni',0)';
                return
            end
            data = javabuffer(data);
            buffer = glmu.Buffer(data,target,usage);
            utypes = {'','UNSIGNED_'};
            type = ['GL_' utypes{startsWith(data.matType,'u')+1} upper(data.javaType)];
            obj = glmu.VertexAttrib(buffer,0,type,data.sz(1),data.sz(2),glslType);
        end
        
    end
end

function x = cellexpand(x,n)
    if ~iscell(x)
        if ischar(x)
            x = {x};
        else
            x = num2cell(x);
        end
    end
    if isscalar(x)
        x = repmat(x,n,1);
    end
end

