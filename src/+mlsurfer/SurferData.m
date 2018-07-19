classdef SurferData 
	%% SURFERDATA is the abstraction to a bridge design pattern.  It pertains to Freesurfer data that has already
    %  been processed and is stored in text-files or image-files.  Implementor classes must inherit SurferDataImp
    %  and then provide implementations that are specific to the stored data.  
    %  See also:  SurferDataImp, Hemisphere, Session, Territories for implementations of the bridge.
    %  See also:  mlanalysis package for clients to the SurferData bridge.

	%  $Revision$
 	%  was created 07-Oct-2015 13:06:39
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
    
    properties 
        subjectsDir
        parameter = 'thickness'
        territory = 'all'
        statistic = 'mean'
    end
    
	properties (Dependent)
        itsImplementation
    end 
    
    methods %% GET
        function x = get.itsImplementation(this)
            assert(~isempty(this.itsImplementation_));
            x = this.itsImplementation_;
        end
    end
    
	methods
        function [m,ids,this] = brain(this, varargin)
            import mlsurfer.*;
            ip = inputParser;
            addParameter(ip, 'subjectsDir',      this.subjectsDir, @(x) lexist(x,'dir'));
            addParameter(ip, 'Parameter', this.parameter,   @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', this.territory,   @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, varargin{:});
            
            this.itsImplementation_ = Brain(ip.Results.Path, ...
                                      ip.Results.Parameter, ...
                                     'Territory', ip.Results.Territory);
            [m,ids] = this.itsImplementation_.itsMetric;
        end
        function m = brainOefratio(this)
            ooCereb = this.brain('subjectsDir',      this.subjectsDir, ...
                                 'Parameter', 'oo_sumt_737353fwhh', ...
                                 'Territory', 'cereb'); 
            hoCereb = this.brain('subjectsDir',      this.subjectsDir, ...
                                 'Parameter', 'ho_sumt_737353fwhh', ...
                                 'Territory', 'cereb'); 
            
            ooCortex = this.brain('subjectsDir',      this.subjectsDir, ...
                                  'Parameter', 'oo_sumt_737353fwhh', ...
                                  'Territory', this.territory);  
            hoCortex = this.brain('subjectsDir',      this.subjectsDir, ...
                                  'Parameter', 'ho_sumt_737353fwhh', ...
                                  'Territory', this.territory);
            m = (ooCortex/mean(ooCereb)) ./ (hoCortex/mean(hoCereb));
        end
        function [m,ids,sess,this] = cohort(this, varargin)
            import mlsurfer.*;
            ip = inputParser;
            addParameter(ip, 'subjectsDir',      this.subjectsDir, @(x) lexist(x,'dir'));
            addParameter(ip, 'Parameter', this.parameter,   @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', this.territory,   @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, varargin{:});
            
            this.itsImplementation_ = Cohort(ip.Results.Path, ...
                                      ip.Results.Parameter, ...
                                     'Territory', ip.Results.Territory);
            [m,ids,sess] = this.itsImplementation_.itsMetric;
        end
        function [m,ids,sess,this] = cohortIndex(this, varargin)
            import mlsurfer.*;
            ip = inputParser;
            addParameter(ip, 'subjectsDir',      this.subjectsDir, @(x) lexist(x,'dir'));
            addParameter(ip, 'Parameter', this.parameter,   @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', this.territory,   @(x) lstrfind(x, Parcellations.TERRITORIES));
            parse(ip, varargin{:});
            
            this.itsImplementation_ = Cohort(ip.Results.Path, ...
                                      ip.Results.Parameter, ...
                                     'Territory', ip.Results.Territory);
            [m,ids,sess] = this.itsImplementation_.itsMetricIndex;
        end
        
        function [m,ids,sess,this] = cohortCerebOefnq(this, varargin)
            import mlsurfer.*;
            ip = inputParser;
            addParameter(ip, 'subjectsDir', this.subjectsDir, @(x) lexist(x,'dir'));
            parse(ip, varargin{:});
            
            this.itsImplementation_ = CohortCerebOefnq(ip.Results.Path);
            [m,ids,sess] = this.itsImplementation_.itsMetric;
        end
                
        function [m,ids,sess] = cohortDsa(this)
            [m,ids,sess] = this.cohort('subjectsDir',      this.subjectsDir, ...
                                       'Parameter', 'dsa', ...
                                       'Territory', this.territory);  
        end
        function [m,ids,sess] = cohortThickness(this)
            [m,ids,sess] = this.cohort('subjectsDir',      this.subjectsDir, ...
                                       'Parameter', 'thickness', ...
                                       'Territory', this.territory);  
        end
        function [m,ids,sess] = cohortThicknessIndex(this)
            [m,ids,sess] = this.cohortIndex('subjectsDir',      this.subjectsDir, ...
                                            'Parameter', 'thickness', ...
                                            'Territory', this.territory);          
        end        
        function [m,ids,sess] = cohortOefratio(this)
            ooCereb = this.cohort('subjectsDir',      this.subjectsDir, ...
                                  'Parameter', 'oo_sumt_737353fwhh', ...
                                  'Territory', 'cereb'); 
            hoCereb = this.cohort('subjectsDir',      this.subjectsDir, ...
                                  'Parameter', 'ho_sumt_737353fwhh', ...
                                  'Territory', 'cereb'); 
            
            ooCortex = this.cohort('subjectsDir',      this.subjectsDir, ...
                                   'Parameter', 'oo_sumt_737353fwhh', ...
                                   'Territory', this.territory);  
            [hoCortex,ids,sess] = this.cohort('subjectsDir',      this.subjectsDir, ...
                                   'Parameter', 'ho_sumt_737353fwhh', ...
                                   'Territory', this.territory);          
            for b = 1:length(ooCortex)
                m{b} = (ooCortex{b}/mean(ooCereb{b})) ./ (hoCortex{b}/mean(hoCereb{b}));
            end
        end
        
 		function this = SurferData(varargin) 
 			%% SURFERDATA 
 			%  Usage:  this = SurferData(parameter_name, parameter_value)
            %                            ^ 'SubjectsDir', 'Parameter', 'Territory'
            
            import mlsurfer.*;
            ip = inputParser;   
            ip.KeepUnmatched = true;
            addParameter(ip, 'subjectsDir', getenv('SUBJECTS_DIR'), @isdir);
            addParameter(ip, 'Parameter', this.parameter,   @(x) lstrfind(x, Parcellations.PARAMS_ALL));
            addParameter(ip, 'Territory', this.territory,   @(x) lstrfind(x, Parcellations.TERRITORIES));
            addParameter(ip, 'Statistic', this.statistic,   @(x) lstrfind(x, Parcellations.STATISTICS));
            parse(ip, varargin{:});            
            this.subjectsDir = ip.Results.subjectsDir;
            this.parameter   = ip.Results.Parameter;
            this.territory   = ip.Results.Territory;
            this.statistic   = ip.Results.Statistic;
 		end 
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        itsImplementation_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

