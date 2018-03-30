classdef Hemisphere < mlsurfer.SurferDataImp
	%% HEMISPHERE  

	%  $Revision$
 	%  was created 07-Oct-2015 14:14:32
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	
	properties
 		parameter
 	end

	methods (Static)        
        function [m,ids] = metric(varargin)
            %% METRIC retuns double column vectors containing metrics and identifiers for the specified
            %  session and parameter.  Each vector element arises from a Freesurfer parcellation.
            %  Usage:  [metrics, identifiers] = Hemisphere.metric(path_to_session, parameter)
            
            this = mlsurfer.Hemisphere(varargin{:});
            [m,ids] = this.itsMetric;
        end
    end
    
	methods	  
 		function this = Hemisphere(pth, varargin)
 			%% HEMISPHERE
 			%  Usage:  this = Hemisphere(path_to_session, hemisphere, parameter[, 'ctor_param_name', ctor_param_value])
            %                                             ^ lh|rh     ^ from Parcellations.PARAMS_ALL
            
            this = this@mlsurfer.SurferDataImp(pth);
            import mlsurfer.*;
            ip = inputParser;
            addRequired(ip, 'pth',   @(x) this.surferFilesystem.isaSessionPath(x));
            addRequired(ip, 'hemi',  @(x) lstrfind(x, Parcellations.HEMIS));
            addRequired(ip, 'param', @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', 'all_aca_mca', @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, pth, varargin{:});
            
            this.map_      = this.parcs_.segidentifiedStatsMap(ip.Results.hemi, ip.Results.param, ip.Results.Territory);
            this.parameter = ip.Results.param;
        end
        function [m,ids] = itsMetric(this)
            m   = this.itsMapValues;
            ids = this.itsMapKeys;
        end
        function m    = itsMapValues(this)
            m = this.mapValues_;
        end
        function ids  = itsMapKeys(this)
            ids = this.mapKeys_;
        end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

