classdef JConstraints
    %JCONSTRAINTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X
        Y
    end
    
    methods
        function obj = JConstraints(arg1,arg2)
            if nargin == 1
                x0 = arg1.gridx+1; x1 = x0+arg1.gridwidth-1;
                obj.X = [x0 x1];
                y0 = arg1.gridy+1; y1 = y0+arg1.gridheight-1;
                obj.Y = [y0 y1];
                % obj.X = [arg1.gridx+1 arg1.gridwidth];
                % obj.Y = [arg1.gridy+1 arg1.gridheight];
            else
                obj.X = arg1 .* [1 1];
                obj.Y = arg2 .* [1 1];
            end
        end

        function setTo(obj,parent,comp)
            c = java.awt.GridBagConstraints;
            x = obj.X .* [1 1];
            y = obj.Y .* [1 1];
            c.gridx = x(1) - 1;
            c.gridy = y(1) - 1;
            c.gridwidth = diff(x)+1;
            c.gridheight = diff(y)+1;
            c.fill = true;

            target = comp.java;
            % if comp.Scrollable
            %     target = target.getParent.getParent;
            % end
            parent.Layout.setConstraints(target,c);
            parent.refresh;
        end
        
    end
end

