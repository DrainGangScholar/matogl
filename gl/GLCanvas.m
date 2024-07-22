classdef GLCanvas < JComponent

    properties(Constant)
        isEDT = false
        JClass = 'com.jogamp.opengl.awt.GLCanvas'
    end

    properties
        autoSwapBuffer logical = 1
        glStop logical = 0;
        autoCheckError logical = 1;
        updateNeeded logical = 0;
        resizeNeeded logical = 1;
        updating logical = 0;

        UpdateFcn = @(gl) []
        ResizeFcn = @(gl,sz) []
        InitFcn = @(gl,varargin) []

        isInit logical = 0;
        contextLocks = 0;
    end

    properties(Access=private)
        context
    end

    methods
        % function obj = GLCanvas(glProfile,nbSamples,controller)
        function obj = GLCanvas(varargin)
            [parent,varargin] = jparse(varargin{:});

            p = inputParser;
            p.addRequired('glProfile',@mustBeTextScalar);
            p.addOptional('nbSamples',0);
            p.addOptional('controller',[]);
            p.KeepUnmatched = true;
            p.parse(varargin{:});

            gp = com.jogamp.opengl.GLProfile.get(p.Results.glProfile);
            cap = com.jogamp.opengl.GLCapabilities(gp);
            nbSamples = p.Results.nbSamples;
            if nbSamples > 1
                cap.setSampleBuffers(1);
                cap.setNumSamples(nbSamples);
            end
            obj@JComponent(cap);
            obj.java.setAutoSwapBufferMode(false);
            obj.addJEvents('ComponentResized');
            addlistener(obj,'ComponentResized',@obj.CanvasResized);

            controller = p.Results.controller;
            if ~isempty(controller)
                controller.setGLCanvas(obj)
            end

            parent.add(obj);

            set(obj,p.Unmatched)
        end

        function Init(obj,varargin)
            F = obj.java.getParent.getTopLevelAncestor;
            F.revalidate;
            F.repaint;
            obj.java.display;
            obj.context = obj.java.getContext;
            [gl,temp] = obj.getContext;

            obj.InitFcn(gl,varargin{:});
            obj.isInit = 1;
            obj.Update;
        end

        function [gl,temp] = getContext(obj)
            % always request temp. This ensures that the context is
            % released when temp is cleared.
%             obj.context = obj.java.getContext;
            if ~obj.context.isCurrent
                obj.context.makeCurrent;
            end
            temp = onCleanup(@() obj.releaseContext);
            obj.contextLocks = obj.contextLocks+1;

            gl = obj.context.getCurrentGL;
        end

        function releaseContext(obj)
            if ~isvalid(obj), return, end
            obj.contextLocks = obj.contextLocks - 1;
            if obj.contextLocks <= 0 && obj.context.isCurrent
                obj.context.release;
            end
        end

        function glDrawnow(obj)
            % necessary if a callback needs to make another context current
            isCur = obj.context.isCurrent;
            if isCur
                obj.context.release;
            end
            drawnow
            if obj.glStop
                return
            end
            % continue with our context
            if isCur
                obj.context.makeCurrent;
            end
%             gl = obj.context.getCurrentGL;
        end

        function Update(obj)
            % Java events (like mouse drag) can happen so quickly that the
            % update rate doesn't follow. This strategy skips updates that
            % happen before a previous update had time to finish while
            % ensuring that the last update requested is always run.

            obj.updateNeeded = 1;
            if obj.updating || obj.glStop || ~obj.isInit
                return
            end
            obj.updating = 1; temp1 = onCleanup(@() obj.EndUpdate);
            [gl,temp2] = getContext(obj); %#ok<ASGLU> temp2 is onCleanup()
            j = 0;
            while obj.updateNeeded
%                 obj.state.CleanUp;
                if obj.resizeNeeded
                    obj.resizeNeeded = 0;
                    obj.ResizeFcn(gl,obj.Size);
                end
                obj.updateNeeded = 0;
                obj.UpdateFcn(gl);
                if obj.autoSwapBuffer
                    obj.context.getGLDrawable.swapBuffers;
                end

                if j < 1
                    drawnow
                end
                j=j+1;
                % j
                % obj.glDrawnow;
                % pause(0.001);
                if obj.glStop, return, end
            end
            if obj.autoCheckError, obj.CheckError(gl); end
        end

        function EndUpdate(obj)
            if ~isvalid(obj), return, end
            obj.updating = 0;
        end

        function CanvasResized(obj,~,~)
            obj.resizeNeeded = 1;
            obj.Update;
        end

        function delete(obj)
            if ~isempty(obj.context) && obj.context.isCurrent
                obj.context.release;
            end
            obj.UpdateFcn = @(gl) [];
            obj.ResizeFcn = @(gl,sz) [];
            obj.InitFcn = @(gl,varargin) [];
        end
    end

    methods(Static)
        function CheckError(gl)
            err = gl.glGetError();
            while err > 0
                softwarn(['GL Error 0x' dec2hex(err,4)])
                err = gl.glGetError();
            end
        end
    end
end

