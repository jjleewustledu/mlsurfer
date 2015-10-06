classdef SurferBuilderPrototype < mlsurfer.SurferBuilder
	%% SURFERBUILDERPROTOTYPE   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

    properties (Constant)
        DAT_SUFFIX    = '_to_fsanatomical.dat'
        T1_FILEPREFIX = 't1_default';
        T2_FILEPREFIX = 't2_default';
    end
    
	properties (Dependent)
        dat
        fslPath
        mask
        mriPath
        orig
        perfPath 
        product
        referenceImage
        roi
        segmentation
        segstats
        sessionId
        sessionPath
        structural
        studyPath
        surfPath
        t1
        t2
        targetId
    end 

    methods (Static)
        function checkHemi(hemi)
            assert(ischar(hemi));
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
        end
        function sessions = ensureBettedForStudy(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            sessions = {};
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('SurferBuilderPrototype.ensureBettedForStudy is working in %s\n', dt.fqdns{d});
                    sbp = mlsurfer.SurferBuilderPrototype('SessionPath', dt.fqdns{d});
                    sbp.ensureBetted;
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
        function freeviewAll(sessPth)
            import mlsurfer.*;
            this = SurferBuilderPrototype('SessionPath', sessPth);
            this.product = imcast( ...
                fullfile(this.sessionPath, 'fsl', filename(this.T1_FILEPREFIX)), ...
                'mlfourd.ImagingContext');
            cd(this.sessionPath);
            vtor = SurferVisitor.createFromBuilder(this);
            vtor.visitFreeviewAll(this);
        end
    end

    methods %% SET/GET
        function x    = get.dat(this)
            if (isempty(this.dat_))
                x = fullfile(this.fslPath, [this.product.fileprefix this.DAT_SUFFIX]); return; end
            x = this.dat_;
        end
        function this = set.dat(this, x)
            import mlsurfer.*;
            if (~lstrfind(x, SurferVisitor.DAT_SUFFIX));
                x =      [x  SurferVisitor.DAT_SUFFIX]; end
            this.dat_ = x;
        end
        function pth  = get.fslPath(this)
            assert(lexist(this.sessionPath, 'dir'));
            pth = fullfile(this.sessionPath, 'fsl', '');
        end
        function this = set.mask(this, img)
            this.mask_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.mask(this)
            assert(~isempty(this.mask_));
            img = imcast(this.mask_, 'mlfourd.ImagingContext');
        end
        function pth  = get.mriPath(this)
            pth = fullfile(this.sessionPath, 'mri', '');
        end
        function ic   = get.orig(this)
            ic = mlfourd.ImagingContext.load( ...
                 fullfile(this.mriPath, 'orig.mgz'));
        end
        function pth  = get.perfPath(this)
            pth = fullfile(this.sessionPath, 'perfusion_4dfp', '');
        end
        function this = set.product(this, img)
            assert(~isempty(img));
            this.product_ = img;
        end
        function img  = get.product(this)
            assert(~isempty(this.product_));
            img = imcast(this.product_, 'mlfourd.ImagingContext');
        end
        function this = set.referenceImage(this, img)
            this.referenceImage_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.referenceImage(this)
            assert(~isempty(this.referenceImage_));
            img = imcast(this.referenceImage_, 'mlfourd.ImagingContext');
        end
        function this = set.roi(this, img)
            this.roi_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.roi(this)
            assert(~isempty(this.roi_));
            img = imcast(this.roi_, 'mlfourd.ImagingContext');
        end
        function this = set.segmentation(this, img)
            this.segmentation_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.segmentation(this)
            assert(~isempty(this.segmentation_));
            img = imcast(this.segmentation_, 'mlfourd.ImagingContext');
        end
        function this = set.segstats(this, ss)
            assert(ischar(ss));
            if (lexist(ss, 'file'))
                ss = mlio.TextIO.textfileToString(ss); end
            this.segstats_ = ss;
        end
        function ss   = get.segstats(this)
            assert(~isempty(this.segstats_));
            ss = this.segstats_;
        end
        function this = set.sessionId(this, id)
            assert(ischar(id));
            this.sessionPath_ = fileparts(trimpath(this.sessionPath_));
            this.sessionPath_ = fullfile(this.sessionPath_, id, '');
        end
        function id   = get.sessionId(this)
            assert(~isempty(this.sessionPath_));
            [~,id] = fileparts(trimpath(this.sessionPath_));
        end
        function this = set.sessionPath(this, pth)
            this.sessionPath_ = pth;
        end
        function pth  = get.sessionPath(this)
            assert(lexist(this.sessionPath_, 'dir'));
            pth = this.sessionPath_;
        end
        function this = set.structural(this, img)
            this.structural_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.structural(this)
            if (isempty(this.structural_))
                img = imcast(this.referenceImage_, 'mlfourd.ImagingContext'); return; end
            img = imcast(this.structural_, 'mlfourd.ImagingContext');
        end
        function pth  = get.studyPath(this)
            pth = fileparts(trimpath(this.sessionPath));
        end
        function pth  = get.surfPath(this)
            pth = fullfile(this.sessionPath, 'surf', '');
        end
        function this = set.targetId(this, id)
            assert(ischar(id));
            assert(lexist(fullfile(this.studyPath, id), 'dir'));
            this.targetId_ = id;
        end
        function ic   = get.t1(this)
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.T1_FILEPREFIX)));
        end
        function ic   = get.t2(this)
            if (~isempty(this.t2_))
                ic = this.t2_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.T2_FILEPREFIX)));
        end
        function this = set.t2(this, obj)
            this.t2_ = imcast(obj, 'mlfourd.ImagingContext');
        end
        function id   = get.targetId(this)
            assert(~isempty(this.targetId_));
            [~,id] = fileparts(trimpath(this.targetId_));
        end
    end
    
	methods  		 
        function obj  = clone(this)
            obj = mlsurfer.SurferBuilderPrototype(this);
        end
        function this = bbregisterNative(this)
            thisClone         = this.clone;
            thisClone.product = this.referenceImage;
            
            vtor      = mlsurfer.SurferVisitor.createFromBuilder(this);
            thisClone = vtor.visitBBRegisterNative(thisClone);
            this.dat  = thisClone.dat;
        end   	        
        function this = ensureBetted(this)
            this.product = mlfourd.ImagingContext.load( ...
                fullfile(this.fslPath, filename(this.T1_FILEPREFIX)));
            mad = mlmr.MRAlignmentDirector.factory( ...
                'product', this.product, 'referenceImage', this.product);
            this.product = mad.ensureBetted(this.product);
        end
        function [this,lhstat,rhstat] = surferRegisteredSegstats(this, varargin)
            p = inputParser;
            addRequired(p, 'prd',           @(x) isa(x, 'mlfourd.ImagingContext'));
            addOptional(p, 'fvoptions', '', @ischar);
            addOptional(p, 'perfMsk',   [], @(x) isa(x, 'mlfourd.ImagingContext'));
            parse(p, varargin{:});
            fprintf('mlsurfer.SurferBuilder.surferRegisteredSegstats.dat->%s\n', this.dat);
            this.product = p.Results.prd;
            
            vtor   = mlsurfer.SurferVisitor.createFromBuilder(this);
            this   = vtor.visitFreeviewAnatomicalVolume(this, p.Results.fvoptions);
            this   = vtor.visitIdSegstats(this, 'lh', p.Results.perfMsk);
            this   = vtor.visitIdSegstats(this, 'rh', p.Results.perfMsk);
            lhstat = this.segstats_fqfn(        'lh', p.Results.prd.fileprefix);
            rhstat = this.segstats_fqfn(        'rh', p.Results.prd.fileprefix);
        end         
        
        function fqfn = pialNative_fqfn(this, hemi)
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
            fqfn = fullfile(this.mriPath, [hemi 'PialNative']);
        end
        function fqfn = segstats_fqfn(this, varargin)
            p = inputParser;
            addOptional(p, 'hemi',       '', @ischar);
            addOptional(p, 'fileprefix', '', @ischar);
            parse(p, varargin{:});
            
            fqfn = fullfile(this.fslPath, [p.Results.hemi '_' p.Results.fileprefix this.segstats_suffix_]);
        end
        
 		function this = SurferBuilderPrototype(varargin) 
 			%% SURFERBUILDERPROTOTYPE 
            %  Usage:  this = SurferBuilderPrototype([aSurferBuilderPrototype]['parameter', 'value'])
            %                                         ^ for copy-ctor
            %                 parameters:  image, reference                     ^     
            %                     values:  any ImagingContext objects                        ^ 
            %          Alternatively assign this.product, this.referenceImage after construction.

            %% Copy ctor for cloning; required by prototype designs
 			this  = this@mlsurfer.SurferBuilder(); 
            if (1 == nargin && isa(varargin{1}, 'mlsurfer.SurferBuilderPrototype'))
                this.dat_              = varargin{:}.dat_;
                this.mask_             = varargin{:}.mask_;
                this.product_          = varargin{:}.product_;
                this.referenceImage_   = varargin{:}.referenceImage_;
                this.roi_              = varargin{:}.roi_;
                this.segmentation_     = varargin{:}.segmentation_;
                this.segstats_         = varargin{:}.segstats_;
                this.segstats_suffix_  = varargin{:}.segstats_suffix_;
                this.sessionPath_      = varargin{:}.sessionPath_;
                this.structural_       = varargin{:}.structural_;
                this.targetId_         = varargin{:}.targetId_;
                return
            end
            
            %% Input parsing
            import mlfsl.*;
            p = inputParser;
            p.KeepUnmatched = true;
            addParameter(p, 'dat',            '', @ischar);
            addParameter(p, 'fsaverage',      [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'mask',           [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'product',        [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'image',          [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'referenceImage', [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'reference',      [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'roi',            [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'segmentation',   [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'segstats',       [], @ischar);
            addParameter(p, 'segstatsSuffix', ...
                             mlsurfer.Parcellations.STATS_SUFFIX, ...
                                                   @ischar);
            addParameter(p, 'sessionPath',    [], @(x) isSessionPath(x));
            addParameter(p, 'structural',     [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(p, 'targetId', ...
                             'fsaverage',          @ischar);
            parse(p, varargin{:});
            this.dat_                = p.Results.dat;
            this.targetId_           = p.Results.fsaverage;
            this.product_            = p.Results.image;
            if (~isempty(p.Results.product))
                this.product_        = p.Results.product; end
            this.referenceImage_     = p.Results.reference;
            if (~isempty(p.Results.referenceImage))
                this.referenceImage_ = p.Results.referenceImage; end
            this.roi_                = p.Results.roi;
            this.segmentation_       = p.Results.segmentation;
            this.segstats_           = p.Results.segstats;
            this.segstats_suffix_    = p.Results.segstatsSuffix;
            this.sessionPath_        = p.Results.sessionPath; 
            this.targetId_           = p.Results.targetId;            
            if (~isempty(p.Results.mask))
                this.mask_           = p.Results.mask;
            else
                this.mask_ = imcast( ....
                    fullfile(this.fslPath, filename('bt1_default_mask')), ...
                    'mlfourd.ImagingContext');
            end
            if (~isempty(p.Results.structural))
                this.structural_     = p.Results.structural;
            else
                this.structural_ = imcast( ...
                    fullfile(this.fslPath, filename('bt1_default_restore')), ...
                    'mlfourd.ImagingContext');
            end 
            
            %% For freesurfer
            setenv('SUBJECTS_DIR', this.studyPath)
 		end 
    end 
    
    %% PROTECTED
    
    properties (Access = 'protected')
        dat_
        mask_
        product_
        referenceImage_
        roi_
        segmentation_
        segstats_
        segstats_suffix_
        sessionPath_
        structural_
        t1_
        t2_
        targetId_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

