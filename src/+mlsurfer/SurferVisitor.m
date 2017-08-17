classdef SurferVisitor < mlpipeline.PipelineVisitor
	%% SURFERVISITOR   
    %  Cf.  http://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial

	%  $Revision: 2633 $ 
 	%  was created $Date: 2013-09-16 01:20:19 -0500 (Mon, 16 Sep 2013) $ 
 	%  by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-16 01:20:19 -0500 (Mon, 16 Sep 2013) $ 
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferVisitor.m $,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id: SurferVisitor.m 2633 2013-09-16 06:20:19Z jjlee $ 

    properties (Constant)
        WORK_FOLDER = 'fsl';
    end
    
	properties (Dependent)
        echoCmdLine
        echoResult
        freesurferHome
        indices3DAnat
        mrFolder % @deprecated
        mrPath   % @deprecated
        target3DAnat
    end 

    methods (Static)
        function this  = createFromBuilder(bldr)
            %% CREATEFROMBUILDER
            
            assert(isa(      bldr, 'mlsurfer.SurferBuilder'));
            assert(lexist(   bldr.sessionPath, 'dir'));
            assert(~lstrfind(bldr.sessionPath, 'fsl'));
            this = mlsurfer.SurferVisitor('product', bldr.product, 'sessionPath', bldr.sessionPath);
            setenv('SUBJECTS_DIR', this.studyPath);
        end 
    end 
    
	methods %% GET/SET
        function this = set.echoCmdLine(this, tf)
            assert(islogical(tf));
            this.echoCmdLine_ = tf;
        end
        function tf   = get.echoCmdLine(this)
            tf = this.echoCmdLine_;
        end
        function this = set.echoResult(this, tf)
            assert(islogical(tf));
            this.echoResult_ = tf;
        end
        function tf   = get.echoResult(this)
            tf = this.echoResult_;
        end
        function hom  = get.freesurferHome(this) %#ok<MANU>
            [~,hom] = mlbash('echo $FREESURFER_HOME');
            hom = strtrim(hom);
        end
        function this = set.indices3DAnat(this, ids)
            assert(~isempty(ids));
            if (1 == length(ids) || ischar(ids))
                this = this.setIndex3DAnat(ids);
            else
                this = this.setIndices3DAnat(ids);
            end
        end
        function ids  = get.indices3DAnat(this) 
            assert(~isempty(this.indices3DAnat_));
            ids = this.indices3DAnat_;           
        end
        function fld  = get.mrFolder(this)
            [~,fld] = fileparts(trimpath(this.mrPath));
        end
        function pth  = get.mrPath(this)
            mrFolders = mlfourd.AbstractDicomConverter.modalityFolders;
            for m = 1:length(mrFolders)
                try
                    pth = fullfile(this.sessionPath, mrFolders{m});
                    if (lexist(pth, 'dir')); break; end
                catch ME
                    fprintf('\nSurferVisitor:  %s\n\t\t% was not found\n', ME.message, pth);
                end
            end
        end
        function targ = get.target3DAnat(this)
            targ = cell(1, length(this.indices3DAnat_));
            for t = 1:length(targ)
                targ{t} = fullfile(this.mrPath, 'unpack', '3danat', this.indices3DAnat_{t}, [this.indices3DAnat_{t} '.mgz']);
            end
        end
    end

    methods
        
        %% FOR TESTING
        %  @deprecated
        
        function          confirmRoiOnAnatomy(this, bldr)
            if (lgetenv('MLUNIT_TESTING'))
                fprintf('skipping SurferVisitor.confirmRoiOnAnatomy for unit-testing'); return; end
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            assert(lexist(bldr.structural.fqfilename, 'file'));
            assert(lexist(bldr.roi.fqfilename,        'file'));            
            this.surferBash(sprintf( ...
                            'tkmedit -f %s -overlay %s -fthresh 0.5 &', bldr.structural.fqfilename, bldr.roi.fqfilename));
        end
        function          confirmRoiOnTargetId(this, bldr)
            if (lgetenv('MLUNIT_TESTING'))
                fprintf('skipping SurferVisitor.confirmRoiOnTargetId for unit-testing'); return; end
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            assert(lexist(bldr.roi.fqfilename, 'file'));
            cd(           bldr.targetSurfPath);
            this.surferBash(sprintf( ...
                'tkmedit %s ../mri/T1.mgz -overlay %s -overlay-reg %s -fthresh 0.5 -surface lh.white -aux-surface rh.white &', ...
                bldr.targetId, bldr.roi.fqfilename, bldr.dat));
        end
        function          confirmRoiOnTargetSurface(this, bldr)
            if (lgetenv('MLUNIT_TESTING'))
                fprintf('skipping SurferVisitor.confirmRoiOnTargetSurface for unit-testing'); return; end
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            this.surferBash(sprintf( ...
                'tksurfer %s lh inflated -overlay lh.%s.%s.mgh -fthresh 0.5 &', bldr.targetId, bldr.targetId, bldr.roi.fileprefix));
        end
        function bldr =   fslregister2targetId(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            bldr = this.visitFslregister(bldr);
        end
        function          tkregister2targetId(this, bldr) 
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            this.tkregister2t(bldr);
        end
        function          tkregister2identity(this, bldr) 
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            this.tkregister2i(bldr);
        end
        
        %% SUPPORTED METHODS
        
        function bldr =   visitAparcstats2table(this, bldr, varargin)
            %% VISITAPARCSTATS2TABLE calls Freesurfer command aparcstats2table
            %  meas:  area, volume, thickness, thicknessstd, meancurv, gauscurv, foldind, curvind
            
            p = inputParser;
            addRequired(p, 'bldr',              @(x) isa(x, 'mlsurfer.SurferBuilder'));
            addOptional(p, 'hemi', 'lh',        @(x) bldr.checkHemi(x));
            addOptional(p, 'meas', 'thickness', @ischar);
            parse(p, bldr, varargin{:});
            
            cd(bldr.fslPath);            
            opts             = mlsurfer.Aparcstats2tableOptions;
            opts.subjects    = bldr.sessionId;
            opts.hemi        = p.Results.hemi;
            opts.measure     = p.Results.meas;
            opts.parc        = 'aparc.a2009s';
            opts.tablefile   = [p.Results.hemi '_aparc_a2009s_' p.Results.meas '.table'];
            opts.report_rois = true;
            opts.transpose   = true;
            this.aparcstats2table(opts);
            
            bldr.segstats = opts.tablefile;
        end
        function bldr =   visitFreeviewAll(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));            
            opts            = mlsurfer.FreeviewOptions;
            opts.volume     = {   fullfile(bldr.mriPath, 'T1.mgz') ...
                                  fullfile(bldr.mriPath, 'brainmask.mgz:visible=0') ...
                                  fullfile(bldr.mriPath, 'wm.mgz:colormap=lut:opacity=0.3') ...
                                [ fullfile(bldr.mriPath, 'aparc.a2009s+aseg.mgz') ':colormap=lut:opacity=0.1' ] ...
                                [ this.hoFqfn(bldr)     ':reg=' bldr.dat ':colormap=heat:heatscale=0,6,12:opacity=0.6:visible=0' ] ... 
                                [ this.ooFqfn(bldr)     ':reg=' bldr.dat ':colormap=heat:heatscale=0,3.5,7:opacity=0.6:visible=0' ] ... 
                                [ this.ocFqfn(bldr)     ':reg=' bldr.dat ':colormap=heat:heatscale=0,3.5,7:opacity=0.6:visible=0' ] ... 
                                [ this.oefnqFqfn(bldr)    ':reg=' bldr.dat ':colormap=heat:heatscale=0,3,6:opacity=0.6:visible=0' ] ... 
                                [ this.tauHoFqfn(bldr)  ':reg=' bldr.dat ':colormap=heat:heatscale=0,3,6:opacity=0.6:visible=0' ] ... 
                                [ this.tauOoFqfn(bldr)  ':reg=' bldr.dat ':colormap=heat:heatscale=0,3,6:opacity=0.6:visible=0' ] ... 
                                [ this.adcFqfn(bldr)    ':reg=' bldr.dat ':colormap=heat:heatscale=0,400,1500:opacity=0.9:visible=0' ] ... 
                                [ this.dwiFqfn(bldr)    ':reg=' bldr.dat ':colormap=heat:heatscale=0,180,300:opacity=0.9:visible=0' ] ...                                
                                [ this.perfusionFqfn(bldr, 'CBF')   ':reg=' bldr.dat ':colormap=heat:heatscale=0,2,5:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 'CBV')   ':reg=' bldr.dat ':colormap=heat:heatscale=0,5,10:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 'MTT')   ':reg=' bldr.dat ':colormap=heat:heatscale=0,2,5:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 't0')    ':reg=' bldr.dat ':colormap=heat:heatscale=0,6,12:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 'alpha') ':reg=' bldr.dat ':colormap=heat:heatscale=0,4,11:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 'beta')  ':reg=' bldr.dat ':colormap=heat:heatscale=0,1.5,2.7:opacity=0.6:visible=0' ] ...     
                                [ this.perfusionFqfn(bldr, 'gamma') ':reg=' bldr.dat ':colormap=heat:heatscale=0,2,4:opacity=0.8:visible=0' ] ...   
                                };
            opts.surface    = { [ fullfile(bldr.surfPath, 'lh.pial')     ':annot=lh.aparc.a2009s.annot:name=lh_pial_aparc_a2009s:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'lh.inflated') ':overlay=lh.thickness:overlay_threshold=0.1,3::name=lh_inflated_thickness:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'lh.inflated') ':visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'lh.white')    ':edgecolor=blue:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'lh.pial')     ':edgecolor=red:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'rh.pial')     ':annot=rh.aparc.2009s.annot:name=rh_pial_aparc_a2009s:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'rh.inflated') ':overlay=rh.thickness:overlay_threshold=0.1,3::name=rh_inflated_thickness:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'rh.inflated') ':visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'rh.white')    ':edgecolor=blue:visible=0' ] ...
                                [ fullfile(bldr.surfPath, 'rh.pial')     ':edgecolor=red:visible=0' ] ...
                                };
            opts.colorscale = true;
            opts.viewport   = '3d';
            this.freeview(opts);
        end
        function bldr =   visitFreeviewAnatomicalVolume(this, varargin)
            p = inputParser;
            addRequired(p, 'bldr', @(x) isa(x, 'mlsurfer.SurferBuilder'));
            addOptional(p, 'prodColormap', ':colormap=heat:heatscale=0,3,6:opacity=0.6', @ischar);
            parse(p, varargin{:});
            bldr = p.Results.bldr;
            
            opts              = mlsurfer.FreeviewOptions;
            opts.volume       = {   fullfile(bldr.mriPath, 'orig.mgz') ...
                                  [ fullfile(bldr.mriPath, 'aparc.a2009s+aseg.mgz') ':colormap=lut:opacity=0.25' ] ...
                                  [ bldr.product.fqfilename ':reg=' bldr.dat p.Results.prodColormap ]};
            opts.colorscale   = true;
            this.freeview(opts);
        end
        function bldr =   visitFreeviewDataSurface(this, bldr, hemi)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));            
            import mlsurfer.*;
            
            opts          = Mri_vol2surfOptions;
            opts.mov      = bldr.product.fqfilename;
            opts.reg      = bldr.dat;
            opts.projfrac = 0.5;
            opts.hemi     = hemi;
            opts.o        = fullfile(this.fslPath, [hemi '_' bldr.product.filename]);
            this.mri_vol2surf(opts);
            
            opts2          = FreeviewOptions;
            opts2.surface  = [ fullfile(bldr.surfPath, [hemi '.inflated']) ...
                               ':annot=aparc.a2009s.annot' ':overlay=' opts.o ':overlay_threshold=2,5' ];
            opts2.viewport = '3d';
            this.freeview(opts2);
        end
        function bldr =   visitFslregister(this, bldr)
            opts     = mlsurfer.FslregisterOptions;
            opts.s   = bldr.targetId;
            opts.mov = bldr.product.fqfilename;
            opts.reg = bldr.dat;
            this.fslregister(opts);
        end
        function bldr =   visitImageOnNativeAnatomy(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));      
            cd(bldr.mriPath);
            
            opts              = mlsurfer.Mri_vol2volOptions;
            opts.mov          = bldr.product.fqfilename;
            opts.targ         = bldr.referenceImage.fqfilename;
            opts.regheader    = true;
            opts.o            = fullfile([bldr.product.fqfileprefix '_on_' bldr.referenceImage.filename]);
            opts.no_save_reg  = true;
            this.mri_vol2vol(opts);
            bldr.product      = mlfourd.ImagingContext.load(opts.o);
        end
        function bldr =   visitSegmentationOnNativeAnatomy(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));      
            cd(bldr.mriPath);
            
            opts              = mlsurfer.Mri_label2volOptions;
            opts.seg          = bldr.product.fqfilename;
            opts.temp         = bldr.referenceImage.fqfilename;
            opts.o            = fullfile([bldr.product.fqfileprefix '_on_' bldr.referenceImage.filename]);
            opts.regheader    = opts.seg;
            this.mri_label2vol(opts);
            bldr.product      = mlfourd.ImagingContext.load(opts.o);
        end
        function bldr =   viewSegmentationOnNativeAnatomy(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            import mlsurfer.*;
            
            opts              = TkmeditOptions;
            opts.f            = bldr.product.fqfilename;
            opts.aux          = bldr.referenceImage.fqfilename;
            opts.segmentation = bldr.segmentation.fqfilename;
            this.tkmedit(opts);
        end
        function bldr =   viewSurfaceOnNativeAnatomy(this, bldr, hemi)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            import mlsurfer.*;
            
            opts           = Tkregister2Options;
            opts.mov       = bldr.referenceImage;
            opts.targ      = bldr.orig;
            opts.reg       = bldr.dat;
            opts.noedit    = true;
            opts.regheader = true;
            this.tkregister2(opts);
            
            opts          = Mri_surf2surfOptions;
            opts.sval_xyz = 'pial';
            opts.reg      = [bldr.dat ' ' bldr.referenceImage.fqfilename];
            opts.tval     =  bldr.pialNative_fqfn(hemi);
            opts.tval_xyz = true;            
            opts.hemi     = hemi;
            opts.s        = bldr.sessionId;
            this.mri_surf2surf(opts);
            
            opts         = FreeviewOptions;
            opts.volume  = bldr.referenceImage;
            opts.surface = bldr.pialNative_fqfn(hemi);
            this.freeview(opts);
        end        
        function bldr =   visitRoiVol2surf(this, bldr, hemi)
            assert(isa(   bldr, 'mlsurfer.SurferBuilder'));         
            cd(bldr.surfPath);
            bldr.roi.nifti.save;
            assert(lexist(bldr.roi.fqfilename, 'file'));
            %%% bldr.checkHemi(hemi);   
            
            opts              = mlsurfer.Mri_vol2surfOptions;
            opts.mov          = bldr.roi.fqfilename;
            opts.reg          = bldr.dat;
            opts.projdist_max = '0 1 0.1';
            opts.hemi         = hemi;
            opts.o            = sprintf('%s/%s.%s.%s.mgh', bldr.surfPath, hemi, bldr.targetId, bldr.roi.fileprefix);
            %opts.reshape      = true;
            this.mri_vol2surf(opts);
        end          
        function bldr =   visitRoiSegstats(this, bldr, hemi)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            bldr.checkHemi(hemi);            
            cd(bldr.surfPath);         
            
            opts           = mlsurfer.Mri_segstatsOptions;
            opts.seg       = sprintf('%s/%s.%s.%s.mgh',        bldr.surfPath, hemi, bldr.targetId, bldr.roi.fileprefix);
            opts.i         = sprintf('%s/%s.thickness.%s.mgh', bldr.surfPath, hemi, bldr.targetId);
            opts.excludeid = '0';
            opts.sum       = bldr.segstats_fqfn(hemi, ['thickness_' bldr.targetId]);
            this.mri_segstats(opts);
        end   
        function bldr =   visitVolumeRoiCorticalThicknessSegstats(this, bldr, hemi)
            %% VISITVOLUMEROICORTICALTHICKNESSSEGSTATS
            %  Usage:  from mri_segstats --help, EXAMPLE 1, EXAMPLE 2
            %
            % 	mri_segstats --seg $SUBJECTS_DIR/bert/mri/aseg --ctab $FREESURFER_HOME
            % 	/FreeSurferColorLUT.txt --excludeid 0 --sum bert.aseg.sum
            % 	
            % 	This will compute the segmentation statistics from the automatic 
            % 	FreeSurfer subcortical segmentation for non-empty segmentations and 
            % 	excluding segmentation 0 (UNKNOWN). The results are stored in 
            % 	bert.aseg.sum.
            %
            % 	mri_segstats --seg $SUBJECTS_DIR/bert/mri/aseg --ctab $FREESURFER_HOME
            % 	/FreeSurferColorLUT.txt --excludeid 0 --sum bert.aseg.sum --i 
            % 	$SUBJECTS_DIR/bert/mri/orig
            % 	
            % 	Same as above but intensity statistics from the orig volume will also 
            % 	be reported for each segmentation.
            
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            bldr.checkHemi(hemi);       
            cd(bldr.surfPath);         
            
            opts              = mlsurfer.Mri_segstatsOptions;
            opts.seg          = fullfile(bldr. mriPath, 'aparc.a2009s+aseg.mgz');
            opts.ctab_default = true;
            opts.excludeid    = 0;
            opts.i            = fullfile(bldr.mriPath, 'orig.mgz');
            opts.sum          = bldr.segstats_fqfn(hemi, 'orig');
            this.mri_segstats(opts);
        end   
        function bldr =   visitIdSegstats(this, bldr, hemi, varargin)
            p = inputParser;
            addRequired(p, 'bldr', @(x) isa(x, 'mlsurfer.SurferBuilder')); 
            addRequired(p, 'hemi', @(x) strcmp('lh',x) || strcmp('rh',x)); 
            addOptional(p, 'mask', []);
            parse(p, bldr, hemi, varargin{:});
            bldr = p.Results.bldr;
            cd(bldr.fslPath);
            
            opts              = mlsurfer.Mri_vol2volOptions;
            opts.mov          = bldr.product.fqfilename;
            opts.reg          = bldr.dat;
            opts.fstarg       = true;
            opts.o            = fullfile(bldr.fslPath, [bldr.product.fileprefix '_on_fsanatomical.mgz']);
            this.mri_vol2vol(opts);
            
            opts2              = mlsurfer.Mri_segstatsOptions;
            opts2.seg          = fullfile(bldr.mriPath, 'aparc.a2009s+aseg.mgz');
            opts2.ctab_default = true;
            opts2.id           = this.idsAparcA2009s(hemi);
            opts2.i            = opts.o;
            opts2.sum          = bldr.segstats_fqfn(hemi, bldr.product.fileprefix);
            opts2.mask         = p.Results.mask;
            this.mri_segstats(opts2);
            
            bldr.segstats = opts2.sum;
        end
        function bldr =   visitSurf2surf(this, bldr, hemi)
            assert(isa(bldr, 'mlsurfer.SurferBuilder')); 
            bldr.checkHemi(hemi);            
            cd(bldr.surfPath);
            
            opts            = mlsurfer.Mri_surf2surfOptions;
            opts.s          = bldr.sessionId;
            opts.trgsubject = bldr.targetId;
            opts.hemi       = hemi;
            opts.sval       = [hemi '.thickness'];
            opts.tval       = sprintf('%s/%s.thickness.%s.mgh', bldr.surfPath, hemi, bldr.targetId);
            this.mri_surf2surf(opts);
        end  
        function bldr =   visitVol2fsanatomical(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder')); 
            cd(bldr.fslPath);
            
            opts         = mlsurfer.Mri_vol2volOptions;
            opts.mov     = bldr.product;
            opts.reg     = fullfile(bldr.fslPath, [bldr.t1Prefix bldr.datSuffix]);
            opts.fstarg  = true;
            opts.o       = [bldr.product.fqfileprefix '_fsanatomical.mgz'];
            this.mri_vol2vol(opts);
            
            bldr.product = mlfourd.ImagingContext.load(opts.o);
        end
        function bldr =   visitVol2vol(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder')); 
            cd(bldr.fslPath);
            
            opts         = mlsurfer.Mri_vol2volOptions;
            opts.mov     = bldr.product;
            opts.reg     = bldr.dat;
            opts.fstarg  = true;
            opts.o       = [bldr.product.fqfileprefix '_fsanatomical.mgz'];
            this.mri_vol2vol(opts);
            
            bldr.product = mlfourd.ImagingContext.load(opts.o);
        end
        function bldr =   visitBBRegisterADC(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            assert(lstrfind(bldr.product.fileprefix, '_meanvol'));
            
            opts = mlsurfer.BBRegisterOptions;
            opts.mov      = bldr.product;
            opts.t2       = true;
            opts.s        = bldr.sessionId;
            opts.init_fsl = true;
            opts.epi_mask = true;
            opts.reg      = bldr.dat;
            this.bbregister(opts);
        end
        function bldr =   visitBBRegisterLAIF(~, bldr)
        end
        function bldr =   visitBBRegisterNative(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            
            opts          = mlsurfer.BBRegisterOptions;
            opts.mov      = bldr.product;
            opts.t1       = true;
            opts.s        = bldr.sessionId;
            % opts.init_fsl = false; % fails wu029_p7395_2009mar12
            opts.init_header = true;
            opts.reg      = bldr.dat;
            this.bbregister(opts);            
        end
        function          reconAll(this, bldr, ids)
            %% RECONALL
            %  Usage:  obj.reconAll(indices_3D_anatomy)
            %                       ^
            
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            if (exist('ids','var')); 
                this.indices3DAnat = ids; 
            end
            inputs = '';
            for a = 1:length(this.indices3DAnat)
                inputs = sprintf('%s -i unpack/3danat/%s/001.mgz ', inputs, this.indices3DAnat{a});
            end
            mlsurfer.SurferVisitor.surferBash( ...
                sprintf('recon-all -s %s %s -all', bldr.sessionId, inputs));
        end   
        function          unpack3DAnatMgz(this, dcmdir)
            assert(lexist(dcmdir, 'dir'));
            targdir = fullfile(this.mrPath, 'unpack', '');
            runs    = '';
            for r = 1:length(this.indices3DAnat_)
                runs = sprintf('%s -run %u 3danat mgz 001.mgz ', runs, str2double(this.indices3DAnat_{r})); 
            end
            mlsurfer.SurferVisitor.surferBash( ...
                sprintf('unpacksdcmdir -src %s -targ %s -fsfast %s', ...
                         dcmdir, targdir, runs));
        end 
        function [s,r]  = surferBash(this, cmdlin, varargin)
            %% SURFERBASH wraps mlbash with the shell environment required by freesurfer
            
            p = inputParser;
            addRequired(p, 'cmdlin', @ischar);
            addOptional(p, 'EchoCmdLine', this.echoCmdLine, @islogical);
            addOptional(p, 'EchoResult',  this.echoResult,  @islogical);
            parse(p, cmdlin, varargin{:});
            
            setenv('SUBJECTS_DIR', this.studyPath)
            assert(lexist(this.sessionPath, 'dir'));
            try
                r = ''; [s,r] = mlbash(p.Results.cmdlin); %%%, 'EchoCmdLine', p.Results.EchoCmdLine, 'EchoResult', p.Results.EchoResult);
                r  = checkReturnOf(s,r);
            catch ME
                handexcept(ME,r);
            end
        end

 		function this   = SurferVisitor(varargin)
 			%% SURFERVISITOR
            %  See also:   mlpipeline.PipelineVisitor
            
            this = this@mlpipeline.PipelineVisitor(varargin{:});
            this.workPath = fullfile(trimpath(this.sessionPath), this.WORK_FOLDER, '');
            assert(lexist(this.workPath));
 		end 
    end
    
    %% PRIVATE
    
    properties (Access = 'private')
        echoCmdLine_ = true;
        echoResult_  = true;
        indices3DAnat_
    end

    methods (Static, Access = 'private')
        function cmdlin = lastCmd(cmdlin)
            locs = strfind(cmdlin, '; ');
            if (~isempty(locs))
                loc = locs(length(locs));
                cmdlin = cmdlin(loc+2:end);
            end
        end
    end
    
    methods (Access = 'private')
        function        aparcstats2table(this, opts)
            this.surferBash(sprintf('aparcstats2table %s', char(opts)));
        end
        function        bbregister(this, opts)
            this.surferBash(sprintf('bbregister %s', char(opts)));
        end
        function        freeview(this, opts)
            if (lgetenv('MLUNIT_TESTING') || lgetenv('DEBUG'))
                this.surferBash(sprintf('freeview %s &', char(opts))); end                
        end
        function        fslregister(this, opts)
            this.surferBash(sprintf('fslregister %s', char(opts)));
        end
        function num  = idsAparcA2009s(~, hemi)
            num = nan; %#ok<NASGU>
            switch (hemi)
                case 'lh'
                    num = 11100 + (1:75);
                    num = [7 8 num]; % add cerebellum
                case 'rh'
                    num = 12100 + (1:75);
                    num = [46 47 num]; % add cerebellum
                otherwise
                    error('mlsurfer:unsupportedParamValue', 'SurferVisitor.idsAparcA2009s.hemi->%s', hemi);
            end
        end

        function        mri_label2vol(this, opts)
            this.surferBash(sprintf('mri_label2vol %s', char(opts)));
        end
        function        mri_segstats(this, opts)
            this.surferBash(sprintf('mri_segstats %s', char(opts)));
        end
        function        mri_surf2surf(this, opts)
            this.surferBash(sprintf('mri_surf2surf %s', char(opts)));
        end
        function        mri_vol2surf(this, opts)
            this.surferBash(sprintf('mri_vol2surf %s', char(opts)));
        end
        function        mri_vol2vol(this, opts)
            this.surferBash(sprintf('mri_vol2vol %s', char(opts)));
        end
        function        tkmedit(this, opts)
            this.surferBash(sprintf('tkmedit %s &', char(opts)));
        end
        function        tkregister2(this, opts)
            this.surferBash(sprintf('tkregister2 %s', char(opts)));
        end
        function        tkregister2t(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));   
            
            cd(bldr.targetSurfPath);
            regfile = bldr.dat;
            fslfile = filename( ...
                      fileprefix(bldr.dat, '.dat'), mlfsl.FlirtVisitor.XFM_SUFFIX); 
            movfile = bldr.bt1.fqfilename;
            this.surferBash(sprintf( ...
                'tkregister2 --s %s --mov %s --fsl %s --reg %s --noedit', ...
                 bldr.targetId, movfile, fslfile, regfile));
        end
        function        tkregister2i(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));            
            
            cd(bldr.surfPath);
            import mlsurfer.*;
            regfile = bldr.dat; 
            movfile = bldr.bt1.fqfilename;
            this.surferBash(sprintf( ...
                'tkregister2 --s %s --mov %s --identity --reg %s --noedit', ...
                 bldr.targetId, movfile, regfile));
        end
        function this = setIndices3DAnat(this, ids)
            if (isnumeric(ids))
                ids = num2cell(ids);
            end
            this.indices3DAnat_ = cell(1,length(ids));
            for a = 1:length(ids)
                this.indices3DAnat_{a} = this.index3DAnat2str(ids{a});
            end
        end
        function this = setIndex3DAnat(this, idx)
            this.indices3DAnat_ = ensureCell(this.index3DAnat2str(idx));
        end
        function str  = index3DAnat2str(this, idx)
            if (isnumeric(idx))
                str = sprintf('%03u', idx);
            elseif (ischar(idx))
                assert(3 == length(idx));
                str = idx;
            elseif (iscell(idx))
                assert(1 == length(idx));
                str = this.index3DAnat2str(idx{1});
            end
        end  
        function fqfn = hoFqfn(~, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ...
                  [PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX '_on_' ...
                   SurferFilesystem.T1_FILEPREFIX PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX '.nii.gz']);
        end
        function fqfn = ooFqfn(~, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ...
                  [PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX '_on_' ...
                   SurferFilesystem.T1_FILEPREFIX PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX '.nii.gz']);
        end
        function fqfn = ocFqfn(~, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ...
                  [PETSegstatsBuilder.OC_FILEPREFIX '_on_' ...
                   SurferFilesystem.T1_FILEPREFIX PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX '.nii.gz']);
        end
        function fqfn = oefnqFqfn(this, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, [PETSegstatsBuilder.OEFNQ_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']);
            if (~lexist(fqfn, 'file'))
                oo  = imcast(this.ooFqfn(bldr), 'mlfourd.NIfTI');
                ho  = imcast(this.hoFqfn(bldr), 'mlfourd.NIfTI');
                oef = oo ./ ho;
                oef.saveas(fqfn);
            end
        end
        function fqfn = tauHoFqfn(this, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ['tauHo_on_' SurferFilesystem.T1_FILEPREFIX PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX '.nii.gz']);
            if (~lexist(fqfn, 'file'))
                oc  = imcast(this.ocFqfn(bldr), 'mlfourd.NIfTI');
                ho  = imcast(this.hoFqfn(bldr), 'mlfourd.NIfTI');
                tau = oc ./ ho;
                tau.saveas(fqfn);
            end
        end
        function fqfn = tauOoFqfn(this, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ['tauOo_on_' SurferFilesystem.T1_FILEPREFIX PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX '.nii.gz']);
            if (~lexist(fqfn, 'file'))
                oc  = imcast(this.ocFqfn(bldr), 'mlfourd.NIfTI');
                oo  = imcast(this.ooFqfn(bldr), 'mlfourd.NIfTI');
                tau = oc ./ oo;
                tau.saveas(fqfn);
            end
        end
        function fqfn = adcFqfn(~, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ['adc_default_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']);
        end
        function fqfn = dwiFqfn(~, bldr)
            import mlsurfer.*;
            fqfn = fullfile(bldr.fslPath, ['dwi_default_meanvol_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']);
        end
        function fqfn = perfusionFqfn(~, bldr, param)
            import mlsurfer.*;
            fqfn = fullfile(bldr.perfPath, [param '_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']);
        end      
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

