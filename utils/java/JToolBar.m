classdef JToolBar < JComponent
    properties(Constant)
        JClass = 'javax.swing.JToolBar'
        isEDT = false
        HORIZONTAL = javax.swing.JToolBar.HORIZONTAL;
        VERTICAL = javax.swing.JToolBar.VERTICAL;
    end
    methods
        function obj = JToolBar(orientation);
            if nargin == 0
                obj.setOrientation(obj.HORIZONTAL);
            end
            if nargin == 1
                obj.setOrientation(orientation);
            end
        end
        function setOrientation(obj,orientation)
            obj.java.setOrientation(orientation);
        end
        function add(obj,toAdd)
            disp(['Type of toAdd: ', class(toAdd)]);
            obj.java.add(toAdd.java);
        end
        function addSeparator(obj)
            obj.java.addSeparator();
        end
    end
end