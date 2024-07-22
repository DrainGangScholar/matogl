classdef JTreeNode < JObj & JChildParent & matlab.mixin.SetGet
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.tree.DefaultMutableTreeNode'
    end

    properties
        Tree
        nodePath
    end

    properties(Transient)
        Name
        Expanded
    end
    
    methods

        function obj = JTreeNode(varargin)
            isRoot = nargin == 1 && isscalartext(varargin{1}) && strcmp(varargin{1},'root');
            if ~isRoot
                [parent,varargin] = jparse(varargin{:});
                if isa(parent,'JTree')
                    parent = parent.RootNode;
                end
                if ~isa(parent,'JTreeNode')
                    parent = JTree(parent).RootNode;
                end
            end
            
            obj@JObj('JTreeNode');

            if isRoot
                obj.Name = 'root';
            else
                tf = parent.Expanded;
                parent.add(obj);
                % parent.add(obj);
                if tf, parent.Expanded = true; end
                if ~isempty(varargin)
                    set(obj,varargin{:});
                end
            end
            
        end

        function node = add(obj,node)
            % if nargin < 3, expand = true; end

            node.Name = obj.uniqueName(node.Name);
            obj.addChild(node);
            obj.java.add(node.java);
            node.Tree = obj.Tree;
            
            obj.Tree.java.getModel.reload(obj.java);
            
        end

        function set.Tree(obj,T)
            obj.Tree = T;
            obj.Tree.nodes(end+1,1) = obj;
            obj.updateNodePath;
        end

        function set.Name(obj,x)
            if ~isempty(obj.Tree)
                x = obj.parent.uniqueName(x,obj.Name);
            end
            obj.java.setUserObject(x);
            obj.updateNodePath;

            if ~isempty(obj.Tree)
                % obj.Tree.java.invalidate;
                obj.Tree.refresh;
                % obj.Tree.java.getModel.reload;
            end

        end

        function x = get.Name(obj)
            x = char(obj.java.getUserObject);
        end

        function set.Expanded(obj,tf)
            F = {'collapse','expand'};
            if obj.java.isRoot
                T = 'Row';
                arg = 0;
            else
                T = 'Path';
                arg = javax.swing.tree.TreePath(obj.java.getPath);
            end
            obj.Tree.java.([F{tf+1} T])(arg);
            obj.Expanded = tf;
        end

        function tf = get.Expanded(obj)
            if isempty(obj.child)
                tf = obj.Expanded;
                if isempty(tf)
                    tf = false;
                end
                return
            end
            if obj.java.isRoot
                arg = 0;
            else
                arg = javax.swing.tree.TreePath(obj.java.getPath);
            end
            tf = obj.Tree.java.isExpanded(arg);
        end

        function name = uniqueName(obj,name,toIgnore)
            names = cellfun(@(c) char(c.Name),obj.child,'Uni',0);
            names = [names {name}];
            if nargin >= 3
                names = names(~ismember(names,toIgnore));
            end
            names = matlab.lang.makeUniqueStrings(names);
            name = names{end};
        end

        function updateNodePath(obj)
            j = obj.java;
            if ~j.isRoot
                j = obj.Tree.java.getModel.getPathToRoot(j);
            end
            obj.nodePath = char(javax.swing.tree.TreePath(j));
            cellfun(@updateNodePath,obj.child);
        end

        function delete(obj)
            if ~isempty(obj.Tree) && isvalid(obj.Tree)
                isRoot = obj.java.isRoot;
                obj.java.removeFromParent;
                k = arrayfun(@(c) eq(c,obj),obj.Tree.nodes);
                obj.Tree.nodes(k) = [];
                obj.Tree.java.getModel.reload;
                if isRoot
                    % panic
                    p = obj.Tree.parent;
                    delete(obj.Tree)
                    if ~isempty(p) && isvalid(p)
                        p.refresh;
                    end
                end
            end
        end
    end
end
