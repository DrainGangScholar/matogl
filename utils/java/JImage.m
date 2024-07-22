classdef JImage < JComponent
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JLabel'
    end

    properties(Transient)
        Value
        ScaleMethod char {mustBeMember(ScaleMethod,{'Fit','Stretch','None'})} = 'Fit'
    end

    properties(Access=private)
        javaImg
    end
    
    methods
        function obj = JImage(varargin)

            [parent,varargin] = jparse(varargin{:});
            obj@JComponent();
            obj.javaImg = im2java(cat(3,1,1,1));
            obj.java.setHorizontalAlignment(obj.java.CENTER);

            parent.add(obj);
            obj.addJEvents('ComponentResized');
            addlistener(obj,'ComponentResized',@obj.AdjustImage);

            if numel(varargin)
                set(obj,varargin{:})
            end

        end

        function AdjustImage(obj,src,evt)
            im = obj.javaImg;
            % if isempty(im), return, end
            sz = clamp(obj.Size,1,inf);
            imSz = clamp([im.getWidth im.getHeight],1,inf);
            switch obj.ScaleMethod
                case 'Stretch'
                    newSz = sz;
                case 'Fit'
                    newSz = fitSize(imSz,sz);
                otherwise
                    newSz = imSz;
            end
            obj.java.setIcon(javax.swing.ImageIcon(im.getScaledInstance(newSz(1),newSz(2),im.SCALE_SMOOTH)));
        end

        function set.ScaleMethod(obj,str)
            obj.ScaleMethod = str;
            obj.AdjustImage;
        end

        function set.Value(obj,img)
            if isnumeric(img)
                obj.javaImg = im2java(img);
                % jIcon = javax.swing.ImageIcon(obj.javaImg);
            else
                src = img;
                if isempty(dir(src))
                    src = which(src);
                end
                if ~exist(src,'file')
                    error('Image not found: %s',src);
                end
                jIcon = javax.swing.ImageIcon(src);
                obj.javaImg = jIcon.getImage;
            end
            obj.Value = img;
            obj.AdjustImage;
        end

        % function set.HorizontalAlignment(obj,a)
        %     obj.java.setHorizontalAlignment(obj.const(a));
        %     obj.HorizontalAlignment = a;
        % end
        % 
        % function set.VerticalAlignment(obj,a)
        %     obj.java.setVerticalAlignment(obj.const(a));
        %     obj.VerticalAlignment = a;
        % end

        function xy = getNormalizedEventCoords(obj,evt)
            coords = [evt.getX evt.getY]+0.5;
            sz = clamp(obj.size,1,inf);
            if strcmp(obj.ScaleMethod,'Stretch')
                xy = coords./sz;
                return
            end

            im = obj.javaImg;
            imSz = clamp([im.getWidth im.getHeight],1,inf);
            if strcmp(obj.ScaleMethod,'Fit')
                imSz = fitSize(imSz,sz);
            end

            bx = getOffset(sz(1),imSz(1),obj.HorizontalAlignment,'Left');
            by = getOffset(sz(2),imSz(2),obj.VerticalAlignment,'Top');

            xy = coords./imSz + [bx by];
        end

    end
end

function newSz = fitSize(imSz,sz)
    r = sz ./ imSz;
    if r(1) > r(2)
        newSz = round(imSz.*r(2));
    else
        newSz = round(imSz.*r(1));
    end
    newSz = clamp(newSz,1,inf);
end

function o = getOffset(sz,imSz,a,a1)
    o = 0;
    if ~strcmp(a,a1)
        o = 1-sz/imSz;
    end
    if strcmp(a,'Center')
        o = o/2;
    end
end

