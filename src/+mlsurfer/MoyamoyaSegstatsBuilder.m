classdef MoyamoyaSegstatsBuilder < mlsurfer.SurferBuilderPrototype
	%% MOYAMOYASEGSTATSBUILDER  

	%  $Revision$
 	%  was created 13-Oct-2015 22:44:24
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		
 	end

	methods 
		  
 		function this = MoyamoyaSegstatsBuilder(varargin)
 			%% MOYAMOYASEGSTATSBUILDER
 			%  Usage:  this = MoyamoyaSegstatsBuilder([...]) 
            %                                         ^ cf. SurferBuilderPrototype

            this = this@mlsurfer.SurferBuilderPrototype(varargin{:});
            import mlsurfer.*;
            this.product_ = this.o15Composite;
            this.referenceImage = fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX)); 			
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

