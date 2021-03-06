classdef SurferDirectorComponent  
	%% SURFERDIRECTORCOMPONENT defines the interface for objects that can have responsibilities
    %  added to them dynamically.  It participates in a decorator design pattern.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties (Abstract)
        builder
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

