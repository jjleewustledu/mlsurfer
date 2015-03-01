classdef SurferDirectorComponent  
	%% SURFERDIRECTORCOMPONENT   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties (Abstract)
        surferBuilder
        product
        referenceImage
        dat        
 	end 

	methods (Abstract)
        reconAll(this)
        makeRoi(this)
        makeSegstats(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

