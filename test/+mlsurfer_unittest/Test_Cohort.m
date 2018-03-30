classdef Test_Cohort < matlab.unittest.TestCase
	%% TEST_COHORT 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Cohort)
 	%          >> result  = run(mlsurfer_unittest.Test_Cohort, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 08-Oct-2015 17:07:46
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		registry
 		testObj
        dt
 	end

	methods (Test)
        function test_parcellationsAverage(this)            
 			import mlsurfer.*;
            [dble,~,sess] = Cohort.metric(this.registry.subjectsDir, 'thickness');
            paver = Cohort.parcellationsAverage(dble, sess);
            pkeys = paver.keys;
            this.assertTrue(isa(paver, 'containers.Map'));
            this.assertEqual(paver.length, length(sess));
            this.assertEqual(paver(pkeys{10}), 2.750430000000000, 'RelTol', 1e-8);
        end
 		function test_metricIndexThickness(this) 
 			import mlsurfer.*;
            [dble,ids,sess] = Cohort.metricIndex(this.registry.subjectsDir, 'thickness');
            this.assertTrue(iscell(dble));
            this.assertTrue(iscell(ids));
            this.assertTrue(iscell(sess));
            this.assertEqual(length(dble), this.dt.length);
            this.assertEqual(length(ids),  this.dt.length);
            this.assertEqual(length(sess), this.dt.length);
            
            this.assertEqual(dble{10}(51),  -0.00954686769, 'RelTol', 1e-8);
            this.assertEqual(ids{10}(51),    12101);            
            this.assertEqual(size(dble{10}), [100 1]);
            this.assertEqual(size(ids{10}),  [100 1]);
 		end
 		function test_metricThickness(this) 
 			import mlsurfer.*;
            [dble,ids,sess] = Cohort.metric(this.registry.subjectsDir, 'thickness');
            this.assertTrue(iscell(dble));
            this.assertTrue(iscell(ids));
            this.assertTrue(iscell(sess));
            this.assertEqual(length(dble), this.dt.length);
            this.assertEqual(length(ids),  this.dt.length);
            this.assertEqual(length(sess), this.dt.length);
            
            this.assertEqual(dble{10}(51),   2.4);
            this.assertEqual(ids{10}(51),    12101);            
            this.assertEqual(size(dble{10}), [100 1]);
            this.assertEqual(size(ids{10}),  [100 1]);
        end        
 		function test_meanMetricThickness(this) 
 			import mlsurfer.*;
            [dble,ids] = Cohort.meanMetric(this.registry.subjectsDir, 'thickness');
            this.assertEqual(dble(51),   2.423133333333332, 'RelTol', 1e-8);
            this.assertEqual(ids(51),    12101);            
            this.assertEqual(size(dble), [100 1]);
            this.assertEqual(size(ids),  [100 1]);
 		end
 	end

 	methods (TestClassSetup)
 		function setupCohort(this)
 			import mlsurfer.*; 			
            this.registry = SurferRegistry.instance;
            cd(this.registry.subjectsDir);
            this.dt = mlsystem.DirTools('mm0*');
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

