classdef Test_SurferDirector < matlab.unittest.TestCase 
	%% TEST_SURFERDIRECTOR  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferDirector)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferDirector, 'test_dt')
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
 		function setupSurferDirector(this) 
 			this.testObj = mlsurfer.SurferDirector; 
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

