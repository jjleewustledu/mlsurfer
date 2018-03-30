classdef Test_Hemisphere < matlab.unittest.TestCase
	%% TEST_HEMISPHERE 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Hemisphere)
 	%          >> result  = run(mlsurfer_unittest.Test_Hemisphere, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 07-Oct-2015 14:14:33
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
        registry
 	end

	methods (Test) 		
 		function test_metricThickness(this) 
 			import mlsurfer.*;
            [dble,ids] = Hemisphere.metric(this.registry.testSubjectPath, 'lh', 'thickness');
            this.assertEqual(dble(1),    2.292);
            this.assertEqual(ids(1),     11101);            
            this.assertEqual(size(dble), [50 1]);
            this.assertEqual(size(ids),  [50 1]);
 		end 
 		function test_metricMeancurv(this) 
 			import mlsurfer.*;
            [dble,ids] = Hemisphere.metric(this.registry.testSubjectPath, 'rh', 'meancurv');
            this.assertEqual(dble(1),    0.184);
            this.assertEqual(ids(1),     12101);            
            this.assertEqual(size(dble), [50 1]);
            this.assertEqual(size(ids),  [50 1]);
 		end 
 	end

 	methods (TestClassSetup)
 		function setupHemisphere(this)
            import mlsurfer.*;
            this.registry = SurferRegistry.instance;
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

