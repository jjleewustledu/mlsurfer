classdef Test_MoyamoyaSegstatsBuilder < matlab.unittest.TestCase
	%% TEST_MOYAMOYASEGSTATSBUILDER 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_MoyamoyaSegstatsBuilder)
 	%          >> result  = run(mlsurfer_unittest.Test_MoyamoyaSegstatsBuilder, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 13-Oct-2015 22:44:24
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

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
 		function setupMoyamoyaSegstatsBuilder(this)
 			import mlsurfer.*;
 			this.testObj = MoyamoyaSegstatsBuilder;
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

