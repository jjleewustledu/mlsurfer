classdef ColorLUTInterface  
	%% COLORLUTINTERFACE   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	     
    properties (Abstract)
        colorLUT % cell array of strings:   index label_name R G B A
    end
    
    methods (Abstract)
        idx = label2index(this, lbl)
        lbl = index2label(this, idx)
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

