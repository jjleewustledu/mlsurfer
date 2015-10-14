classdef Test_DatasetMap < matlab.unittest.TestCase 
	%% TEST_DATASETMAP  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_DatasetMap)
 	%          >> result  = run(mlsurfer_unittest.Test_DatasetMap, 'test_dt')
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
        sessionPath = '/Volumes/PassportStudio2/cvl/np755/mm01-020_p7377_2009feb5'
 	end 

	methods (Test) 
        function test_asMap(this)
 			import mlsurfer.*; 
            map = DatasetMap.asMap('thickness', 'SessionPath', this.sessionPath, 'Territory', 'all');
            this.assertEqual(map(11101), 2.292);
            this.assertEqual(map(12175), 2.811);
 		end 
 	end 

 	methods (TestClassSetup) 
 		function setupDatasetMap(this) 
 			this.testObj = mlsurfer.DatasetMap('thickness', 'SessionPath', this.sessionPath); 
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

