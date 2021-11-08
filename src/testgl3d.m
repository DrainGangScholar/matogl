classdef testgl3d < glCanvas
    
    properties
        cam single = [-45 0 -135 0 0 -3]; % [rotation translation]
        click struct = struct('ij',[0 0],'cam',[0 0 0 0 0 0],'button',0);
        sz single = [500 450];
        shaders
        origin
        img
        text
        text2
    end
    
    methods
        function obj = testgl3d()
            % create java frame
            frame = jFrame('testgl3d',obj.sz);
            
            obj.shaders = glShaders(fullfile(fileparts(mfilename('fullpath')),'shaders'));
            
            % Initialize opengl in frame using GL4 profile
            obj.Init(frame,'GL4',4);
            
            % activate callbacks
            obj.setMethodCallback('MousePressed');
            obj.setMethodCallback('MouseDragged');
            obj.setMethodCallback('MouseWheelMoved');
            obj.setCallback('ComponentResized',@(src,evt) obj.glFcn(@obj.glResize));
        end
        
        function InitFcn(obj,d,gl)
            % make axes element
            
            a = eye(4,3,'single');
            xyz = a([4 1 4 2 4 3],:)';
            color = a([1 1 2 2 3 3],:)';
            obj.origin = glElement(gl,{xyz,color},'default3',obj.shaders,gl.GL_LINES);
            im = imread('peppers.png');
            ijNorm = single([0 0;1 0;0 1;1 1]');
            pos = ijNorm./1.5+0.1;
            obj.img = glElement(gl,{pos,ijNorm},'image',obj.shaders,gl.GL_TRIANGLE_STRIP);
            obj.img.AddTexture(gl,0,gl.GL_TEXTURE_2D,im,gl.GL_RGB);
            
            obj.text = glText(gl,obj.shaders);
            obj.text2 = glText(gl,obj.shaders);
            gl.glEnable(gl.GL_DEPTH_TEST);
            gl.glLineWidth(1.5);
            gl.glClearColor(0,0,0,0);
            
            obj.glResize(d,gl);
        end
        
        function UpdateFcn(obj,d,gl)
            % d is the GLDrawable
            % gl is the GL object
            
            % clear color and depth
            gl.glClear(glFlags(gl,'GL_COLOR_BUFFER_BIT','GL_DEPTH_BUFFER_BIT'));
            
            % make the view transform matrix and set it in the shader
            m = MTransform('T',obj.cam(4:6))*MTransform('RR',obj.cam(1:3),1);
            
            obj.shaders.SetMat4(gl,'default3','view',m);
            
            obj.img.Draw(gl);
            obj.origin.Draw(gl);
            
            transfText =  MTransform('T',[0.9 0 0.8]) * MTransform('R',[90 0 180],1) ;
            obj.text.Render(gl,'Arial','perspective',0.1,[1 1 0 1],m * transfText);
            
            transfText =  MTransform('T',[0.9 0 0.5]) * MTransform('R',-obj.cam(1:3),1);
            obj.text.Render(gl,'Arial','normal',0.1,[1 1 0 1],m * transfText);
            
            transfText =  MTransform('T',single([10 10 0]));
            obj.text2.Render(gl,'Arial','ortho',18,[1 1 0 1],transfText);
            
            
            % update display
            d.swapBuffers;
        end
        
        function MousePressed(obj,~,evt)
            % record the screen coordinates, camera and button when click happened
            obj.click.ij = [evt.getX evt.getY];
            obj.click.cam = obj.cam;
            obj.click.button = evt.getButton;
        end
        
        function MouseDragged(obj,~,evt)
            % delta from when the mouse was pressed
            dij = [evt.getX evt.getY] - obj.click.ij;
            c = obj.click.cam;
            switch obj.click.button
                case 1
                    % left click: rotate
                    obj.cam([3 1]) = c([3 1])+dij/5;
                case 2
                    % middle click: pan
                    obj.cam([4 5]) = c([4 5])+dij.*[-1 1]./mean(obj.sz).*c(6);
                otherwise
                    return
            end
            obj.Update; % shortcut for obj.glFcn(@obj.Update)
        end
        
        function MouseWheelMoved(obj,~,evt)
            % scroll wheel: zoom
            z = evt.getUnitsToScroll / 50;
            obj.cam(4:6) = obj.cam(4:6)+obj.cam(4:6).*z;
            obj.Update; % shortcut for obj.glFcn(@obj.Update)
        end
        
        function glResize(obj,d,gl)
            % new canvas size
            newSz = [obj.gc.getWidth,obj.gc.getHeight];
            obj.sz = newSz;
            
            % keep the gl view fullscreen
            gl.glViewport(0,0,newSz(1),newSz(2));
            
            % Update the projection matrix
            m = MTransform('PA',[newSz(1)/newSz(2) 45 0.1 200],1);
            obj.shaders.SetMat4(gl,'default3','projection',single(m));
            obj.text.Reshape(obj.sz,0.1,200,45);
            obj.text2.Reshape(obj.sz,0,1);
            
            % using UpdateFcn instead of Update since we already have d and gl
            obj.UpdateFcn(d,gl); 
        end
        
        
    end
end

