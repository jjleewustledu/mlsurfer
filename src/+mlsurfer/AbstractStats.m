classdef AbstractStats < mlsurfer.AbstractSurferProduct
	%% ABSTRACTSTATS  

	%  $Revision$
 	%  was created 27-Nov-2017 17:47:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)
        segids
        segnames
        segstats
 		thickness
 	end

	methods 
        
        function this = prepareProduct(this, varargin)
            this = this.factory_.makeStats(varargin{:});
        end
        
 		function this = AbstractStats(varargin)
 			%% ABSTRACTSTATS
 			%  Usage:  this = AbstractStats()

 			this = this@mlsurfer.AbstractSurferProduct(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

