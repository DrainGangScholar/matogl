classdef Array < glmu.internal.Object
    
    properties
        
    end
    
    methods
        function obj = Array()
            obj.id = obj.state.array.New(1);
        end

        function Bind(obj)
            obj.state.array.Bind(obj.id);
        end

    end
end

