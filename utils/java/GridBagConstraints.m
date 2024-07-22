classdef GridBagConstraints < JObj
%     https://docs.oracle.com/javase/8/docs/api/java/awt/GridBagConstraints.html
    
    properties(Constant)
        isEDT = false
        JClass = 'java.awt.GridBagConstraints'
    end
    
    methods
        function obj = GridBagConstraints(xyPos,xySpan,fill,anchor,insets_ULDR)
            if nargin < 3, fill = 1; end
            obj.java.gridx = xyPos(1)-1;
            obj.java.gridy = xyPos(2)-1;
            obj.java.gridwidth = xySpan(1);
            obj.java.gridheight = xySpan(2);
            obj.java.fill = fill;
            if nargin >= 4
                obj.java.anchor = obj.const(anchor);
            end
            if nargin >= 5
                obj.java.insets = java.awt.Insets(insets_ULDR(1),insets_ULDR(2),insets_ULDR(3),insets_ULDR(4));
            end
        end
    end
end

