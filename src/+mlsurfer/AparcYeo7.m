classdef AparcYeo7 < mlsurfer.AparcAsegNaming & mlrois.IRois
	%% APARCYEO7 describes parcellations described in 
    %  Yeo BTT, et al. (2011) The organization of the human cerebral cortex estimated by intrinsic functional connectivity.
    %  J Neurophysiol 106(3):1125?1165.
    %  All public properties are region names.

	%  $Revision$
 	%  was created 02-Mar-2017 13:50:02 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties 		
        
        % assumed per fig. 12 of Yeo 2011
        
        visual           = 1
        somatomotor      = 2
        dorsalAttention  = 3
        ventralAttention = 4
        limbic           = 5
        frontoparietal   = 6
        default          = 7
 	end

	methods 
		  
 		function this = AparcYeo7(varargin)
 			%% APARCYEO7
 			%  Usage:  this = AparcYeo7()

 			this = this@mlsurfer.AparcAsegNaming(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

