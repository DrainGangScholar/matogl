classdef JToolBar < JComponent
    properties(Constant)
        JClass = 'javax.swing.JToolBar'
        isEDT = false
        HORIZONTAL = javax.swing.JToolBar.HORIZONTAL;
        VERTICAL = javax.swing.JToolBar.VERTICAL;
    end
    properties
        orientation
        alignmentX
    end
    methods
        function obj = JToolBar(orientation);
            if nargin == 0
                obj.setOrientation(obj.HORIZONTAL);
            end
            if nargin == 1
                obj.orientation=orientation;
            end
        end
        function set.orientation(obj,orientation)
            obj.orientation=orientation;
            obj.java.setOrientation(orientation);
        end
        function o = get.orientation(obj)
            o=obj.orientation;
        end
        function set.alignmentX(obj,alignment)
            obj.alignmentX=alignment;
            obj.java.setAlignmentX(alignment);
        end
        function add(obj,toAdd)
            obj.java.add(toAdd.java);
        end
        function addSeparator(obj)
            obj.java.addSeparator();
        end
    end
end