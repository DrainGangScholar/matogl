classdef JMenuItem < JComponent & JSetGetText & JActionnable
    %JMENUBAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JMenuItem'
    end

    properties(Transient)
        Accelerator
    end
    
    methods
        function obj = JMenuItem(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent(mfilename);
            obj@JActionnable();
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end

        function set.Accelerator(obj,combo)
            acc = javax.swing.KeyStroke.getKeyStroke(combo);
            obj.java.setAccelerator(acc);
        end

        function combo = get.Accelerator(obj)
            combo = char(obj.java.getAccelerator);
        end

    end
end


