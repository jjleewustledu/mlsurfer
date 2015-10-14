classdef Test_SurferVisitor < mlsurfer_unittest.Test_mlsurfer
	%% TEST_SURFERVISITOR 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferVisitor)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferVisitor, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 07-Oct-2015 19:25:17
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
 		testObj
        bldr
        segOnNative
        surfOnNative
 	end

	methods (Test) 		
        function test_viewSurfaceOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'rawavg.mgz'));
            if (this.showViewers)
                this.testObj.viewSurfaceOnNativeAnatomy(this.bldr, 'lh');
            end
        end
        function test_viewSegmentationOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'aseg.mgz'));
            if (this.showViewers)
                this.testObj.viewSegmentationOnNativeAnatomy(this.bldr);
            end
        end        
        function test_visitSegmentationOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'aseg.mgz'));
            b = this.testObj.visitSegmentationOnNativeAnatomy(this.bldr);
            this.assertEntropies(1.030003822260182, b.product);
        end
 		function test_visitImageOnNativeAnatomy(this) 
            b = this.testObj.visitImageOnNativeAnatomy(this.bldr);
            this.assertEntropies(2.017144497385614, b.product);
        end 
        function test_visitRoiVol2surf(this)
            this.bldr.dat =  ...
                fullfile(this.surfPath, 'bt1_default_on_fsaverage.dat');  
            this.bldr = this.testObj.visitFslregister(this.bldr);
            b         = this.testObj.visitRoiVol2surf(this.bldr, 'lh');
            this.assertEntropies(0, b.product);
        end
        function test_visitSurf2surf(this)
        end
        function test_visitRoiSegstats(this)
        end
 	end

 	methods (TestClassSetup)
 		function setupSurferVisitor(this)
            import mlsurfer.* mlfourd.*;
            this.bldr = SurferBuilderPrototype( ...
                'sessionPath',    this.sessionPath, ...
                'mask',           this.maskCntxt, ...
                'product',        ImagingContext.load(fullfile(this.mriPath, 'brain.mgz')), ...
                'referenceImage', ImagingContext.load(fullfile(this.mriPath, 'rawavg.mgz')), ...
                'roi',            ImagingContext.load(fullfile(this.fslPath, 'bt1_default_mask.nii.gz')), ...
                'segmentation',   ImagingContext.load(fullfile(this.mriPath, 'aseg_on_rawavg.mgz')));
            this.testObj = SurferVisitor('sessionPath', this.sessionPath);
 		end
 	end

 	methods (TestClassTeardown)
 	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

