classdef ParcellationSegments  
	%% PARCELLATIONSEGMENTS collects freesurfer statistics as specified by parameters (thickness, CBF, OEF, etc.),
    %  hemisphere, vascular territory, and path to the session data.  Static and instance variables provide
    %  arrays of raw double, mean, median, std, stderr.
    %  Uses:  Parcellations, SurferBuilderPrototype

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

    properties 
        parameter
        hemisphere
        territory
        statistic
        delta
        sessionPath
    end
    
    methods (Static)
        function m = asMap(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            m  = ps.map;
        end
        function d = asDouble(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            d  = ps.double;
        end
        function m = asMean(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            m  = ps.mean; 
        end
        function m = asMedian(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            m  = ps.median;
        end
        function s = asStd(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            s  = ps.std;
        end
        function s = asStdErr(varargin)
            ps = mlsurfer.ParcellationSegments(varargin{:});
            s  = ps.stderr;
        end
    end
    
	methods 
        function m = map(this)
            m = this.map_;
        end
 		function d = double(this)
            d = this.map2vec(this.map_);
 		end 
 		function m = mean(this) 
            dble = this.double;
            m = mean(dble(~isnan(dble)));
        end 
        function m = median(this)
            dble = this.double;
            m = median(dble(~isnan(dble)));
        end
 		function s = std(this) 
            dble = this.double;
            s = std(dble(~isnan(dble)));
 		end 
 		function s = stderr(this) 
            dble  = this.double;
            dble1 = dble(~isnan(dble));
            s = std(dble1) / sqrt(length(dble1));
        end 
        
 		function this = ParcellationSegments(param, hemis, varargin) 
            %% PARCELLATIONSEGMENTS
 			%  Usage:  this = ParcellationSegments(parameter, hemisphere[, ParamName, ParamValue, ...]) 
            %                                      ^ thickness, adc_default, CBF, CBV, MTT, alpha, beta, t0,
            %                                        PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, ...
            %                                                 ^ lh, rh
            %                                                              ^ Hemisphere, Territory, Delta, SessionPath, ...
            
            import mlsurfer.*;
            p = inputParser;
            addRequired( p, 'parameter',          @ischar);
            addRequired( p, 'hemisphere',         @(x) strcmp('lh',x) || strcmp('rh',x));
            addParameter(p, 'Territory',  'all',  @(x) lstrfind(x, Parcellations.TERRITORIES));
            addParameter(p, 'Statistic', 'mean', @ischar); 
            addParameter(p, 'Delta',       false, @islogical);
            addParameter(p, 'SessionPath', pwd,   @isdir);
            parse(p, param, hemis, varargin{:});
            this.parameter   = param;
            this.hemisphere  = hemis;
            this.territory   = p.Results.Territory;
            this.statistic   = p.Results.Statistic;
            this.delta       = p.Results.Delta;
            this.sessionPath = p.Results.SessionPath;
            
            parc      = Parcellations( ...
                        SurferBuilderPrototype('SessionPath', p.Results.SessionPath));
            this.map_ = parc.segidentifiedStatsMap(hemis, param, this.territory, this.statistic);
 		end 
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        map_ % containers.Map provided on class instantiation by Parcellations.segidentifiedStatsMap
    end
    
    methods (Access = 'private')
        function v = map2vec(~, m)
            assert(isa(m, 'containers.Map'));
            kys = m.keys;
            assert(isnumeric(kys{1}), 'unsupported class for m.keys->%s', class(kys{1}));
            v = nan(m.length,1);
            for k = 1:length(kys)
                v(k) = m(kys{k});
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

