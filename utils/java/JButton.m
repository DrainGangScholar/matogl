classdef JButton < JComponent
    % Basic JButton display in MATLAB

    properties(Constant)
        JClass = 'javax.swing.JButton'
        isEDT = false
    end

    properties
        text
    end
    
    methods
        
        function obj = JButton(text, callback)
            if nargin < 1, text = 'Button'; end
            obj.text = text;
            obj.java.setText(text);
            if nargin > 1
                set(handle(obj.java, 'CallbackProperties'), 'ActionPerformedCallback', callback);
            end
        end

        function set.text(obj, t)
            obj.java.setText(t);
        end

        function t = get.text(obj)
            t = char(obj.java.getText);
        end

    end
end