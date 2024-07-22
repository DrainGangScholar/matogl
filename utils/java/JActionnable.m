classdef JActionnable < javacallbackmanager
    
    properties
        ActionFcn
    end

    events
        ActionPerformed
    end

    properties(Access=private)
        actel
    end
    
    methods
        function obj = JActionnable(Jevt_action)
            if nargin < 1, Jevt_action = 'ActionPerformed'; end
            obj.addJEvents(Jevt_action);
            % addlistener(obj,Jevt_action,@(src,evt) obj.ActionTrigger(src,obj.ActionEvent(evt)));
            obj.actel = skippablelistener(obj,Jevt_action,@(src,evt) obj.ActionTrigger(src,obj.ActionEvent(evt)));
        end

    end

    methods(Access=protected)

        function evt = ActionEvent(obj,evt)
            if isa(evt,'javaevent')
                evt = javaevent(evt.java,obj.ActionData);
            end
        end

        function data = ActionData(obj)
            data = [];
        end

        function ActionTrigger(obj,src,evt)
            if isempty(obj.ActionFcn) || obj.ActionFilter(evt), return, end
            obj.ActionFcn(src,evt);
        end

        function doCancel = ActionFilter(obj,evt)
            % overload if canceling is necessary in case of multiple
            % triggers or bad value
            doCancel = false;
        end

    end
end

