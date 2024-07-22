classdef ArrayPointer < glmu.Array
    
    properties
        attrib
        iattrib
    end
    
    methods
        function obj = ArrayPointer(vattribs,varargin)
            % optional buffer = glmu.Buffer | buffer data
            % optional normalized = normalize flags for each
            if ~nargin, return, end
            if isa(vattribs,'glmu.ArrayPointer'), obj = vattribs; return, end
            if ~iscell(vattribs), vattribs = {vattribs}; end

            tf = ~cellfun(@(x) isa(x,'glmu.VertexAttrib'),vattribs);
            vattribs(tf) = glmu.VertexAttrib.FromData(vattribs(tf));
            obj.Set(vattribs,varargin{:});
        end

        function Set(obj,vattribs,iattribs)
            if nargin < 3, iattribs = 0:numel(vattribs)-1; end
            obj.Bind;
            for i=1:numel(vattribs)
                va = vattribs{i};
                a = iattribs(i);
                va.buffer.Bind(obj.gl.GL_ARRAY_BUFFER);
                switch va.glslType
                    case 'float'
                        obj.gl.glVertexAttribPointer(a,va.nbDims,va.type,obj.gl.GL_FALSE,0,va.offset);
                    case 'normalized'
                        obj.gl.glVertexAttribPointer(a,va.nbDims,va.type,obj.gl.GL_TRUE,0,va.offset);
                    case 'integer'
                        obj.gl.glVertexAttribIPointer(a,va.nbDims,va.type,0,va.offset);
                    case 'double'
                        obj.gl.glVertexAttribLPointer(a,va.nbDims,va.type,0,va.offset);
                    otherwise
                        error('invalid glslType')
                end
                obj.gl.glEnableVertexAttribArray(a);
            end
            obj.attrib = vattribs;
            obj.iattrib = iattribs;
        end

    end
end

