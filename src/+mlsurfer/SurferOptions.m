classdef SurferOptions < mlpipeline.AbstractOptions 
	%% SURFEROPTIONS   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
 		 help % Display this help. 
 	end 

	methods 
        function s        = updateOptionsString(this, s, fldname, val)            
            if (islogical(val))
                val = ' '; end
            if (isnumeric(val))
                val = num2str(val); end   
            if (lstrfind(fldname, this.PURE_ARGUMENT))
                s = this.updateOptionsStringWithPureArgument(s, val);
                return
            end            
            if (iscell(val))
                s = sprintf('%s --%s %s', s, this.underscores2dashes(fldname), cell2str(val, 'AsRow', true)); return; end
            s = sprintf(    '%s --%s %s', s, this.underscores2dashes(fldname), char(val));
        end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

