classdef PetSurfer
    %% line1
    %  line2
    %  
    %  Created 02-Nov-2022 01:40:19 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
    %  Developed on Matlab 9.13.0.2080170 (R2022b) Update 1 for MACI64.  Copyright 2022 John J. Lee.
    
    methods
        function this = PetSurfer(varargin)
            %% PETSURFER 
            %  Args:
            %      arg1 (its_class): Description of arg1.
            
            ip = inputParser;
            addParameter(ip, "arg1", [], @(x) true)
            parse(ip, varargin{:})
            ipr = ip.Results;
            
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
