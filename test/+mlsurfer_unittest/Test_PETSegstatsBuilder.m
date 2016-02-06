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
    end
    
    properties (Dependent)
        sessionPath 
    end 
    
    methods %% GET
        function g = get.sessionPath(~)
            g = fullfile(getenv('MLUNIT_TEST_PATH'), 'cvl', 'np755', 'mm01-020_p7377_2009feb5', '');
        end
    end

	methods (Test) 
 		function test_hoMeanvol(this)
            this.assertTrue(isa(this.testObj.hoMeanvol, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.hoMeanvol.fileprefix, 'ho_meanvol_default_161616fwhh');
            this.assertEqual(   this.testObj.hoMeanvol.stateTypeclass, 'mlfourd.FilenameState');
            this.assertEqual(   this.testObj.hoMeanvol.mgh.fileprefix, 'ho_meanvol_default_161616fwhh');
 		end 
 		function test_oc(this)
            this.assertTrue(isa(this.testObj.oc, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.oc.fileprefix, 'oc_default_131315fwhh');
            this.assertEqual(   this.testObj.oc.stateTypeclass, 'mlfourd.FilenameState');
            this.assertEqual(   this.testObj.oc.mgh.fileprefix, 'oc_default_131315fwhh');
 		end 
 		function test_ooMeanvol(this)
            this.assertTrue(isa(this.testObj.ooMeanvol, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.ooMeanvol.fileprefix, 'oo_meanvol_default_161616fwhh');
            this.assertEqual(   this.testObj.ooMeanvol.stateTypeclass, 'mlfourd.FilenameState');
            this.assertEqual(   this.testObj.ooMeanvol.mgh.fileprefix, 'oo_meanvol_default_161616fwhh');
 		end 
 		function test_tr(this)
            this.assertTrue(isa(this.testObj.tr, 'mlfourd.ImagingContext'));
            this.assertEqual(   this.testObj.tr.fileprefix, 'tr_default');
            this.assertEqual(   this.testObj.tr.stateTypeclass, 'mlfourd.FilenameState');
            this.assertEqual(   this.testObj.tr.mgh.fileprefix, 'tr_default');
 		end 
        function test_paths(this)            
            this.assertEqual(this.testObj.fslPath,  fullfile(this.sessionPath, 'fsl', ''));
            this.assertEqual(this.testObj.mriPath,  fullfile(this.sessionPath, 'mri', ''));
            this.assertEqual(this.testObj.perfPath, fullfile(this.sessionPath, 'perfusion_4dfp', ''));
            this.assertEqual(this.testObj.surfPath, fullfile(this.sessionPath, 'surf', ''));
        end
        function test_appendOefToProduct(this)
            this.testObj = this.testObj.appendOefToProduct;
            this.verifyEqual(this.testObj.product.stateTypeclass, 'mlfourd.ImagingComposite');
            this.verifyEqual(this.testObj.product.length, 2);
        end
 	end 

 	methods (TestMethodSetup) 
 		function setupPETSegstatsBuilderTest(this) 
            cd(this.sessionPath);
            this.testObj = mlsurfer.PETSegstatsBuilder('SessionPath', this.sessionPath);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

