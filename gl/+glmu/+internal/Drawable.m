classdef Drawable < glmu.internal.Object
    
    properties
        program
        show = 1
        uni = struct
%         storage_buffers % = {bufferForBinding0 i0 ; bufferForBinding1 i1 ; ... }
    end
    
    methods
        function obj = Drawable(program)
            obj.program = glmu.Program(program);
        end

        function PrepareDraw(obj)
        end

        function Draw(obj,varargin)
            if ~isvalid(obj), warning('drawable is deleted'); return, end
            if ~obj.show, return, end
            obj.PrepareDraw;
%             obj.BindSSBO(obj.storage_buffers);
            obj.program.Use;
            obj.program.SetUniforms(obj.uni);
            obj.DrawFcn(varargin{:});
        end
    end

%     methods(Static)
%         function BindSSBO(sb)
%             if ~isempty(sb)
%                 for i=1:height(sb)
%                     if ~isempty(sb{i,1})
%                         sb{i,1}.BindBase(i-1,sb{i,2});
%                     end
%                 end
%             end
%         end
%     end
    
    methods(Abstract)
        DrawFcn(obj,varargin)
    end

    % methods(Static)
    %     function b = struct2indirect(s)
    %         if ~isscalar(s)
    %             b = arrayfun(@glmu.internal.Drawable.struct2indirect,s,'uni',0);
    %             b = horzcat(b{:});
    %             return
    %         end
    %         u8 = @(x) typecast(x,'uint8');
    %         b = [u8(uint32(s.count)) ...
    %              u8(uint32(s.instanceCount)) ...
    %              u8(uint32(s.firstIndex)) ...
    %              u8(int32(s.baseVertex)) ...
    %              u8(uint32(s.baseInstance))];
    %     end
    % end
end

