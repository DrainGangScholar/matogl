function [parent,args] = jparse(varargin)

if nargin > 0 && isa(varargin{1},'JObj')
    parent = varargin{1};
    i = 2;
else
    parent = JFrame;
    i = 1;
end

args = varargin(i:end);

end

