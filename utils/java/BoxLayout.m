classdef BoxLayout < JObj
    properties(Constant)
        X_AXIS =   0
        Y_AXIS =   1
        LINE_AXIS = 2
        PAGE_AXIS = 3
        JClass = 'javax.swing.BoxLayout'
        isEDT = false
    end
    properties
        target
        axis
    end
    methods
        function obj = BoxLayout(target,axis)
            obj.java = javaObject('javax.swing.BoxLayout',target.java,axis);
        end
    end
end
