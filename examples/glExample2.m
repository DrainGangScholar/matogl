classdef glExample2 < GLController
    % Same as glExample1, but using shader rendering pipeline
    
    properties
        prog
        vertexArray
    end
    
    methods
        function obj = glExample2()
            frame = JFrame('Title','HelloTriangle 2');
            canvas = GLCanvas(frame,'GL3',0,obj);
            canvas.Init;
        end
        
        function InitFcn(obj,gl)
            gl.glClearColor(0,0,0,1);
            
            % data
            vertex = single([-0.8 -0.8 0 ; 0.8 -0.8 0 ; 0 0.9 0]);
            color = single([1 0 0 ; 0 1 0 ; 0 0 1]);
            

            % make vertex buffer
            b = javabuffer(0,'int32');
            gl.glGenBuffers(1,b.p);
            vertexBufferName = b.array;

            % set vertex buffer
            gl.glBindBuffer(gl.GL_ARRAY_BUFFER,vertexBufferName);
            b = javabuffer(vertex');
            gl.glBufferData(gl.GL_ARRAY_BUFFER,b.bytePerValue*b.capacity,b.p,gl.GL_STATIC_DRAW);
            

            % make color buffer
            b = javabuffer(0,'int32');
            gl.glGenBuffers(1,b.p);
            colorBufferName = b.array;

            % set color buffer
            gl.glBindBuffer(gl.GL_ARRAY_BUFFER,colorBufferName);
            b = javabuffer(color');
            gl.glBufferData(gl.GL_ARRAY_BUFFER,b.bytePerValue*b.capacity,b.p,gl.GL_STATIC_DRAW);
            

            % make vertex array
            b = javabuffer(0,'int32');
            gl.glGenVertexArrays(1,b.p);
            obj.vertexArray = b.array;
            gl.glBindVertexArray(obj.vertexArray);

            % set vertex buffer pointer
            gl.glBindBuffer(gl.GL_ARRAY_BUFFER,vertexBufferName)
            gl.glVertexAttribPointer(0,3,gl.GL_FLOAT,gl.GL_FALSE,0,0);
            gl.glEnableVertexAttribArray(0);
            
            % set color buffer pointer
            gl.glBindBuffer(gl.GL_ARRAY_BUFFER,colorBufferName)
            gl.glVertexAttribPointer(1,3,gl.GL_FLOAT,gl.GL_FALSE,0,0);
            gl.glEnableVertexAttribArray(1);
            

            % create shader program
            shaderDir = fullfile(fileparts(mfilename('fullpath')),'shaders');
            obj.prog = gl.glCreateProgram();
            
            % compile and attach vertex shader
            vertShader = gl.glCreateShader(gl.GL_VERTEX_SHADER);
            vertSource = fileread(fullfile(shaderDir,'example1.vert.glsl'));
            gl.glShaderSource(vertShader,1,vertSource,[]);
            gl.glCompileShader(vertShader);
            gl.glAttachShader(obj.prog,vertShader);
            
            % compile and attach fragment shader
            fragShader = gl.glCreateShader(gl.GL_FRAGMENT_SHADER);
            fragSource = fileread(fullfile(shaderDir,'example1.frag.glsl'));
            gl.glShaderSource(fragShader,1,fragSource,[]);
            gl.glCompileShader(fragShader);
            gl.glAttachShader(obj.prog,fragShader);
            
            % link program
            gl.glLinkProgram(obj.prog);
            
        end

        function UpdateFcn(obj,gl)
            gl.glClear(gl.GL_COLOR_BUFFER_BIT);
            
            % prepare to draw with shader and vertex array
            gl.glUseProgram(obj.prog);
            gl.glBindVertexArray(obj.vertexArray);
            
            % draw
            gl.glDrawArrays(gl.GL_TRIANGLES,0,3);
            
        end
        
    end
end

