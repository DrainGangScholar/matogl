classdef JSetGetText < handle

    properties(SetAccess=protected,Abstract)
        java
    end
    
    properties(SetObservable,Transient)
        Text
    end
    
    methods
        function set.Text(obj,str)
            obj.java.setText(str);
        end

        function str = get.Text(obj)
            str = char(obj.java.getText);
        end
    end
    
end

