classdef JButton < JComponent & JSetGetText & JActionnable
    
    properties(Constant)
        JClass = 'javax.swing.JButton'
        isEDT = false
    end
    
    methods
        function obj = JButton(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename);
            obj@JActionnable();
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end
    end
end

