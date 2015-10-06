classdef Test_PETSegstatsBuilder < matlab.unittest.TestCase 
	%% TEST_PETSEGSTATSBUILDER  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_PETSegstatsBuilder)
 	%          >> result  = run(mlsurfer_unittest.Test_PETSegstatsBuilder, 'test_dt')
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
        sessionPath = '/Volumes/InnominateHD3/cvl/np755/mm01-020_p7377_2009feb5' 
 	end 

	methods (Test) 
        function test_ctor(this)
            this.assertTrue(isa(this.testObj, 'mlsurfer.PETSegstatsBuilder'));
        end
 	end 

 	methods (TestClassSetup) 
 		function setupPETSegstatsBuilder(this) 
            this.testObj = mlsurfer.PETSegstatsBuilder('SessionPath', this.sessionPath);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

