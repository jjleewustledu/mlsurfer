classdef PerfusionSegstatsBuilder < mlsurfer.SurferBuilderPrototype
	%% PERFUSIONSEGSTATSBUILDER 
    %  TODO:  collected hard-coded filenames

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

    properties (Constant)
        ALPHA_FILEPREFIX    = 'alpha';   
        BETA_FILEPREFIX     = 'beta';   
        CBF_FILEPREFIX      = 'CBF';
        CBV_FILEPREFIX      = 'CBV';
        EP2D_MCF_FILEPREFIX = 'ep2d_default_mcf';
        MTT_FILEPREFIX      = 'MTT';   
        T0_FILEPREFIX       = 't0';
        
        PERF_PARAMS = { 'S0' 'CBF' 't0'  'alpha'   'beta'               'delta'   'gamma'   'eps' 't1' ...
                        'nu' 'MTT' 'CBV' 'logProb' 'baselineDifference' 'CBVcalc' 'corrCBV' 'K1'  'K2' };
                    
        PERF_TEMPLATE_FILEPREFIX = 'perfTemplate';
        PERF_MASK_FILEPREFIX     = 'perfMask';
        LOG_PROB_FILEPREFIX      = 'logProb';
    end
    
	properties (Dependent)
        alpha
        beta
        cbf
        cbv
        mtt
        perfComposite
        perfLogProb
        perfMask
        perfMcf
        perfParamsFqfilename
        perfTemplate
        referenceT2Image  
        t0
    end 
    
    methods %% GET/SET
        function ic   = get.alpha(this)
            if (~isempty(this.alpha_))
                ic = this.alpha_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.ALPHA_FILEPREFIX)));
        end
        function ic   = get.beta(this)
            if (~isempty(this.beta_))
                ic = this.beta_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.BETA_FILEPREFIX)));
        end
        function ic   = get.cbf(this)
            if (~isempty(this.cbf_))
                ic = this.cbf_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.CBF_FILEPREFIX)));
        end
        function this = set.cbf(this, obj)
            this.cbf_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.cbv(this)
            if (~isempty(this.cbv_))
                ic = this.cbv_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.CBV_FILEPREFIX)));
        end
        function this = set.cbv(this, obj)
            this.cbv_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.mtt(this)
            if (~isempty(this.mtt_))
                ic = this.mtt_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.MTT_FILEPREFIX)));
        end
        function this = set.mtt(this, obj)
            this.mtt_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.perfComposite(this)
            assert(~isempty(this.perfComposite_))
            ic = this.perfComposite_; 
        end
        function this = set.perfComposite(this, ic)
            this.perfComposite_ = mlfourd.ImagingContext(ic);
            for c = 1:length(this.perfComposite_.composite)
                assert(lexist(this.perfComposite_.composite.get(c).fqfilename, 'file'));
            end
        end
        function ic   = get.perfLogProb(this)
            ic = mlfourd.ImagingContext.load( ...
                 fullfile(this.perfPath, filename(this.LOG_PROB_FILEPREFIX)));
        end
        function ic   = get.perfMask(this)
            if (~isempty(this.perfMask_))
                ic = this.perfMask_; return; end
            this = this.makePerfMask;
            ic   = this.perfMask_;
        end
        function this = set.perfMask(this, pm)
            import mlsurfer.*;
            pm = imcast(pm, 'mlfourd.NIfTI');
            assert(strcmp([this.PERF_MASK_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX], pm.fileprefix));
            
            bldr           = this.clone;
            bldr.product   = pm;
            bldr.dat       = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            vtor           = SurferVisitor;
            bldr           = vtor.visitVol2fsanatomical(bldr);
            this.perfMask_ = bldr.product;
        end
        function ic   = get.perfMcf(this)
            ic = mlfourd.ImagingContext.load( ...
                 fullfile(this.fslPath, filename(this.EP2D_MCF_FILEPREFIX)));
        end
        function fqfn = get.perfParamsFqfilename(this)
            fqfn = fullfile(this.perfPath, 'ep2d_default_mcf_params.nii.gz');
        end
        function ic   = get.perfTemplate(this)    
            if (~isempty(this.perfTemplate_))
                ic = this.perfTemplate_; return; end
            this = this.makePerfTemplate;
            ic   = this.perfTemplate_;
        end
        function this = set.perfTemplate(this, t)
            import mlsurfer.*;
            t = imcast(t, 'mlfourd.NIfTI');
            assert(strcmp([this.PERF_TEMPLATE_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX] , t.fileprefix));
            
            bldr               = this.clone;
            bldr.product       = t;
            bldr.dat           = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            vtor               = SurferVisitor;
            bldr               = vtor.visitVol2fsanatomical(bldr);
            this.perfTemplate_ = bldr.product;
        end
        function img  = get.referenceT2Image(this)
            assert(~isempty(this.referenceT2Image_));
            img = this.referenceT2Image_;  
        end
        function this = set.referenceT2Image(this, imobj)
            this.referenceT2Image_ = mlfourd.ImagingContext(imobj);
            assert(lexist(this.referenceT2Image_.fqfilename, 'file'));
        end
        function ic   = get.t0(this)
            if (~isempty(this.t0_))
                ic = this.t0_; return; end
            ic = mlfourd.ImagingContext.load( ...
                fullfile(this.perfPath, filename(this.T0_FILEPREFIX)));
        end
        function this = set.t0(this, obj)
            this.t0_ = mlfourd.ImagingContext(obj);
        end
    end
    
    methods (Static)
        function sessions = fsanatomicalStatsForStudy(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            sessions = {};
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('PerfusionSegstatsBuilder.fsanatomicalStatsForStudy is working in %s\n', dt.fqdns{d});
                    ssb = mlsurfer.PerfusionSegstatsBuilder('SessionPath', dt.fqdns{d});
                    ssb.fsanatomicalStats;
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
    end
    
	methods 
        function statfns = fsanatomicalStats(this, dat_fqfn)
            import mlsurfer.* mlpatterns.*;
            if (~exist('dat_fqfn', 'var'))
                dat_fqfn = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            end
            this.dat = dat_fqfn;
            if (~lexist(this.dat))  
                this = this.bbregisterNative;
            end
            this.product = this.alignPerfusionParams;
            
            statfns       = CellArrayList;
            prds          = mlfourd.ImagingContext(this.product);
            this.perfMask = prds.get(prds.length);
            for p = 1:length(prds)
                [~,lhstat,rhstat] = this.surferRegisteredSegstats( ...
                                    mlfourd.ImagingContext(prds{p}), ':colormap=nih:opacity=0.5', this.perfMask);
                statfns.add(lhstat);
                statfns.add(rhstat);
            end            
            cd(this.sessionPath);
        end
 		function this = PerfusionSegstatsBuilder(varargin) 
 			%% PERFUSIONSEGSTATSBUILDER 
 			%  Usage:  this = PerfusionSegstatsBuilder() 

            this = this@mlsurfer.SurferBuilderPrototype(varargin{:});
            import mlsurfer.*;
            this = this.makePerfTemplate;
            this.referenceImage = mlfourd.ImagingContext.load( ...
                                  fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX)));
            this.product        = this.splitPerfusionParams(this.perfParamsFqfilename);
            this.perfComposite  = this.product;
        end 
        function this = makePerfMask(this)
            assert(lexist(this.perfMcf.fqfilename, 'file'));
            ic             = mlfourd.ImagingContext(this.perfLogProb);            
            nii            = ic.nifti;
            nii.img        = nii.img > 0.05*nii.dipmax;
            nii.fileprefix = this.PERF_MASK_FILEPREFIX;
            nii.save;
            this.perfMask_ = mlfourd.ImagingContext(nii);
        end
        function this = makePerfTemplate(this)
            assert(lexist(this.perfMcf.fqfilename, 'file'));
            ic                 = mlfourd.ImagingContext(this.perfMcf);
            nii                = ic.nifti;
            nii.img            = nii.img(:,:,:,1);
            nii.fileprefix     = this.PERF_TEMPLATE_FILEPREFIX;
            nii.save;
            this.perfTemplate_ = mlfourd.ImagingContext(nii);
        end
    end 

    %% PRIVATE
    
    properties (Access = 'private')
        alpha_
        beta_
        cbf_
        cbv_
        mtt_
        perfMask_
        perfComposite_
        perfTemplate_
        referenceT2Image_
        t0_
    end
    
    methods (Access = 'private')        
 		function splitup = splitPerfusionParams(this, ic) 
            ep2d = imcast(ic, 'mlfourd.NIfTI');
            assert(ep2d.duration >= 18);
            splitup = mlfourd.ImagingComponent.load(this.perfTemplate);
            for p = 1:length(this.PERF_PARAMS)
                if (sum(sum(sum(ep2d.img(:,:,:,p)))) > 0)
                    tmp            = ep2d.clone;
                    tmp.img        = ep2d.img(:,:,:,p);
                    tmp.fileprefix = this.PERF_PARAMS{p};
                    tmp.save;
                    splitup        = splitup.add(tmp);
                end
            end
            splitup = splitup.add(this.perfMask);
            splitup = mlfourd.ImagingContext(splitup);
        end      
        function prod    = alignPerfusionParams(this)  
            import mlsurfer.*;
            mrad = mlmr.MRAlignmentDirector.factory( ...
                        'product', this.product, 'referenceImage', this.referenceImage);
            defaultT2Image = fullfile(this.fslPath, filename(SurferFilesystem.T2_FILEPREFIX));            
            if (lexist(defaultT2Image, 'file'))
                this.referenceT2Image = mrad.alignT2( ...
                                        fullfile(this.fslPath, filename([SurferFilesystem.T2_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX])));
                prod                  = mrad.alignT2starOnT2( ...
                                        this.product, this.referenceT2Image);
            else
                prod                  = mrad.alignT2starOnT1( ...
                                        this.product, this.referenceImage);
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

