classdef JMenuBar < JComponent
    %JMENUBAR Summary of this class goes here
    %   Detailed explanation goes here

    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JMenuBar'
    end
    
    methods
        function obj = JMenuBar(varargin)
            obj@JComponent();
            if numel(varargin)
                set(obj,varargin{:})
            end
        end
    end
end
