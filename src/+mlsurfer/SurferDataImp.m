classdef (Abstract) SurferDataImp < mlsurfer.ISurferDataImp
	%% SURFERDATAIMP  

	%  $Revision$
 	%  was created 07-Oct-2015 15:14:22
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties (Dependent)
        surferFilesystem
    end
    
    methods %% GET
        function x = get.surferFilesystem(this)
            x = this.parcs_.surferFilesystem;
        end
    end

	methods 		  
 		function this = SurferDataImp(pth)
 			%% SURFERDATAIMP
 			%  Usage:  this = SurferDataImp(path_to_session)
 			
            this.parcs_ = mlsurfer.Parcellations('SessionPath', pth);
        end
    end
    
    %% PROTECTED
    
    properties (Access = 'protected')
        parcs_
        map_
    end
    
    methods (Access = 'protected')
        function k = mapKeys_(this)
            %% MAPKEYS returns double column
            
            assert(~isempty(this.map_));
            k = cell2mat(this.map_.keys)';
        end
        function v = mapValues_(this)
            %% MAPVALUES returns double column
            
            kys = this.map_.keys;
            v   = nan(this.map_.length,1);
            for k = 1:length(kys)
                v(k) = this.map_(kys{k});
            end
        end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

