classdef JPanel < JComponent
    %JPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JPanel'
    end
    
    methods
        function obj = JPanel(varargin)
            [parent,varargin] = jparse(varargin{:});
            obj@JComponent();
            obj.addJEvents('ComponentResized');
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end
    end
end

