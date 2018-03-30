classdef Test_ADCSegstatsBuilder < MyTestCase 
	%% Test_ADCSegstatsBuilder  

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
        assb
    end
	
	properties (Constant)
        STATS_FILES = { 'lh_adc_default_on_t1_default_on_fsanatomical.stats' ...
                        'rh_adc_default_on_t1_default_on_fsanatomical.stats' };
    end 
    
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        function test_fsanatomicalStats(this)
            filenames = this.assb.fsanatomicalStats;
            for f = 1:length(filenames)
                assertEqual(fullfile(this.fslPath, this.STATS_FILES{f}), filenames.get(f));
            end
        end
 		function this = Test_ADCSegstatsBuilder(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            this.assb = mlsurfer.ADCSegstatsBuilder('SessionPath', this.sessionPath);
        end         
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

