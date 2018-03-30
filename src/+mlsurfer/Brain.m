classdef Brain
	%% BRAIN  

	%  $Revision$
 	%  was created 08-Oct-2015 16:00:45
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		leftHemisphere
        rightHemisphere
        parameter
 	end

	methods (Static)        
        function [m,ids] = metric(varargin)
            %% METRIC retuns double column vectors containing metrics and identifiers for the specified
            %  session and parameter.  Each vector element arises from a Freesurfer parcellation.
            %  Usage:  [metrics, identifiers] = Brain.metric(path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            
            this = mlsurfer.Brain(varargin{:});
            [m,ids] = this.itsMetric;
        end
        function [m,ids] = metricIndex(m_ref, varargin)
            %% METRIC retuns double column vectors containing metrics and identifiers for the specified
            %  session and parameter.  Each vector element arises from a Freesurfer parcellation.
            %  The returned metric_indices ~ (metric - metric_reference) ./ metric_reference
            %  Usage:  [metric_indicess, identifiers] = ...
            %          Brain.metricIndex(metric_reference, path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            
            this = mlsurfer.Brain(varargin{:});            
            [m,ids] = this.itsMetricIndex(m_ref);
        end
        function assertIdentifiersEqual(ids, ids1)
            assert(isnumeric(ids));
            assert(isnumeric(ids1));
            assert(all(ids == ids1));
        end
    end
    
	methods 		  
 		function this = Brain(varargin)
 			%% BRAIN
 			%  Usage:  this = Brain(path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            %                                        ^ from Parcellations.PARAMS_ALL
            
            import mlsurfer.*;
            ip = inputParser;
            addRequired(ip, 'pth',   @isdir);
            addRequired(ip, 'param', @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', 'all_aca_mca', @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, varargin{:});
            
            this.leftHemisphere  = Hemisphere(ip.Results.pth, 'lh', ip.Results.param, 'Territory', ip.Results.Territory);
            this.rightHemisphere = Hemisphere(ip.Results.pth, 'rh', ip.Results.param, 'Territory', ip.Results.Territory);
            this.parameter       = ip.Results.param;
        end
        function [m,ids] = itsMetric(this)            
            m   = this.itsMapValues;
            ids = this.itsMapKeys; 
        end
        function [m,ids] = itsMetricIndex(this, m_ref) 
            m   = this.itsMapValuesIndexed(m_ref);
            ids = this.itsMapKeys; 
        end
        function m    = itsMapValues(this)
            m   = [this.leftHemisphere.itsMapValues; this.rightHemisphere.itsMapValues];
        end
        function m    = itsMapValuesIndexed(this, m_ref)            
            m = (this.itsMapValues - m_ref)./m_ref;
        end
        function ids  = itsMapKeys(this)
            ids = [this.leftHemisphere.itsMapKeys; this.rightHemisphere.itsMapKeys];
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

