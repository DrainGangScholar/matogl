classdef JFrame < JComponent
    % basic JFrame display in matlab

    properties(Constant)
        JClass = 'javax.swing.JFrame'
        isEDT = false
    end

    properties
        Title char
        JMenuBar
    end

    events
        WindowClosing
    end
    
    methods
        
        function obj = JFrame(varargin)
            obj.java.setDefaultCloseOperation(obj.java.HIDE_ON_CLOSE); % will be disposed by the delete fcn
            obj.addJEvents('WindowClosing');
            addlistener(obj,'WindowClosing',@(~,~) obj.delete);

            p = inputParser;
            p.addParameter('Title','JFrame',@(~) true);
            p.addParameter('Size',[600 450]);
            p.KeepUnmatched = true;
            p.parse(varargin{:});

            obj.Title = p.Results.Title;
            obj.Size = p.Results.Size;
            obj.java.setLocationRelativeTo([]); % set position to center of screen
            set(obj,p.Unmatched);

            obj.java.setVisible(true);
        end

        function set.Title(obj,t)
            obj.java.setTitle(t);
        end

        function t = get.Title(obj)
            t = char(obj.java.getTitle);
        end

        function set.JMenuBar(obj,comp)
            if isempty(comp)
                jcomp = [];
            else
                jcomp = comp.java;
            end
            obj.java.setJMenuBar(jcomp);
            obj.JMenuBar = comp;
            obj.refresh;
        end

        function delete(obj)
            obj.java.dispose;
            delete(obj.JMenuBar);
        end
        
    end
end

