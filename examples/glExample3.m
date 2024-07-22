classdef glExample3 < glmu.GLController
    % Same as glExample2, but using glmu to simplify objects creation and management
    % now using glmu.GLController instead of GLController
    
    properties
        myVertexArray
        myProgram
    end
    
    methods
        function obj = glExample3()
            frame = JFrame('Title','HelloTriangle 3');
            canvas = GLCanvas(frame,'GL3',0,obj);
            canvas.Init;
        end
        
        function InitFcn(obj,gl)
            gl.glClearColor(0,0,0,1);
            
            % data
            vertex = single([-0.8 -0.8 0 ; 0.8 -0.8 0 ; 0 0.9 0]);
            color = single([1 0 0 ; 0 1 0 ; 0 0 1]);

            B1 = glmu.Buffer(vertex',gl.GL_ARRAY_BUFFER);
            B2 = glmu.Buffer(color',gl.GL_ARRAY_BUFFER);

            A1 = glmu.VertexAttrib(B1,0,gl.GL_FLOAT,3,3);
            A2 = glmu.VertexAttrib(B2,0,gl.GL_FLOAT,3,3);
            obj.myVertexArray = glmu.ArrayPointer({A1 A2});
            
            shaderDir = fullfile(fileparts(mfilename('fullpath')),'shaders');

            vertSource = fileread(fullfile(shaderDir,'example1.vert.glsl'));
            vertShader = glmu.Shader(gl.GL_VERTEX_SHADER,vertSource);
            
            fragSource = fileread(fullfile(shaderDir,'example1.frag.glsl'));
            fragShader = glmu.Shader(gl.GL_FRAGMENT_SHADER,fragSource);
            
            obj.myProgram = glmu.Program({vertShader fragShader});
        end
        
        function UpdateFcn(obj,gl)
            gl.glClear(gl.GL_COLOR_BUFFER_BIT);
            
            obj.myVertexArray.Bind;
            obj.myProgram.Use;
            gl.glDrawArrays(gl.GL_TRIANGLES,0,3);
        end

    end
end

