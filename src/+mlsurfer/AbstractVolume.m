classdef AbstractVolume < mlsurfer.AbstractSurferProduct
	%% ABSTRACTVOLUME  

	%  $Revision$
 	%  was created 27-Nov-2017 17:47:05 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)
        numeric
 		imaging
 	end

	methods 
        
        function this = prepareProduct(this, varargin)
            this = this.factory_.makeVolume(varargin{:});
        end
        function this = selectRegion(this, varargin)
        end
        function this = selectSegment(this, varargin)
        end
        function this = selectVoxel(this, varargin)
        end
		  
 		function this = AbstractVolume(varargin)
 			%% ABSTRACTVOLUME
 			%  Usage:  this = AbstractVolume()

 			this = this@mlsurfer.AbstractSurferProduct(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

