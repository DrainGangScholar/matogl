classdef JComboBox < JComponent & JActionnable
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JComboBox'
    end

    properties(Transient)
        Value char
        ValueData
        Items = {}
        ItemsData = {}
    end

    properties(Access = protected)
        lastSelected = '';
    end

    methods
        function obj = JComboBox(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent();
            obj@JActionnable();
            obj.rmJEvents('ActionPerformed');
            parent.add(obj);
            obj.java.setSelectedItem(' ');
            if numel(varargin)
                set(obj,varargin{:})
            end
            obj.addJEvents('ActionPerformed');
        end

        function x = get.Value(obj)
            x = obj.java.getSelectedItem;
        end

        function set.Value(obj,x)
            if ~ismember(x,obj.Items)
                error('Invalid choice')
            end
            obj.java.setSelectedItem(x);
        end

        function x = get.ValueData(obj)
            x = obj.Value;
            if ~isempty(obj.ItemsData)
                x = obj.ItemsData{strcmp(obj.Items,x)};
            end
        end

        function set.ValueData(obj,x)
            if ~isempty(obj.ItemsData)
                tf = cellfun(@(y) isequaln(x,y),obj.ItemsData);
                if ~any(tf)
                    error('Invalid ValueData')
                end
                x = obj.Items{find(tf,1)};
            end
            obj.Value = x;
        end

        function SilentSetValue(obj,v)
            try
                obj.lastSelected = v;
                obj.Value = v;
            catch ME
                warning(ME.message);
                obj.lastSelected = obj.Value;
            end
        end

        function set.Items(obj,x)
            if numel(unique(x)) ~= numel(x)
                error('Items must be unique');
            end
            x = cellstr(x(:));
            prevSelected = obj.Value;
            obj.java.removeAllItems;
            for i=1:numel(x)
                obj.java.addItem(x{i});
            end
            obj.Items = x;
            if isempty(prevSelected) && ~isempty(x)
                prevSelected = x{1};
            end
            obj.java.setSelectedItem(prevSelected);
        end

        % function

    end

    methods(Access=protected)
        function doCancel = ActionFilter(obj,evt)
            x = obj.Value;
            doCancel = strcmp(x,obj.lastSelected);
            obj.lastSelected = x;
        end
    end
end

