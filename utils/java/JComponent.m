classdef JComponent < JObj & JChildParent & javacallbackmanager

    properties(Dependent)
        Name char
        Size (1,2) double {mustBeFinite}
        PreferredSize (1,2) double {mustBeFinite}
        MinimumSize (1,2) double {mustBeFinite}
        MaximumSize (1,2) double {mustBeFinite}
        Location (1,2) double {mustBeFinite}
        ScreenLocation (1,2) double {mustBeFinite}
        Font (1,1) JFont
        Alignment (1,2) double {mustBeFinite}
        Constraints (1,1) JConstraints
        VerticalAlignment char {mustBeMember(VerticalAlignment,{'Center','Top','Bottom'})}
        HorizontalAlignment char {mustBeMember(HorizontalAlignment,{'Center','Left','Right'})}
        ToolTip char
        Color (1,3) double
        BackgroundColor (1,3) double
        Enabled (1,1) logical
    end

    events
        ComponentAdded
        ComponentRemoved
        HierarchyChanged
        AncestorAdded
        AncestorRemoved
        MouseMoved
        MouseDragged
        FocusGained
        FocusLost
        MouseWheelMoved
        AncestorMoved
        AncestorResized
        MousePressed
        MouseReleased
        MouseClicked
        MouseExited
        MouseEntered
        ComponentResized
        ComponentMoved
        ComponentShown
        ComponentHidden
        InputMethodTextChanged
        CaretPositionChanged
        PropertyChange
        KeyTyped
        KeyPressed
        KeyReleased
        VetoableChange
    end

    properties(Hidden)
        Layout
    end
    
    methods
        function obj = JComponent(varargin)
            obj@JObj(varargin{:});
            obj@javacallbackmanager();
        end
        
        function comp = add(obj,comp,varargin)
            obj.java.add(comp.java,varargin{:});
            obj.addChild(comp);
            % obj.refresh;
        end

        function refresh(obj)
            obj.java.revalidate;
            obj.java.repaint;
        end

        function F = get.Font(obj)
            F = JFont(obj.java.getFont);
        end

        function set.Font(obj,F)
            obj.java.setFont(F.java);
        end
        
        function n = get.Name(obj)
            n = char(obj.java.getName);
        end

        function set.Name(obj,n)
            obj.java.setName(n);
        end

        function sz = get.Size(obj)
            sz = [obj.java.getWidth obj.java.getHeight];
        end

        function set.Size(obj,sz)
            obj.java.setSize(sz(1),sz(2));
        end

        function sz = get.PreferredSize(obj)
            D = obj.java.getPreferredSize;
            sz = [D.getWidth D.getHeight];
        end

        function set.PreferredSize(obj,sz)
            D = java.awt.Dimension(sz(1),sz(2));
            obj.java.setPreferredSize(D);
        end

        function sz = get.MinimumSize(obj)
            D = obj.java.getMinimumSize;
            sz = [D.getWidth D.getHeight];
        end

        function set.MinimumSize(obj,sz)
            D = java.awt.Dimension(sz(1),sz(2));
            obj.java.setMinimumSize(D);
        end

        function sz = get.MaximumSize(obj)
            D = obj.java.getMaximumSize;
            sz = [D.getWidth D.getHeight];
        end

        function set.MaximumSize(obj,sz)
            D = java.awt.Dimension(sz(1),sz(2));
            obj.java.setMaximumSize(D);
        end

        function xy = get.Location(obj)
            loc = obj.java.getLocation;
            xy = [loc.x loc.y];
        end

        function set.Location(obj,xy)
            obj.java.setLocation(java.awt.Point(xy(1),xy(2)));
        end

        function xy = get.ScreenLocation(obj)
            loc = obj.java.getLocationOnScreen;
            xy = [loc.x loc.y];
        end

        function set.ScreenLocation(obj,xy)
            obj.java.setLocationOnScreen(java.awt.Point(xy(1),xy(2)));
        end

        function xy = get.Alignment(obj)
            xy = [obj.java.getAlignmentX obj.java.getAlignmentY];
        end

        function set.Alignment(obj,xy)
            obj.java.setAlignmentX(xy(1));
            obj.java.setAlignmentY(xy(2));
            % obj.refresh;
        end

        function L = get.Constraints(obj)
            L = obj.parent.Layout;
            if ~isempty(L)
                c = L.getConstraints(obj.java);
                L = JConstraints(c);
            end
        end

        function set.Constraints(obj,L)
            L.setTo(obj.parent,obj);
        end

        function a = get.VerticalAlignment(obj)
            a = obj.align2str(obj.java.getVerticalAlignment);
        end

        function set.VerticalAlignment(obj,a)
            obj.java.setVerticalAlignment(obj.str2align(a));
        end

        function a = get.HorizontalAlignment(obj)
            a = obj.align2str(obj.java.getHorizontalAlignment);
        end

        function set.HorizontalAlignment(obj,a)
            obj.java.setHorizontalAlignment(obj.str2align(a));
        end

        function t = get.ToolTip(obj)
            t = char(obj.java.getToolTipText);
        end

        function set.ToolTip(obj,t)
            if isempty(t)
                obj.java.setToolTipText([]);
            else
                obj.java.setToolTipText(t);
            end
        end

        function set.Color(obj,c)
            c = java.awt.Color(c(1),c(2),c(3));
            obj.java.setForeground(c);
        end

        function c = get.Color(obj)
            c = obj.java.getForeground;
            c = c.getRGBComponents(zeros(4,1));
            c = double(c(1:3))';
        end

        function set.BackgroundColor(obj,c)
            c = java.awt.Color(c(1),c(2),c(3));
            obj.java.setBackground(c);
        end

        function c = get.BackgroundColor(obj)
            c = obj.java.getBackground;
            c = c.getRGBComponents(zeros(4,1));
            c = double(c(1:3))';
        end

        function tf = get.Enabled(obj)
            tf = obj.java.getEnabled;
        end

        function set.Enabled(obj,tf)
            obj.java.setEnabled(tf);
        end

        function delete(obj)
            p = obj.java.getParent;
            if ~isempty(p)
                p.remove(obj.java);
                % p.revalidate;
                % p.repaint;
            end
            
        end

    end

    methods(Static)
        function str = align2str(v)
            switch v
                case javax.swing.SwingConstants.CENTER
                    str = 'Center';
                case javax.swing.SwingConstants.TOP
                    str = 'Top';
                case javax.swing.SwingConstants.BOTTOM
                    str = 'Bottom';
                case javax.swing.SwingConstants.LEFT
                    str = 'Left';
                case javax.swing.SwingConstants.RIGHT
                    str = 'Right';
                case javax.swing.SwingConstants.LEADING
                    str = 'Leading';
                case javax.swing.SwingConstants.TRAILING
                    str = 'Trailing';
            end
        end

        function v = str2align(str)
            if isempty(str), str = 'Center'; end
            v = javax.swing.SwingConstants.(upper(str));
        end

    end
end

