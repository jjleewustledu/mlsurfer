classdef GroupParcellations  
	%% GROUPPARCELLATIONS   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 
 	 
    properties
    end
    
	properties 
        theMap
        theDirTools
 	end 

	methods 
		  
 		function this = GroupParcellations(varargin) 
 			%% GROUPPARCELLATIONS 
 			%  Usage:  this = GroupParcellations() 
            
            ip = inputParser;
            addOptional(ip, 'StudyPath', pwd, @(x) lexist(x,'dir'));
            parse(ip, varargin{:});
            
            import mlsurfer.*;
            cd(ip.Results.StudyPath);
            dt = mlsystem.DirTools('mm0*');
            assert(dt.length > 0);
            this.theMap = containers.Map;
            for d = 1:dt.length
                aParc = Parcellations('SessionPath', dt.fqdns{d});
                lh = aParc.segidentifiedStatsMap('lh', 'thickness', 'all_aca_mca');
                rh = aParc.segidentifiedStatsMap('rh', 'thickness', 'all_aca_mca');
                this.theMap(dt.fqdns{d}) = struct('lh', lh, 'rh', rh);
            end
            this.theDirTools = dt;
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

