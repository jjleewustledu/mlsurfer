classdef CohortCerebOefnq 
	%% COHORTCEREBOEFNQ is an ad hoc class that provides cohort cerebellar oefnq data for interoperability 
    %  with mlsurfer.Cohort.

	%  $Revision$
 	%  was created 12-Oct-2015 13:59:27
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	    
    properties (Constant)
        cerebellar_stats_filename = '/Volumes/SeagateBP4/cvl/np755/cerebellar_oefnq_statistics_2015oct12.mat'
    end
    
	properties
 		dirTool
        brains
        parameter = 'oefnq_default_161616fwhh'
 	end

	methods 		  
 		function this = CohortCerebOefnq(subjectsDir)
 			%% COHORTCEREBOEFNQ
 			%  Usage:  this = CohortCerebOefnq()

            assert(strcmp(subjectsDir, fileparts(this.cerebellar_stats_filename)));
 			load(this.cerebellar_stats_filename);
            this.dirTool = dt;
            this.means_ = means;
            this.stds_ = stds;
        end
        function [m,ids,sess] = itsMetric(this)
            m    = num2cell(this.means_);
            ids  = [];
            sess = this.dirTool.dns;
        end
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        means_
        stds_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

