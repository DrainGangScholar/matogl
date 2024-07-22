classdef JScrollPane < JComponent
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JScrollPane'
    end

    properties
        % vp
    end
    
    methods
        function obj = JScrollPane(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent();
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end

        function comp = add(obj,comp,varargin)
            obj.java.setViewportView(comp.java);
            obj.addChild(comp);
            obj.refresh;
        end

    end
end

