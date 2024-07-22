classdef JMouseEvents < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % parent
        clickTolerance = 1;
    end

    events
        Pressed
        Released
        Clicked
        Dragged
        WheelMoved
        Moved
    end

    properties(Access=protected)
        mousePressOrigin = nan(3,2);
        btnMask
        jmels
    end
    
    methods
        function obj = JMouseEvents(parent)
            % obj.parent = parent;
            parent.addJEvents({'MousePressed','MouseReleased','MouseDragged','MouseWheelMoved','MouseMoved'});
            
            addlistener(parent,'MousePressed',@obj.MousePressedCallback);
            addlistener(parent,'MouseReleased',@obj.MouseReleasedCallback);
            addlistener(parent,'MouseDragged',@obj.MouseDraggedCallback);
            addlistener(parent,'MouseWheelMoved',@obj.MouseWheelMovedCallback);
            addlistener(parent,'MouseMoved',@obj.MouseMovedCallback);

            % obj.jmels = [
            % skippablelistener(parent,'MousePressed',@obj.MousePressedCallback);
            % skippablelistener(parent,'MouseReleased',@obj.MouseReleasedCallback);
            % skippablelistener(parent,'MouseDragged',@obj.MouseDraggedCallback);
            % skippablelistener(parent,'MouseWheelMoved',@obj.MouseWheelMovedCallback);
            % skippablelistener(parent,'MouseMoved',@obj.MouseMovedCallback)];
        end

        function MousePressedCallback(obj,src,evt)
            b = evt.java.getButton;
            obj.mousePressOrigin(b,:) = jevt2coords(evt,1);
            notify(obj,'Pressed',evt);
        end

        function MouseReleasedCallback(obj,src,evt)
            b = evt.java.getButton;
            data.dxy = jevt2coords(evt,1) - obj.mousePressOrigin(b,:);
            obj.mousePressOrigin(b,:) = [nan nan];
            notify(obj,'Released',javaevent(evt,data));
            if all(abs(data.dxy) <= obj.clickTolerance)
                notify(obj,'Clicked',evt);
            end
        end

        function MouseDraggedCallback(obj,src,evt)
            evt.data.buttonMask = obj.getButtonMask(evt);
            evt.data.dxy = jevt2coords(evt,1) - obj.mousePressOrigin;
            notify(obj,'Dragged',evt);
        end

        function MouseWheelMovedCallback(obj,src,evt)
            notify(obj,'WheelMoved',evt);
        end

        function MouseMovedCallback(obj,src,evt)
            notify(obj,'Moved',evt);
        end
    end
    methods(Access=protected)
        function msk = getButtonMask(obj,evt)
            j = evt.java;
            if isempty(obj.btnMask)
                obj.btnMask = [j.BUTTON1_DOWN_MASK j.BUTTON2_DOWN_MASK j.BUTTON3_DOWN_MASK]';
            end
            msk = logical(bitand(obj.btnMask,j.getModifiersEx));
        end
    end
end

