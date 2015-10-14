classdef Test_SurferRegistry < matlab.unittest.TestCase
	%% TEST_SURFERREGISTRY 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferRegistry)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferRegistry, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 08-Oct-2015 11:26:16
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
        testVal
 	end

	methods (Test)
 		function test_instance(this)
 			import mlsurfer.*;
            this.assertEqual(SurferRegistry.instance.t1Prefix, this.testVal);
            inst = SurferRegistry.instance;
            this.assertEqual(inst.t1Prefix, this.testVal);
 		end
 		function test_changedValue(this)
 			import mlsurfer.*;   
            inst = SurferRegistry.instance;
            inst.t1Prefix = 'new_t1_fileprefix';
            this.assertEqual(inst.t1Prefix, 'new_t1_fileprefix');            
            this.assertEqual(SurferRegistry.instance.t1Prefix, 'new_t1_fileprefix');
        end
        function test_initialize(this)
 			import mlsurfer.*;   
            inst = SurferRegistry.instance;
            inst.t1Prefix = 'garbage';
            SurferRegistry.instance('initialize');
            this.assertEqual(SurferRegistry.instance.t1Prefix, this.testVal);
        end
 	end

 	methods (TestClassSetup)
 		function setupSurferRegistry(this)
            import mlsurfer.*;
            this.testVal = SurferRegistry.instance.t1Prefix;
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

