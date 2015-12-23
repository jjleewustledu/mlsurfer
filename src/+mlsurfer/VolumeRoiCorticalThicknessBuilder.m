classdef VolumeRoiCorticalThicknessBuilder < mlsurfer.SurferBuilderPrototype 
	%% VOLUMEROICORTICALTHICKNESSBUILDER 
    %  cf. http://surfer.nmr.mgh.harvard.edu/fswiki/VolumeRoiCorticalThickness 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 

    properties (Constant)        
        SESSION_PATTERN = 'p*' % for use by DirTool
    end
    
    properties (Dependent)
        bt1
        rawavg
        targetMriPath
        targetSurfPath
    end
    
    methods %% SET/GET
        function pth  = get.targetMriPath(this) 
            pth = fullfile(getenv('SUBJECTS_DIR'), this.targetId, 'mri', '');
        end
        function fn   = get.rawavg(this)
            fn = fullfile(this.mriPath, 'rawavg.mgz');
        end
        function pth  = get.targetSurfPath(this) 
            pth = fullfile(getenv('SUBJECTS_DIR'), this.targetId, 'surf', '');
        end
        function this = set.bt1(this, obj)
            this.bt1_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.bt1(this)
            assert(~isempty(this.bt1_));
            ic = this.bt1_;
        end
    end

    methods (Static)
        function ic = normalizePet(ic)
            assert(isa(ic, 'mlfourd.ImagingContext'));
            nii            = ic.nifti;
            nii.img        = double(prod(nii.size))*double(nii.img)/double(nii.dipsum);
            nii.fileprefix = [ic.fileprefix '_norm'];
            nii.save;
            ic = mlfourd.ImagingContext(nii);
        end
        function      buildThicknessForStudy(studyPth)
            assert(lexist(studyPth, 'dir'));
            cd(studyPth);
            dt = mlsystem.DirTools(mlsurfer.VolumeRoiCorticalThicknessBuilder.SESSION_PATTERN);
            for f = 1:dt.length
                vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder('SessionPath', dt.fqdns{f});
                vrctb.buildThickness;
            end
        end
    end
    
	methods 
 		function txt  = buildSegstats(this, hemi) 
            this.checkHemi(hemi);
            this.targetId = this.sessionId;            
            vtor = mlsurfer.SurferVisitor.createFromBuilder(this);            
            %vtor.confirmRoiOnAnatomy(this);
            
            vtor.fslregister2targetId(this);         
            vtor.confirmRoiOnTargetId(this);
            
            vtor.visitRoiVol2surf(this, hemi);
            vtor.confirmRoiOnTargetSurface(this);
            
            vtor.visitSurf2surf(this, hemi);
            vtor.visitRoiSegstats(this, hemi);  
            this.segstats = mlio.TextIO.textfileToString(this.segstats_fqfn(hemi, ['thickness_' this.targetId]));
            txt           = this.segstats;
 		end 
 		function txt  = buildAveragedSegstats(this, hemi)
            this.checkHemi(hemi);
            vtor = mlsurfer.SurferVisitor.createFromBuilder(this);            
            vtor.confirmRoiOnAnatomy(this);
            
            this.product = this.structural;
            vtor.tkregister2targetId(this);         
            vtor.confirmRoiOnTargetId(this);
            
            vtor.visitRoiVol2surf(this, hemi);
            vtor.confirmRoiOnTargetSurface(this);
            
            vtor.visitSurf2surf(this, hemi);
            vtor.visitRoiSegstats(this, hemi);  
            this.segstats = mlio.TextIO.textfileToString(this.segstats_fqfn(hemi, ['thickness_' this.targetId]));
            txt           = this.segstats;
        end 
        function this = buildPET(this)
            cd(this.fslPath);
            import mlfourd.* mlsurfer.* mlpet.*;
            this.product = ImagingContext.load( ...
                               fullfile(this.fslPath, [SurferFilesystem.T1_FILEPREFIX '.nii.gz']));
            this.dat     = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            vtor         = SurferVisitor;
            this         = vtor.visitBBRegisterNative(this);            
            
            this.product = ImagingContext.load( ...
                           fullfile(this.fslPath, ...
                           [O15Builder.HO_MEANVOL_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']));
            this         = vtor.visitVol2vol(this);            
            this         = vtor.visitIdSegstats(this, 'lh');
            this         = vtor.visitIdSegstats(this, 'rh');
        end
        function this = buildADC(this)
            cd(this.fslPath);
            import mlfourd.* mlsurfer.* mlmr.*;
            
            mad          = MRAlignmentDirector.factory('reference', this.bt1);            
            this.product = mad.meanvol( ...
                           ImagingContext.load( ...
                               fullfile(this.fslPath, 'dwi_default.nii.gz')));
            this.dat     = SurferFilesystem.datFilename(this.fslPath, this.product.fileprefix);
            vtor         = SurferVisitor;
            this         = vtor.visitBBRegisterADC(this);
            
            this.product = ImagingContext.load( ...
                           fullfile(this.fslPath, 'adc_default.nii.gz'));
            this         = vtor.visitVol2vol(this);            
            this         = vtor.visitIdSegstats(this, 'lh');
            this         = vtor.visitIdSegstats(this, 'rh');
        end
        function this = buildThickness(this)
            cd(this.fslPath);            
            
            vtor = mlsurfer.SurferVisitor;
            this = vtor.visitAparcstats2table(this, 'lh', 'thickness');
            this = vtor.visitAparcstats2table(this, 'rh', 'thickness');   
            this = vtor.visitAparcstats2table(this, 'lh', 'thicknessstd');
            this = vtor.visitAparcstats2table(this, 'rh', 'thicknessstd');               
        end
        function this = buildImageOnNativeAnatomy(this, imobj)
            cd(this.mriPath);
            import mlfourd.*;
            this.product        = imobj;
            this.referenceImage = this.rawavg;
            
            vtor = mlsurfer.SurferVisitor;
            this = vtor.visitImageOnNativeAnatomy(this);
        end
        function this = buildSegmentationOnNativeAnatomy(this, aseg)
            cd(this.mriPath);
            import mlfourd.*;
            this.segmentation   = aseg;
            this.product        = this.rawavg;
            this.referenceImage = this.rawavg;
            
            vtor = mlsurfer.SurferVisitor;
            this = vtor.visitSegmentationOnNativeAnatomy(this);
        end
        function this = buildViewsOnNativeAnatomy(this, img, aseg)
            cd(this.mriPath);
            import mlfourd.*;
            this.product        = img;
            this.referenceImage = this.rawavg;
            this.segmentation   = aseg;
            
            vtor = mlsurfer.SurferVisitor;
            this = vtor.viewSegmentationOnNativeAnatomy(this);
            this = vtor.viewSurfaceOnNativeAnatomy(this, 'lh');
            this = vtor.viewSurfaceOnNativeAnatomy(this, 'rh');
        end
 		function this = VolumeRoiCorticalThicknessBuilder(varargin)
 			%% VOLUMEROICORTICALTHICKNESSBUILDER 

 			this = this@mlsurfer.SurferBuilderPrototype(varargin{:}); 
            nr = mlfourd.NamingRegistry.instance;
            this.bt1_          = mlfourd.ImagingContext(fullfile(this.fslPath, nr.BT1_DEFAULT));
            this.segmentation_ = fullfile(this.mriPath, 'aparc.a2009s+aseg.mgz');
            
            p = inputParser;        
            p.KeepUnmatched = true;
            addParameter(p, 'bt1',          this.bt1_,          @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'roi',          [],                 @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'segmentation', this.segmentation_, @(x) lexist(x, 'file'));
            addParameter(p, 'targetId',     this.sessionId,     @(x) lexist(fullfile(this.studyPath, x, ''), 'dir'));
            parse(p, varargin{:});
            this.bt1_          = p.Results.bt1;
            this.roi_          = p.Results.roi;
            this.segmentation_ = p.Results.segmentation;
            this.targetId_     = p.Results.targetId;
            cd(this.sessionPath)
            fprintf('\nmlsurfer.VolumeRoiCorticalThicknessBuilder.ctor:\n    SUBJECTS_DIR->%s\n    pwd->%s\n', ...
                    getenv('SUBJECTS_DIR'), pwd);
 		end 
    end 
    
    properties (Access = 'private')
        bt1_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

