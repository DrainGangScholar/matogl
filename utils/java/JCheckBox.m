classdef JCheckBox < JComponent & JSetGetText & JActionnable
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JCheckBox'
    end

    
    properties(Dependent)
        Value (1,1) logical
    end

    properties(Access=private)
        lastValue = false
    end
    
    methods
        function obj = JCheckBox(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename,false);
            obj@JActionnable();
            obj.rmJEvents('ActionPerformed');
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
            obj.lastValue = obj.Value;
            obj.addJEvents('ActionPerformed');
        end

        function tf = get.Value(obj)
            tf = obj.java.isSelected;
        end

        function set.Value(obj,tf)
            obj.java.setSelected(tf);
            notify(obj,'ActionPerformed');
        end

        function SilentSetValue(obj,tf)
            obj.lastValue = tf;
            obj.java.setSelected(tf);
        end
    end

    methods(Access=protected)

        function doCancel = ActionFilter(obj,evt)
            tf = obj.Value;
            doCancel = isequaln(obj.lastValue,tf);
            obj.lastValue = tf;
        end

    end
end

