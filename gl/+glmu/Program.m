classdef Program < glmu.internal.Object
    
    properties
        shaders
        uniforms = struct;
        subResourcesDir = 'shaders'
        shaderTypes = { %type, gl_type
                        'vert' 'GL_VERTEX_SHADER'
                        'tesc' 'GL_TESS_CONTROL_SHADER'
                        'tese' 'GL_TESS_EVALUATION_SHADER'
                        'geom' 'GL_GEOMETRY_SHADER'
                        'frag' 'GL_FRAGMENT_SHADER'
                        'comp' 'GL_COMPUTE_SHADER'                        
                        };
    end
    
    methods
        function obj = Program(shaders,autoCacheUniforms,varargin)
            cacheProg = '';
            if ischar(shaders)
                cacheProg = shaders;
                [P,name] = obj.state.program.GetCache(cacheProg);
                if ~isempty(P)
                    obj = P;
                    return
                else
                    shaders = obj.GetShaders(name,varargin{:});
                end                
            end
            obj.id = obj.state.program.New();
            if nargin > 0
                if nargin < 2, autoCacheUniforms = 1; end
                obj.Attach(shaders);
                obj.Link();
                obj.AutoCacheUniforms(autoCacheUniforms)
                obj.state.program.SetCache(cacheProg,obj)
            end
        end

        function shaders = GetShaders(obj,name,varargin)
            d = fullfile(obj.state.resourcesPath,obj.subResourcesDir);
            [fl,dl] = filelist(d,[name '.*.glsl']);
            types = extractBetween(fl,'.','.');
            gltypes = replace(types,obj.shaderTypes(:,1),obj.shaderTypes(:,2));
            ns = numel(gltypes);
            shaders = cell(1,ns);
            for i=1:ns
                src = fileread(fullfile(dl{i},fl{i}));
                shaders{i} = glmu.Shader(gltypes{i},src,varargin{:});
            end
        end
        
        function Attach(obj,shaders)
            for i=1:numel(shaders)
                obj.gl.glAttachShader(obj.id,shaders{i}.id);
            end
            obj.shaders = shaders(:);
        end

%         function Detach(obj,gl,shaders)
%             for i=1:numel(shaders)
%                 gl.glDetachShader(obj.id,shaders{i}.id);
%             end
%         end

        function [v,b] = Get(obj,name)
            b = javabuffer(int32(0));
            obj.gl.glGetProgramiv(obj.id,obj.Const(name,1),b);
            v = b.array;
        end

        function str = InfoLog(obj)
            [n,b] = obj.Get(obj.gl.GL_INFO_LOG_LENGTH);
            strb = javabuffer(zeros(n,1,'uint8'));
            obj.gl.glGetProgramInfoLog(obj.id,n,b,strb);
            str = char(strb.array');
        end

        function Link(obj)
            obj.gl.glLinkProgram(obj.id);
            if ~obj.Get(obj.gl.GL_LINK_STATUS)
                log = obj.InfoLog;
                ME = MException('GL:PROGRAM:LinkFailed',log);
                throw(ME);
            end
        end

        function Use(obj)
            obj.state.program.Use(obj.id);
        end

        function AutoCacheUniforms(obj,action)
            if nargin < 2, action = 1; end
            if ~action, return, end
            [uniName,type] = cellfun(@(c) c.GetUniforms,obj.shaders,'uni',0);
            uniName = vertcat(uniName{:});
            type = vertcat(type{:});
            [uniName,iu] = unique(uniName);
            type = type(iu);
            for i = 1:numel(uniName)
                try
                    obj.CacheUniform(uniName{i},type{i});
                catch
                    if action == 1
                        softwarn(['Error caching uniform ''' uniName{i} ''' of type ''' type{i} '''']);
                    end
                end
            end

        end

        function CacheUniform(obj,name,varargin)
            obj.uniforms.(name) = glmu.Uniform(obj,name,varargin{:});
        end

        function SetUniform(obj,name,value)
            obj.uniforms.(name).Set(value);
        end

        function SetUniforms(obj,uni)
            fn = fieldnames(uni);
            for i=1:numel(fn)
                obj.uniforms.(fn{i}).Set(uni.(fn{i}));
            end
        end

    end
end

