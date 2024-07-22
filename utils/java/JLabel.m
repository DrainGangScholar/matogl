classdef JLabel < JComponent & JSetGetText
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JLabel'
    end
    
    methods
        function obj = JLabel(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename);
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end
    end
end

