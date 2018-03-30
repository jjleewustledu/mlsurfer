classdef Test_Brain < matlab.unittest.TestCase
	%% TEST_BRAIN 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Brain)
 	%          >> result  = run(mlsurfer_unittest.Test_Brain, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 08-Oct-2015 16:00:45
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		registry
 		testObj
 	end

	methods (Test) 		
 		function test_metricThickness(this) 
 			import mlsurfer.*;
            [dble,ids] = Brain.metric(this.registry.testSubjectPath, 'thickness');
            this.assertEqual(dble(51),   2.4);
            this.assertEqual(ids(51),    12101);            
            this.assertEqual(size(dble), [100 1]);
            this.assertEqual(size(ids),  [100 1]);
 		end
 		function test_metricIndexThickness(this) 
 			import mlsurfer.*;
            dble0      = Cohort.meanMetric(       this.registry.subjectsDir,     'thickness');
            [dble,ids] = Brain.metricIndex(dble0, this.registry.testSubjectPath, 'thickness');
            this.assertEqual(dble(51),  -0.00954686769, 'RelTol', 1e-8);
            this.assertEqual(ids(51),    12101);            
            this.assertEqual(size(dble), [100 1]);
            this.assertEqual(size(ids),  [100 1]);
 		end
 	end

 	methods (TestClassSetup)
 		function setupBrain(this)
 			import mlsurfer.*; 			
            this.registry = SurferRegistry.instance;
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

