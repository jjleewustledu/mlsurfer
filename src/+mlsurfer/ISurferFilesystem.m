classdef (Abstract) ISurferFilesystem  
	%% ISURFERFILESYSTEM   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$  	

	properties (Abstract)   
        fslPath
        labelPath
        mmnum
        mriPath
        perfPath
        pnum
        sessionId
        sessionPath
        sessionRegexp 
        statsPath
        studyPath
        surfPath
        
        datSuffix
        statsSuffix
        t1Prefix
        t2Prefix
    end 
    
    methods (Abstract)
        pialNative_fqfn(this)
        segstats_fqfn(this)
        isaSessionPath(this) % boolean check of conformance to expected form of the path to the working session
        sessionPathParts(this)       % check of conformance to expected form of the path to the working session
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

