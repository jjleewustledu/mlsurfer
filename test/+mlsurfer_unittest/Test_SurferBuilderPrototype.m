classdef Test_SurferBuilderPrototype < matlab.unittest.TestCase 
	%% TEST_SURFERBUILDERPROTOTYPE  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferBuilderPrototype)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferBuilderPrototype, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 

	properties 
        sessionFold = 'mm01-020_p7377_2009feb5'
 		testObj 
    end 
    
    properties (Dependent)
        sessionPth
    end
    
    methods % GET
        function x = get.sessionPth(this)
            x = fullfile(getenv('NP755'), this.sessionFold);
        end
    end

	methods (Test) 
 		function test_mask(this)
            this.assertTrue(isa(this.testObj.mask, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.mask.fileprefix, 'bt1_default_mask');
 		end 
 		function test_orig(this)
            this.assertTrue(isa(this.testObj.orig, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.orig.fileprefix, 'orig');
 		end 
 		function test_structural(this)
            this.assertTrue(isa(this.testObj.structural, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.structural.fileprefix, 'bt1_default_restore');
 		end 
 		function test_t1(this)
            this.assertTrue(isa(this.testObj.t1, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.t1.fileprefix, mlsurfer.SurferFilesystem.T1_FILEPREFIX);
 		end 
 		function test_t2(this)
            this.assertTrue(isa(this.testObj.t2, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.t2.fileprefix, 't2_default');
        end 
        function test_paths(this)            
            this.assertEqual(this.testObj.fslPath,  fullfile(this.sessionPth, 'fsl', ''));
            this.assertEqual(this.testObj.mriPath,  fullfile(this.sessionPth, 'mri', ''));
            this.assertEqual(this.testObj.perfPath, fullfile(this.sessionPth, 'perfusion_4dfp', ''));
            this.assertEqual(this.testObj.surfPath, fullfile(this.sessionPth, 'surf', ''));
        end
 	end 

 	methods (TestClassSetup) 
 		function setupSurferBuilderPrototype(this) 
            cd(this.sessionPth);
 			this.testObj = mlsurfer.SurferBuilderPrototype('sessionPath', this.sessionPth); 
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

