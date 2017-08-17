classdef BrainmaskBuilder < mlrois.RoisBuilder
	%% BRAINMASK  

	%  $Revision$
 	%  was created 31-May-2017 14:39:34 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.2.0.538062 (R2017a) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
		  
 		function this = BrainmaskBuilder(varargin)
 			%% BRAINMASK
            %  @param named 'logger' is an mlpipeline.AbstractLogger.
            %  @param named 'product' is the initial state of the product to build.
 			%  @param named 'sessionData' is an 'mlpipeline.ISessionData'.

 			this = this@mlrois.RoisBuilder(varargin{:});
            this.product_ = mlfourd.ImagingContext(this.sessionData.brainmask);
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

