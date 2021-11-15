classdef SimpleTriangle < glCanvas
    % simplest opengl triangle drawing example
    
    properties
        
    end
    
    methods
        function obj = SimpleTriangle()
            frame = jFrame('SimpleTriangle',[600 450]);
            obj.Init(frame,'GL2');
        end
        
        function InitFcn(obj,d,gl)
            gl.glClearColor(0,0,0,1);
        end

        function UpdateFcn(obj,d,gl)
            gl.glClear( gl.GL_COLOR_BUFFER_BIT );

            gl.glBegin(gl.GL_TRIANGLES);
            gl.glColor3f( 1, 0, 0 );
            gl.glVertex2f( -0.8, -0.8 );
            gl.glColor3f( 0, 1, 0 );
            gl.glVertex2f( 0.8, -0.8 );
            gl.glColor3f( 0, 0, 1 );
            gl.glVertex2f( 0, 0.9 );
            gl.glEnd();

            d.swapBuffers;
        end

        function ResizeFcn(obj,d,gl)
            gl.glViewport(0,0,obj.gc.getWidth,obj.gc.getHeight);
        end
    end
end

