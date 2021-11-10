classdef SimpleTriangle < glCanvas
    
    properties
        title = 'SimpleTriangle';
    end
    
    methods
        function obj = SimpleTriangle()
            frame = jFrame(obj.title,[600 450]);
            obj.Init(frame,'GL2');
            obj.setMethodCallback('ComponentResized');
        end
        
        function InitFcn(obj,d,gl)
            gl.glClearColor(0,0,0,1);
            obj.UpdateFcn(d,gl);
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

        function ComponentResized(obj,src,evt)
            [d,gl,temp] = obj.getContext;
            gl.glViewport(0,0,src.getWidth,src.getHeight);
            obj.UpdateFcn(d,gl);
        end
    end
end

