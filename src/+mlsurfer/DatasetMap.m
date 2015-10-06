classdef DatasetMap  
	%% DATASETMAP has a containers.Map and makes accessible:  isKey, keys, length, size, values
    %  cf. mlanalysis.GlmDirectorComponent, DsaGlmDirector

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    methods (Static)
        function [v,this] = asKeys(param, varargin)
            this = mlsurfer.DatasetMap(param, varargin{:});
            v    = this.keys;
        end
        function [m,this] = asMap(param, varargin)
            this = mlsurfer.DatasetMap(param, varargin{:});
            m = this.map_;
        end
        function [v,this] = asValues(param, varargin)
            this = mlsurfer.DatasetMap(param, varargin{:});
            v    = this.values;
        end
    end
    
	methods
 		function this = DatasetMap(param, varargin) 
 			%% DATASETMAP 
 			%  Usage:  this = DatasetMap(parameter[, ParamName, ParamValue, ...]) 
            %                 Territory, Delta, SessionPath, ...

            import mlsurfer.*;
            p = inputParser;
            addRequired( p, 'param',              @ischar);
            addParameter(p, 'Territory',  'all',  @(x) lstrfind(x, Parcellations.TERRITORIES));
            addParameter(p, 'Delta',       false, @islogical);
            addParameter(p, 'SessionPath', pwd,   @(x) lexist(x, 'dir'));
            parse(p, param, varargin{:});
            
            this.parc_ = Parcellations( ...
                         SurferBuilderPrototype('SessionPath', p.Results.SessionPath));
            this.map_  = [this.parc_.segidentifiedStatsMap('lh', param, p.Results.Territory); ... 
                          this.parc_.segidentifiedStatsMap('rh', param, p.Results.Territory)];  
        end 
        
        function tf  = isKey(this, k)
            tf = this.map_.isKey(k);
        end
        function k   = keys(this)
            k = this.map_.keys;
        end
        function len = length(this)
            len = this.map_.length;
        end
        function s   = size(this)
            s = this.map_.size;
        end
        function v   = values(this)
            v = this.map_.values;
        end
    end 
    
    %% PRIVATE

	properties (Access = 'private')
        map_
        parc_
    end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

