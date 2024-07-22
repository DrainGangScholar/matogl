classdef JNumericField < JTextField

    properties(Dependent)
        Value (1,1) double {mustBeReal}
    end

    properties(Transient)
        Format char = '%.5g'
        Limits (1,2) double {mustBeReal} = [-inf inf];
        RoundStep (1,1) double {mustBeFinite,mustBeNonnegative} = 0;
    end

    properties(Access=protected)
        lastValue = 0;
        iValue (1,1) double {mustBeReal} = 0;
    end
    
    methods
        function obj = JNumericField(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JTextField(parent);
            obj.rmJEvents('ActionPerformed');
            obj.UpdateFormattedText;
            if numel(varargin)
                set(obj,varargin{:})
            end
            obj.lastValue = obj.iValue;
            obj.addJEvents('ActionPerformed');
        end

        function set.Value(obj,v)
            obj.iValue = obj.ValidValue(v);
            obj.UpdateFormattedText;
            notify(obj,'ActionPerformed');
        end

        function v = get.Value(obj)
            v = obj.iValue;
        end

        function set.Format(obj,f)
            obj.Format = f;
            obj.UpdateFormattedText;
        end

        function set.Limits(obj,L)
            if diff(L) < 0
                error('Invalid limits, must be ascending')
            end
            obj.Limits = L;
            obj.Value = obj.ValidValue(obj.iValue);
            obj.UpdateFormattedText;
        end

        function set.RoundStep(obj,v)
            obj.RoundStep = v;
            obj.Value = obj.ValidValue(obj.iValue);
            obj.UpdateFormattedText;
        end

        function SilentSetValue(obj,v)
            % set value without triggering ActionPerformed
            obj.iValue = v;
            obj.lastValue = v;
            obj.UpdateFormattedText;
        end

        % function MousePressed(obj,src,evt)
        %     obj.x0 = evt.getYOnScreen;
        %     obj.v0 = obj.Value;
        % end
        % 
        % function MouseDragged(obj,src,evt)
        %     if ~bitand(evt.getModifiers,evt.BUTTON3_MASK), return, end
        %     dx = evt.getYOnScreen - obj.x0;
        %     if abs(dx) <= 5, return, end
        %     obj.Value = obj.ValidFcn(obj.v0 - obj.DragFcn(dx));
        %     obj.ActionTrigger(src,evt);
        % end

    end

    methods(Access=protected)

        function FocusLostCallback(obj,src,evt)
            obj.FocusLostCallback@JTextField(src,evt);
            obj.UpdateFormattedText;
        end

        function FocusGainedCallback(obj,src,evt)
            obj.SilentSetText(sprintf('%.12g',obj.iValue));
            obj.FocusGainedCallback@JTextField(src,evt);
        end

        function doCancel = ActionFilter(obj,evt)
            v = obj.iValue;
            doCancel = isequaln(obj.lastValue,v);
            obj.lastValue = v;
        end

        function v = ValidValue(obj,v)
            v = clamp(v,obj.Limits(1),obj.Limits(2));
            if obj.RoundStep
                v = round(v./obj.RoundStep).*obj.RoundStep;
            end
        end

        function UpdateFormattedText(obj)
            % +0 avoids '-0' result when sprintf('%.5g',-0)
            obj.SilentSetText(sprintf(obj.Format,obj.iValue + 0));
        end

        function ActionTrigger(obj,src,evt)
            if isa(evt,'javaevent')
                % from java trigger
                v = sscanf(evt.data,'%f',1);
                if isempty(v), return, end
                v = obj.ValidValue(v);
            else
                % from set(obj,'Value',value)
                v = obj.iValue;
            end
            obj.iValue = v;
            obj.ActionTrigger@JTextField(src,evt)
        end

    end
end
