classdef JMenu < JComponent & JSetGetText & JActionnable
    %JMENU Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JMenu'
    end
    
    methods
        function obj = JMenu(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename);
            obj@JActionnable();
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end

        function AddSeparator(obj)
            obj.java.addSeparator();
        end
    end
end

