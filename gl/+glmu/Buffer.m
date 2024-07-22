classdef Buffer < glmu.internal.Object
    
    properties
        target
        nbytes
        % sz
        % type
        usage
        % bytePerVertex
        % bytePerValue
    end
    
    methods
        function obj = Buffer(data,target,varargin)
            if isa(data,'glmu.Buffer'), obj = data; return, end
            if nargin < 2, target = obj.gl.GL_ARRAY_BUFFER; end
            obj.target = obj.Const(target);
            obj.id = obj.state.buffer.New(1);
            obj.Set(data,varargin{:});
        end

        function Bind(obj,target)
            if nargin < 2, target = obj.target; end
            obj.state.buffer.Bind(target,obj.id);
        end

        function Set(obj,data,usage)
            % data = data | {data data}
            %   [m x n] where m is the number of elements per vertex and n is the number of vertices
            %   if data is [], the buffer is not set. {[] data} only sets the second buffer
            % optional usage = GL usage, default GL_STATIC_DRAW

            if isempty(data),return,end

            if nargin < 3, usage = obj.gl.GL_STATIC_DRAW; end
            usage = obj.Const(usage);
            % utypes = {'','UNSIGNED_'};
            obj.Bind;
            data = javabuffer(data);
            % if ~isa(data,'javabuffer')
                % data = javabuffer(data);
            % end
            % obj.bytePerValue = data.bytePerValue;
            % szb = obj.bytePerValue*data.capacity;
            obj.nbytes = data.nbytes;
            obj.usage = usage;

            obj.gl.glBufferData(obj.target,obj.nbytes,data.p,obj.usage);
            % obj.sz = data.sz;
            % obj.type = obj.Const(['GL_' utypes{startsWith(data.matType,'u')+1} upper(data.javaType)]);
            
            % obj.bytePerVertex = obj.bytePerValue*obj.sz(1);
        end

        function SubSet(obj,data,bytesOffset)
            obj.Bind;
            data = javabuffer(data);
            obj.gl.glBufferSubData(obj.target,bytesOffset,data.nbytes,data.p);
        end

        function out = Get(obj,sz,byteOffset,mattype)
            if nargin < 2, sz = obj.nbytes; end
            if nargin < 3, byteOffset = 0; end
            if nargin < 4, mattype = 'uint8'; end
            if isa(sz,'javabuffer')
                b = sz;
            else
                b = javabuffer(zeros([sz 0],mattype));
            end
            d = java.nio.DirectByteBuffer.allocateDirect(b.nbytes);
            obj.Bind;
            obj.gl.glGetBufferSubData(obj.target,byteOffset,obj.nbytes,d);

            b.p.put(d);
            if nargout
                out = b.array;
            end
        end

        function BindBase(obj,ibase,varargin)
            obj.Bind(varargin{:});
            obj.gl.glBindBufferBase(obj.target,ibase,obj.id);
        end

        function delete(obj)
            obj.state.buffer.DelayedDelete(obj.id);
        end
        
    end

end

