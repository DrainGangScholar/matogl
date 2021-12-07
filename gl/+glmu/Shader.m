classdef Shader < glmu.internal.Object
    
    properties
        type
        src = ''
    end
    
    methods
        function obj = Shader(type,source,varargin)
            obj.type = obj.Const(type);
            obj.id = obj.state.shader.New(obj.type);
            
            if nargin > 1
                obj.Source(source,varargin{:});
                obj.Compile();
            end
        end

        function Source(obj,source,preproc)
            if nargin > 2
                k = find(source==newline,1);
                source = insertAfter(source,k,[preproc newline]);
            end
            obj.src = source;
            obj.gl.glShaderSource(obj.id,1,source,[]);
        end

        function [v,b] = Get(obj,name)
            b = javabuffer(int32(0));
            obj.gl.glGetShaderiv(obj.id,obj.Const(name),b);
            v = b.array;
        end

        function str = InfoLog(obj)
            [n,b] = obj.Get(obj.gl.GL_INFO_LOG_LENGTH);
            strb = javabuffer(zeros(n,1,'uint8'));
            obj.gl.glGetShaderInfoLog(obj.id,n,b,strb);
            str = char(strb.array');
        end

        function Compile(obj)
            obj.gl.glCompileShader(obj.id);
            
            if ~obj.Get(obj.gl.GL_COMPILE_STATUS)
                log = obj.InfoLog();
                ME = MException('GL:SHADER:CompileFailed',log);
                throw(ME);
            end
        end

        function [uniName,type] = GetUniforms(obj)
            str = regexp(obj.src,'uniform\s+\w+.*?\s+\w+.*?;','match')';
            str = cellfun(@(c) c(1:end-1),str,'uni',0);
            str = regexprep(str,'\[.*?\]','');
            str = regexprep(str,'=.*','');
            str = cellfun(@strsplit,str,'uni',0);
            str = str(~cellfun(@isempty,str));
            str = cellfun(@(c) c(2:3),str,'uni',0);
            str = vertcat(str{:});
            if isempty(str)
                type = {};
                uniName = {};
            else
                type = str(:,1);
                uniName = str(:,2);
            end
        end
    end
end

