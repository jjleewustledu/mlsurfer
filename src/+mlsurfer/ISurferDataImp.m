classdef (Abstract) ISurferDataImp 
	%% ISURFERDATAIMP  

	%  $Revision$
 	%  was created 09-Oct-2015 11:42:37
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties (Abstract)
        parameter
 		surferFilesystem
    end

    methods (Static, Abstract)
        metric
    end
    
	methods (Abstract)
        itsMapValues(this)
        itsMapKeys(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

