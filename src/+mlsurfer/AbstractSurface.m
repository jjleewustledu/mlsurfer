classdef AbstractSurface < mlsurfer.AbstractSurferProduct
	%% ABSTRACTSURFACE  

	%  $Revision$
 	%  was created 27-Nov-2017 17:47:14 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
        
        function this = prepareProduct(this, varargin)
            this = this.factory_.makeSurface(varargin{:});
        end
		  
 		function this = AbstractSurface(varargin)
 			%% ABSTRACTSURFACE
 			%  Usage:  this = AbstractSurface()

 			this = this@mlsurfer.AbstractSurferProduct(varargin{:});
            this = this.factory_.makeSurface(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

