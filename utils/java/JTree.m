classdef JTree < JComponent & JActionnable
    
    properties(Constant)
        isEDT = false
        JClass = 'javax.swing.JTree'
    end

    properties
        RootNode
        nodes JTreeNode
        ValueChangedFcn
    end

    properties(Transient)
        RootVisible
        SelectedNodes
    end

    events
        ValueChanged
    end
    
    methods
        function obj = JTree(varargin)
            [parent,varargin] = jparse(varargin{:});
            
            rootNode = JTreeNode('root');
            obj@JComponent(rootNode.java);
            obj@JActionnable('ValueChanged');
            obj.java.setRootVisible(false);
            rootNode.Tree = obj;
            rootNode.parent = obj;
            obj.RootNode = rootNode;
            obj.java.setLargeModel(true);
            parent.add(obj);
            if numel(varargin)
                set(obj,varargin{:})
            end
        end

        function add(obj,node)
            obj.RootNode.add(node);
        end

        function v = get.RootVisible(obj)
            v = obj.java.isRootVisible;
        end

        function set.RootVisible(obj,v)
            obj.java.setRootVisible(v);
        end

        function node = get.SelectedNodes(obj)
            p = arrayfun(@char,obj.java.getSelectionPaths,'uni',0);
            if isempty(p)
                node = [];
                return
            end
            allp = arrayfun(@(c) c.nodePath,obj.nodes,'uni',0);

            tf = ismember(allp,p);
            node = obj.nodes(tf);
        end

        function set.SelectedNodes(obj,nodes)
            p = arrayfun(@(c) javax.swing.tree.TreePath(c.java.getPath),nodes,'uni',0);
            p = vertcat(p{:});
            if isscalar(p)
                obj.java.setSelectionPath(p);
            else
                obj.java.setSelectionPaths(p);
            end
        end

        function name = uniqueName(obj,name,~)
        end

        function delete(obj)
            delete(obj.RootNode);
        end
    end
    methods(Access=protected)

        function data = ActionData(obj)
            data = obj.SelectedNodes;
        end

    end
end
