classdef JGridLayout < JPanel
% https://docs.oracle.com/javase/tutorial/uiswing/layout/gridbag.html

    properties(Transient)
        X = [-1 -1];
        Y = [-1 -1];
    end
    properties(Dependent)
        Padding (1,4) double {mustBeFinite}
    end
    
    methods
        function obj = JGridLayout(varargin)

            [parent,varargin] = jparse(varargin{:});
            
            obj@JPanel(parent)

            obj.Layout = java.awt.GridBagLayout();
            obj.Layout.rowHeights = [0 0];
            obj.Layout.rowWeights = [1 1];
            obj.Layout.columnWidths = [0 0];
            obj.Layout.columnWeights = [1 1];

            obj.java.setLayout(obj.Layout);

            if numel(varargin)
                set(obj,varargin{:})
            end

        end

        function add(obj,comp)
            c = java.awt.GridBagConstraints();
            c.fill = true;
            comp.PreferredSize = [-1 -1];
            obj.add@JComponent(comp,c);
        end

        function set.X(obj,X)
            [px,w] = uni2pxw(X);
            obj.Layout.columnWidths = px;
            obj.Layout.columnWeights = w;
            obj.X = X;
            % obj.refresh;
        end

        function set.Y(obj,Y)
            [px,w] = uni2pxw(Y);
            obj.Layout.rowHeights = px;
            obj.Layout.rowWeights = w;
            obj.Y = Y;
            % obj.refresh;
        end

        function set.Padding(obj,p)
            if all(p == 0)
                b = [];
            else
                b = javax.swing.border.EmptyBorder(p(1),p(2),p(3),p(4));
            end
            obj.java.setBorder(b);
        end

        function p = get.Padding(obj)
            b = obj.java.getBorder;
            if isempty(b)
                p = [0 0 0 0];
            else
                x = b.getBorderInsets;
                p = [x.top x.left x.bottom x.right];
            end
        end

    end
end

function [px,w] = uni2pxw(X)
    i = X < 0;
    px = X.*~i;
    w = -X.*i;
end

