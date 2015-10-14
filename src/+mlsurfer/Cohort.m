classdef Cohort 
	%% COHORT  

	%  $Revision$
 	%  was created 08-Oct-2015 17:07:46
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
        dirTool
 		brains
        parameter
 	end

	methods (Static)        
        function [m,ids,sess] = metric(varargin)
            %% METRIC returns cell-arrays of metrics, parcellation identifiers and session folder names.
            %  The cells are indexed collinear with session folders.  metrics{session_index} and identifiers{session_index}
            %  contain the same information provided by [m,ids] = Brain.metric(...)
            %  Usage:  [metrics,identifiers,sessions] = ...
            %          Cohort.metric(path_to_subjects_dir, parameter[, 'ctor_param_name', ctor_param_value])
            
            this = mlsurfer.Cohort(varargin{:});
            [m,ids,sess] = this.itsMetric;
        end
        function [m,ids,sess] = metricIndex(varargin)
            %% METRICINDEX returns cell-arrays of metrics, parcellation identifiers and session folder names.
            %  The cells are indexed collinear with session folders.  metrics{session_index} and identifiers{session_index}
            %  contain the same information provided by [m,ids] = Brain.metricIndex(...)
            %  Usage:  [metrics,identifiers,sessions] = ...
            %          Cohort.metricIndex(path_to_subjects_dir, parameter[, 'ctor_param_name', ctor_param_value])

            this = mlsurfer.Cohort(varargin{:});
            [m,ids,sess] = this.itsMetricIndex;
        end
        function [m,ids] = meanMetric(varargin)
            %% MEANMETRIC retuns double column vectors containing mean metrics and identifiers for the specified
            %  session and parameter.  Each vector element arises from a Freesurfer parcellation.
            %  Usage:  [metrics, identifiers] = Cohort.meanMetric(path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            
            [m,ids] = mlsurfer.Cohort.funOfMetric(@mean, varargin{:});
        end
        function [m,ids] = stdMetric(varargin)
            %% STDMETRIC retuns double column vectors containing std metrics and identifiers for the specified
            %  session and parameter.  Each vector element arises from a Freesurfer parcellation.
            %  Usage:  [metrics, identifiers] = Cohort.stdMetric(path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            
            [m,ids] = mlsurfer.Cohort.funOfMetric(@std, varargin{:});
        end
        function [m,ids] = funOfMetric(h, varargin)
            %% FUNOFMETRIC retuns double column vectors containing results of function operations on 
            %  mean metrics and identifiers for the specified session and parameter.  
            %  Usage:  [metrics, identifiers] = Cohort.funOfMetric(function_handle, path_to_session, parameter[, 'ctor_param_name', ctor_param_value])
            
            this = mlsurfer.Cohort(varargin{:});
            [m,ids] = this.itsFunOfMetric(h);
        end
        function map = parcellationsAverage(m, sess)
            %% PARCELLATIONSAVERAGE returns a map of session identifiers to averaged metrics for each session.
            %  Averages are taken over all parcellations for each session.  
            %  Usage:  map = Cohort.parcellationsAverage(cell_array_metrics, cell_array_sessions)
            
            import mlsurfer.*;
            assert(iscell(m));
            assert(iscell(sess));
            assert(length(m) == length(sess));
            vals = cell(size(sess));
            
            for s = 1:length(sess)
                vals{s} = mean(m{s});
            end
            map = containers.Map(sess, vals);
        end
        function assertIdentifiersEqual(idss)
            assert(iscell(idss));
            for c = 1:length(idss)
                assert(all(idss{c} == idss{1}));
            end
        end
    end
    
	methods		  
 		function this = Cohort(varargin)
 			%% COHORT
 			%  Usage:  this = Cohort(path_to_subjects_dir, parameter)
            %                                              ^ from Parcellations.PARAMS_ALL
            
            import mlsurfer.*;
            this.registry_ = SurferRegistry.instance;
            ip = inputParser;
            addRequired(ip, 'pth',   @(x) lexist(x, 'dir'));
            addRequired(ip, 'param', @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', 'all_aca_mca', @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, varargin{:});
            
            cd(ip.Results.pth);
            this.dirTool = mlsystem.DirTool(this.registry_.sessionNamePattern);
            this.brains  = cell(1, this.dirTool.length);
            for d = 1:this.dirTool.length
                try
                    this.brains{d} = Brain(this.dirTool.fqdns{d}, ip.Results.param, 'Territory', ip.Results.Territory);
                catch %#ok<CTCH>
                    warning('mlsurfer:failedForLoop', ...
                            'Cohort.ctor failed to create this.brains{%i} from %s', d, this.dirTool.fqdns{d});
                end
            end
            this.parameter = ip.Results.param;
 		end
        function [m,ids,sess] = itsMetric(this)            
            m    = this.itsMapValues;
            ids  = this.itsMapKeys;
            sess = this.dirTool.dns;
        end
        function [m,ids,sess] = itsMetricIndex(this)            
            m_ref = this.funOfCells(@mean, this.itsMapValues);
            m     = this.itsMapValuesIndexed(m_ref);
            ids   = this.itsMapKeys; 
            sess  = this.dirTool.dns;
        end
        function m    = itsMapValues(this)
            m = cell(1, this.dirTool.length);
            for d = 1:this.dirTool.length
                m{d} = this.brains{d}.itsMapValues;
            end
        end
        function m    = itsMapValuesIndexed(this, m_ref)   
            m = cell(1, this.dirTool.length);      
            for d = 1:this.dirTool.length   
                m{d} = (this.brains{d}.itsMapValues - m_ref)./m_ref;
            end
        end
        function [m,ids] = itsFunOfMetric(this, h)
            assert(isa(h, 'function_handle'));
            m    = this.funOfCells(h, this.itsMapValues);
            mlsurfer.Cohort.assertIdentifiersEqual(this.itsMapKeys);
            ids  = this.itsMapKeys{1};
        end
        function m    = funOfCells(~, h, values)
            import mlsurfer.*;
            assert(isa(h, 'function_handle'));
            mmat = cell2mat(values);
            m    = zeros(size(mmat,1),1);
            for parc = 1:size(mmat,1)
                m(parc) = h(mmat(parc,:));
            end
        end
        function ids  = itsMapKeys(this)
            ids = cell(1, this.dirTool.length);
            for d = 1:this.dirTool.length
                ids{d} = this.brains{d}.itsMapKeys;
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        registry_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

