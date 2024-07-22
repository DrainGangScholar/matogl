classdef JTextField < JComponent & JSetGetText & JActionnable
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JTextField'
    end

    properties(Transient)
        SelectOnFocus (1,1) logical = false
    end

    properties(Dependent)
        Editable (1,1) logical
    end

    properties(Access=protected)
        lastText char = ''
    end
    
    methods
        function obj = JTextField(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename);
            obj@JActionnable();
            obj.rmJEvents('ActionPerformed');
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end

            obj.lastText = obj.Text;
            addlistener(obj,'Text','PostSet',@(src,evt) notify(obj,'ActionPerformed',evt));

            obj.addJEvents({'FocusLost','FocusGained'});
            addlistener(obj,'FocusGained',@obj.FocusGainedCallback);
            addlistener(obj,'FocusLost',@obj.FocusLostCallback);
            obj.addJEvents('ActionPerformed');
        end

        function SilentSetText(obj,str)
            % set value without triggering ActionPerformed
            if strcmp(str,obj.lastText), return, end
            obj.java.setText(str);
            obj.lastText = str;
        end

        function set.Editable(obj,tf)
            obj.java.setEditable(tf);
        end

        function tf = get.Editable(obj)
            tf = obj.java.getEditable;
        end

    end

    methods(Access=protected)

        function data = ActionData(obj)
            data = obj.Text;
        end

        function doCancel = ActionFilter(obj,evt)
            t = obj.Text;
            doCancel = strcmp(obj.lastText,t);
            obj.lastText = t;
        end

        function FocusGainedCallback(obj,src,evt)
            if obj.SelectOnFocus
                obj.java.select(0,numel(obj.Text));
            end
        end

        function FocusLostCallback(obj,src,evt)
            notify(obj,'ActionPerformed',evt);
        end

    end
end

