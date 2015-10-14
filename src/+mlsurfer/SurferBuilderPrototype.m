classdef SurferBuilderPrototype < mlsurfer.SurferBuilder
	%% SURFERBUILDERPROTOTYPE is a concrete prototype of SurferBuilder.  It may be cloned for dynamic creation of
    %  configurable, structurally varying classes at run-time.  It uses SurferFilesystem by composition for
    %  stereotypical filesystem operations needed by the mlsurfer package.  
    %  See also:  SurferFilesystem, GoF.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 
    
	properties (Dependent)
        fslPath
        labelPath
        mmnum
        mriPath
        perfPath
        pnum
        sessionId
        sessionPath
        sessionRegexp
        statsPath
        studyPath
        surfPath
        
        datSuffix
        statsSuffix
        t1Prefix
        t2Prefix
        
        dat
        mask
        orig
        product
        referenceImage
        roi
        segmentation
        segstats
        structural
        t1
        t2
        targetId
    end 
    
    methods %% SET/GET
        function pth  = get.fslPath(this)
            pth = this.surferFs_.fslPath;
        end
        function pth  = get.labelPath(this)
            pth = this.surferFs_.labelPath;
        end
        function m    = get.mmnum(this)
            m = this.surferFs_.mmnum;
        end
        function pth  = get.mriPath(this)
            pth = this.surferFs_.mriPath;
        end
        function pth  = get.perfPath(this)
            pth = this.surferFs_.perfPath;
        end
        function p    = get.pnum(this)
            p = this.surferFs_.pnum;
        end
        function id   = get.sessionId(this)
            id = this.surferFs_.sessionId;
        end
        function this = set.sessionId(this, id)
            this.surferFs_.sessionId = id;
        end
        function pth  = get.sessionPath(this)
            pth = this.surferFs_.sessionPath;
        end
        function this = set.sessionPath(this, pth)
            this.surferFs_.sessionPath = pth;
        end
        function x = get.sessionRegexp(this)
            x = this.surferFs_.sessionRegexp;
        end
        function pth  = get.statsPath(this)
            pth = this.surferFs_.statsPath;
        end
        function pth  = get.studyPath(this)
            pth = this.surferFs_.studyPath;
        end
        function pth  = get.surfPath(this)
            pth = this.surferFs_.surfPath;
        end        
        
        function x    = get.datSuffix(this)
            x = this.surferFs_.datSuffix;
        end
        function x    = get.statsSuffix(this)
            x = this.surferFs_.statsSuffix;
        end
        function x    = get.t1Prefix(this)
            x = this.surferFs_.t1Prefix;
        end
        function x    = get.t2Prefix(this)
            x = this.surferFs_.t2Prefix;
        end
        
        function x    = get.dat(this)
            import mlsurfer.*;
            if (isempty(this.dat_))
                x = SurferFilesystem.datFilename(this.fslPath, this.product.fileprefix); 
                return
            end
            x = this.dat_;
        end
        function this = set.dat(this, x)
            import mlsurfer.*;
            if (~lstrfind(x, this.datSuffix));
                x = SurferFilesystem.datFilename('', x); end
            this.dat_ = x;
        end
        function this = set.mask(this, img)
            this.mask_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.mask(this)
            assert(~isempty(this.mask_));
            img = imcast(this.mask_, 'mlfourd.ImagingContext');
        end
        function ic   = get.orig(this)
            ic = mlfourd.ImagingContext.load( ...
                 fullfile(this.mriPath, 'orig.mgz'));
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
        function this = set.structural(this, img)
            this.structural_ = imcast(img, 'mlfourd.ImagingContext');
        end
        function img  = get.structural(this)
            if (isempty(this.structural_))
                img = imcast(this.referenceImage_, 'mlfourd.ImagingContext'); return; end
            img = imcast(this.structural_, 'mlfourd.ImagingContext');
        end
        function this = set.targetId(this, id)
            assert(ischar(id));
            assert(lexist(fullfile(this.studyPath, id), 'dir'));
            this.targetId_ = id;
        end
        function ic   = get.t1(this)
            import mlsurfer.*;
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX)));
        end
        function ic   = get.t2(this)
            if (~isempty(this.t2_))
                ic = this.t2_; return; end
            import mlsurfer.*;
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(SurferFilesystem.T2_FILEPREFIX)));
        end
        function this = set.t2(this, obj)
            this.t2_ = imcast(obj, 'mlfourd.ImagingContext');
        end
        function id   = get.targetId(this)
            assert(~isempty(this.targetId_));
            [~,id] = fileparts(trimpath(this.targetId_));
        end
    end
    
    methods (Static)
        function checkHemi(hemi)
            assert(ischar(hemi));
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
        end
        function freeviewAll(sessPth)
            import mlsurfer.*;
            this = SurferBuilderPrototype('SessionPath', sessPth);
            this.product = imcast( ...
                fullfile(this.sessionPath, 'fsl', filename(SurferFilesystem.T1_FILEPREFIX)), ...
                'mlfourd.ImagingContext');
            cd(this.sessionPath);
            vtor = SurferVisitor.createFromBuilder(this);
            vtor.visitFreeviewAll(this);
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
    end

	methods  		 
        function obj    = clone(this)
            obj = mlsurfer.SurferBuilderPrototype(this);
        end
        function this   = bbregisterNative(this)
            thisClone         = this.clone;
            thisClone.product = this.referenceImage;
            
            vtor      = mlsurfer.SurferVisitor.createFromBuilder(this);
            thisClone = vtor.visitBBRegisterNative(thisClone);
            this.dat  = thisClone.dat;
        end   	        
        function this   = ensureBetted(this)
            import mlsurfer.*;
            this.product = mlfourd.ImagingContext.load( ...
                fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX)));
            mad = mlmr.MRAlignmentDirector.factory( ...
                'product', this.product, 'referenceImage', this.product);
            this.product = mad.ensureBetted(this.product);
        end     
        function tf     = isaSessionPath(this, pth)
            tf = this.surferFs_.isaSessionPath(pth);
        end
        function [mm,p] = sessionPathParts(this, pth)
            [mm,p] = this.surferFs_.sessionPathParts(pth);
        end
        function fqfn   = pialNative_fqfn(this, hemi)
            fqfn = this.surferFs_.pialNative_fqfn(hemi);
        end
        function fqfn   = segstats_fqfn(this, varargin)
            fqfn = this.surferFs_.segstats_fqfn(varargin{:});
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
                this.structural_       = varargin{:}.structural_;
                this.targetId_         = varargin{:}.targetId_;
                this.surferFs_         = varargin{:}.surferFs_;
                return
            end
            
            %% Input parsing
            import mlfsl.* mlsurfer.*;
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
            addParameter(p, 'sessionPath',    [], @ischar);
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
            this.surferFs_           = SurferFilesystem(p.Results.sessionPath); 
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
        sessionPath_
        structural_
        t1_
        t2_
        targetId_
        
        surferFs_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

