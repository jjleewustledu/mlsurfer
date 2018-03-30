classdef AbstractGroup < mlsurfer.AbstractSurferProduct
	%% ABSTRACTGROUP  

	%  $Revision$
 	%  was created 27-Nov-2017 18:12:42 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		model
 	end

	methods 
        
        function this = prepareProduct(this, varargin)
            this = this.factory_.makeGroup(varargin{:});
        end
        
 		function this = AbstractGroup(varargin)
 			%% ABSTRACTGROUP
 			%  Usage:  this = AbstractGroup()

 			this = this@mlsurfer.AbstractSurferProduct(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

