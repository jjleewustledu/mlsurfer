classdef Test_PETSegstatsBuilder < MyTestCase 
	%% TEST_PETSEGSTATSBUILDER  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlpet.Test_PETAlignmentDirector % in . or the matlab path 
	%          >> runtests mlpet.Test_PETAlignmentDirector:test_nameoffunc 
	%          >> runtests(mlpet.Test_PETAlignmentDirector, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
    properties
        pssb
    end
	
	properties (Constant)
        STATS_FILES = { 'lh_oc_default_131315fwhh_on_t1_default_normByDose_on_fsanatomical.stats' ...
                        'rh_oc_default_131315fwhh_on_t1_default_normByDose_on_fsanatomical.stats' ...
                       ['lh_' mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'] ...
                       ['rh_' mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'] ...
                       ['lh_' mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'] ...
                       ['rh_' mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'] };
    end 
    
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        function test_fsanatomicalStats(this)
            filenames = this.pssb.fsanatomicalStats;
            for f = 1:length(filenames)
                try
                    assertEqual(fullfile(this.fslPath, this.STATS_FILES{f}), filenames.get(f));
                catch ME
                    handwarning(ME);
                end
            end
        end
 		function this = Test_PETSegstatsBuilder(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            this.pssb = mlsurfer.PETSegstatsBuilder('SessionPath', this.sessionPath);
        end         
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

