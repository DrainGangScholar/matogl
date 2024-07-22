classdef JFont

    properties
        Family
        Style
        Size
    end
    
    methods
        function obj = JFont(arg1,arg2,arg3)
            if isjava(arg1)
                obj.Family = char(arg1.getFamily);
                obj.Size = arg1.getSize;
                obj.Style = obj.style2str(arg1.getStyle);
            else
                if nargin < 1, arg1 = 'Arial'; end
                if nargin < 2, arg2 = 12; end
                if nargin < 3, arg3 = 'Plain'; end
                obj.Family = arg1;
                obj.Size = arg2;
                obj.Style = arg3;
            end
        end

        function j = java(obj)
            j = java.awt.Font(obj.Family,obj.str2style(obj.Style),obj.Size);
        end

    end

    methods(Static)
        function f = AvailableFonts()
            f = arrayfun(@char,java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames,'uni',0);
        end

        function str = style2str(v)
            if ischar(v), str = v; return, end
            switch v
                case java.awt.Font.PLAIN
                    str = 'Plain';
                case java.awt.Font.BOLD
                    str = 'Bold';
                case java.awt.Font.ITALIC
                    str = 'Italic';
            end
        end

        function v = str2style(str)
            if isempty(str), str = 'Plain'; end
            v = java.awt.Font.(upper(str));
        end

    end
end

