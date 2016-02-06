classdef Test_PerfusionSegstatsBuilder < MyTestCase 
	%% Test_PerfusionSegstatsBuilder  

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
        STATS_FILES = { '' '' };
    end 
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        function test_perfComposite(this)
            imcps = this.pssb.perfComposite.composite;
            for s = 1:length(imcps)
                assert(lexist(imcps{s}.fqfilename, 'file'));
            end
        end        
        function test_fsanatomicalStats(this)
            filenames = this.pssb.fsanatomicalStats;
            for f = 1:length(filenames)
                try
                    strcmp( ...
                        this.expectedFsanatomicalFilename(this.pssb.perfComposite.composite.get(f).fileprefix), ...
                        filenames.get(f));
                catch ME
                    handwarning(ME);
                end
            end
        end
 		function this = Test_PerfusionSegstatsBuilder(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            this.pssb = mlsurfer.PerfusionSegstatsBuilder('SessionPath', this.sessionPath);
        end 
    end
    
    methods (Access = 'private')
        function fn = expectedFsanatomicalFilename(this, fp) % fp -> 'S0'
            fn = fullfile(this.fslPath, ['lh_' fp '_on_t1_default_on_fsanatomical.stats']);
        end
        
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

