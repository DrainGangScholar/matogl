classdef JBoxLayout < JPanel

    properties(Dependent)
        Axis char {mustBeMember(Axis,{'X','Y'})}
        Padding (1,4) double {mustBeFinite}
    end
    
    methods
        function obj = JBoxLayout(varargin)

            [parent,varargin] = jparse(varargin{:});
            
            obj@JPanel(parent)

            obj.Layout = javax.swing.BoxLayout(obj.java,javax.swing.BoxLayout.Y_AXIS);
            obj.java.setLayout(obj.Layout);

            if numel(varargin)
                set(obj,varargin{:})
            end

        end

        function ax = get.Axis(obj)
            if obj.Layout.getAxis
                ax = 'Y';
            else
                ax = 'X';
            end
        end

        function set.Axis(obj,ax)
            a = javax.swing.BoxLayout.(sprintf('%s_AXIS',upper(ax)));
            obj.Layout = javax.swing.BoxLayout(obj.java,a);
            obj.java.setLayout(obj.Layout);
            obj.refresh;
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

