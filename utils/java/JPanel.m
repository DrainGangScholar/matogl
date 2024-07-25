classdef JPanel < JComponent
    % basic JPanel display in MATLAB
    
    properties(Constant)
        JClass = 'javax.swing.JPanel'
        isEDT = false
        FLOW_LAYOUT = java.awt.FlowLayout
        BORDER_LAYOUT= java.awt.BorderLayout
        BORDER_LAYOUT_SOUTH = java.awt.BorderLayout.SOUTH
        BORDER_LAYOUT_NORTH = java.awt.BorderLayout.NORTH
    end
    
    properties
        layout
        visible
    end
    
    methods
        
        function obj = JPanel(layout)
            if nargin < 1, layout = obj.FLOW_LAYOUT; end
            obj.layout = layout;
            obj.visible = true;
        end
        
        function set.layout(obj, layout)
            obj.layout=layout;
            obj.java.setLayout(layout);
        end
        
        function set.visible(obj,visible)
            obj.visible=visible;
            obj.java.setVisible(visible);
        end

        function addButton(obj,button,layout)
            obj.java.add(button.java,layout);
        end

        function l = get.layout(obj)
            l = char(obj.java.getLayout.getClass.getSimpleName);
        end
        
        function addComponent(obj, component)
            obj.java.add(component.java);
        end

        function refresh(obj)
            obj.java.revalidate();
            obj.java.repaint();
        end
        
        function delete(obj)
            obj.java.setVisible(false);
            obj.java.removeAll;
        end
        
    end
end
