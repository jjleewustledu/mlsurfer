classdef Test_SurferFacade < matlab.unittest.TestCase
	%% TEST_SURFERFACADE 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferFacade)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferFacade, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 30-Dec-2015 17:40:39
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		registry
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
		function setupSurferFacade(this)
 			import mlsurfer.*;
 			this.testObj = SurferFacade;
 		end
	end

 	methods (TestMethodSetup)
		function setupSurferFacadeTest(this)
 		end
	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

