classdef matogl
    
    properties(Constant)

        Version = [3 2 0]

        relativePaths = {
            'gl'
            'examples'
            'utils'
            fullfile('utils','java')
            };

    end
    
    methods(Static)
        function addpaths()
            cellfun(@addpath,matogl.paths);
        end

        function rmpaths()
            cellfun(@rmpath,matogl.paths);
        end

        function p = paths()
            rootDir = fileparts(mfilename('fullpath'));
            p = [{rootDir} ; fullfile(rootDir,matogl.relativePaths)];
        end
    end

end
