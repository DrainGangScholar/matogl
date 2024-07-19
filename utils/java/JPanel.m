classdef JPanel < JComponent
    % basic JPanel display in MATLAB
    
    properties(Constant)
        JClass = 'javax.swing.JPanel'
        isEDT = false
    end
    
    properties
        layout
    end
    
    methods
        
        function obj = JPanel(layout)
            if nargin < 1, layout = 'FlowLayout'; end
            obj.layout = layout;
            obj.java.setLayout(javaObject(['java.awt.' layout]));
            obj.java.setVisible(true);
        end
        
        function set.layout(obj, layout)
            obj.java.setLayout(javaObject(['java.awt.' layout]));
        end
        
        function l = get.layout(obj)
            l = char(obj.java.getLayout.getClass.getSimpleName);
        end
        
        function addComponent(obj, component)
            obj.java.add(component.java);
        end
        
        function delete(obj)
            obj.java.setVisible(false);
            obj.java.removeAll;
        end
        
    end
end
