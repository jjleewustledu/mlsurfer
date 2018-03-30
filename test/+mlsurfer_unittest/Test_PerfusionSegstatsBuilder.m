classdef Test_PerfusionSegstatsBuilder < matlab.unittest.TestCase 
	%% TEST_PERFUSIONSEGSTATSBUILDER  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_PerfusionSegstatsBuilder)
 	%          >> result  = run(mlsurfer_unittest.Test_PerfusionSegstatsBuilder, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 

	properties 
 		testObj 
        sessionPth = '/Volumes/PassportStudio2/cvl/np755/mm01-020_p7377_2009feb5' 
 	end 

	methods (Test) 
 		function test_afun(this) 
 			import mlsurfer.*; 
 			this.assumeEqual(1,1); 
 			this.verifyEqual(1,1); 
 			this.assertEqual(1,1); 
 		end 
 	end 

 	methods (TestClassSetup) 
 		function setupPerfusionSegstatsBuilder(this) 
            cd(this.sessionPth);
            this.testObj = mlsurfer.PerfusionSegstatsBuilder('SessionPath', this.sessionPth);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

