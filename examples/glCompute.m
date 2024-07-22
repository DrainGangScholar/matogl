classdef glCompute < glmu.GLController
    % work in progress
    %
    % Enables computing on the GPU for simple functions operating on large
    % amount of data.
    %
    % See glComputeUsageExample
    %
    % todo: make easier to use
    properties
        shadersPath
        progs
        groupSz
        stateString
        buffer
    end
    
    methods
        function obj = glCompute(shadersPath)
            obj.shadersPath = shadersPath;

            frame = JFrame('Title','glCompute','Size',[300 100]);
            canvas = GLCanvas(frame,'GL3',4,obj);
            canvas.Init;
            frame.addJEvents('WindowClosing');
            addlistener(frame,'WindowClosing',@(src,evt) delete(obj));
        end

        function InitFcn(obj,gl)
            gl.glClearColor(1,1,1,0);
            obj.stateString = glmu.drawable.Text('glCompute',20,[0 0 0 1]);%,eye(4),MTrans3D([-150 -100 0]));
            % obj.state = glmu.Text('arial','glCompute',20,[0 0 0 1]);
            N = 8;
            obj.buffer = cell(N,1);
            for i=1:N
                obj.buffer{i} = glmu.Buffer([],gl.GL_SHADER_STORAGE_BUFFER);
                obj.buffer{i}.BindBase(i-1);
            end
        end

        function InitCompute(obj,prog,alias,workgroupsize)
            % todo add iBufferIn and iBufferOut arguments to simplify calling
            [gl,temp] = obj.canvas.getContext;
            preproc = sprintf('#define WORKGROUPSIZE %i',workgroupsize);
            obj.progs.(alias) = glmu.Program(fullfile(obj.shadersPath,prog),preproc);
            obj.groupSz.(alias) = workgroupsize;
        end

        function SetConstants(obj,alias,s)
            [gl,temp] = obj.canvas.getContext;
            obj.progs.(alias).SetUniforms(s);
        end

        function SetBuffer(obj,iBuffer,B)
            [gl,temp] = obj.canvas.getContext;
            obj.buffer{iBuffer}.Set(B,gl.GL_DYNAMIC_DRAW);
        end

        function GetBuffer(obj,iBuffer,jb)
            [gl,temp] = obj.canvas.getContext;
            obj.buffer{iBuffer}.Bind;
            b = gl.glMapBuffer(obj.buffer{iBuffer}.target,gl.GL_READ_ONLY);
            jb.p.put(b.(['as' jb.javaType 'Buffer']));
            gl.glUnmapBuffer(obj.buffer{iBuffer}.target);
            jb.p.rewind;
        end

        function Run(obj,alias,nbElems)
            [gl,temp] = obj.canvas.getContext;
            n = ceil(nbElems / obj.groupSz.(alias));
            obj.progs.(alias).Dispatch(n,1,1);
            gl.glMemoryBarrier(bitor(gl.GL_SHADER_STORAGE_BARRIER_BIT,gl.GL_BUFFER_UPDATE_BARRIER_BIT));
        end

        function UpdateFcn(obj,gl)
            gl.glClear(gl.GL_COLOR_BUFFER_BIT);

            obj.stateString.Draw;
        end

        function ResizeFcn(obj,gl,sz)
            gl.glViewport(0,0,sz(1),sz(2));
            obj.stateString.proj = MProj3D('O',[sz -1 1]);
            obj.stateString.model = MTrans3D([-sz(1)./2+5 -10 0]);
        end
        
    end
end

