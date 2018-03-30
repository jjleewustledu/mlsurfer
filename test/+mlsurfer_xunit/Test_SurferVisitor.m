classdef Test_SurferVisitor < mlsurfer_xunit.Test_mlsurfer 
	%% TEST_BRAINEXTRACTIONVISITOR  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlfsl.Test_BrainExtractionVisitor % in . or the matlab path 
	%          >> runtests mlfsl.Test_BrainExtractionVisitor:test_nameoffunc 
	%          >> runtests(mlfsl.Test_BrainExtractionVisitor, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	
    properties
        bldr
        segOnNative
        surfOnNative
        vtor
    end
    
	methods 
        function test_viewSurfaceOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'rawavg.mgz'));
            if (this.showViewers)
                this.vtor.viewSurfaceOnNativeAnatomy(this.bldr, 'lh');
            end
        end
        function test_viewSegmentationOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'aseg.mgz'));
            if (this.showViewers)
                this.vtor.viewSegmentationOnNativeAnatomy(this.bldr);
            end
        end        
        function test_visitSegmentationOnNativeAnatomy(this)
            this.bldr.product = mlfourd.ImagingContext.load( ...
                fullfile(this.mriPath, 'aseg.mgz'));
            b = this.vtor.visitSegmentationOnNativeAnatomy(this.bldr);
            this.assertEntropies(1.030003822260182, b.product);
        end
 		function test_visitImageOnNativeAnatomy(this) 
            b = this.vtor.visitImageOnNativeAnatomy(this.bldr);
            this.assertEntropies(2.017144497385614, b.product);
        end 
        function test_visitRoiVol2surf(this)
            this.bldr.dat =  ...
                fullfile(this.surfPath, 'bt1_default_on_fsaverage.dat');  
            this.bldr = this.vtor.visitFslregister(this.bldr);
            b         = this.vtor.visitRoiVol2surf(this.bldr, 'lh');
            this.assertEntropies(0, b.product);
        end
        function test_visitSurf2surf(this)
        end
        function test_visitRoiSegstats(this)
        end
        
 		function this = Test_SurferVisitor(varargin) 
 			this = this@mlsurfer_xunit.Test_mlsurfer(varargin{:}); 
            import mlsurfer.* mlfourd.*;
            this.bldr = SurferBuilderPrototype( ...
                'sessionPath',    this.sessionPath, ...
                'mask',           this.maskCntxt, ...
                'product',        ImagingContext.load(fullfile(this.mriPath, 'brain.mgz')), ...
                'referenceImage', ImagingContext.load(fullfile(this.mriPath, 'rawavg.mgz')), ...
                'roi',            ImagingContext.load(fullfile(this.fslPath, 'bt1_default_mask.nii.gz')), ...
                'segmentation',   ImagingContext.load(fullfile(this.mriPath, 'aseg_on_rawavg.mgz')));
            this.vtor = SurferVisitor('sessionPath', this.sessionPath);
 		end 
    end 
        
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

