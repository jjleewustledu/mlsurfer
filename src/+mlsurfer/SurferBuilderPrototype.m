classdef SurferBuilderPrototype < mlsurfer.SurferBuilder
	%% SURFERBUILDERPROTOTYPE

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
    
    methods (Static)
        function checkHemi(hemi)
            assert(ischar(hemi));
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
        end
        function freeviewAll(sessPth)
            import mlsurfer.*;
            this = SurferBuilderPrototype('SessionPath', sessPth);
            this.product = mlfourd.ImagingContext( ...
                fullfile(this.sessionPath, 'fsl', filename(SurferFilesystem.T1_FILEPREFIX)));
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
        
        %% SET/GET
        
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
            this.mask_ = mlfourd.ImagingContext(img);
        end
        function img  = get.mask(this)
            assert(~isempty(this.mask_));
            img = mlfourd.ImagingContext(this.mask_);
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
            img = mlfourd.ImagingContext(this.product_);
        end
        function this = set.referenceImage(this, img)
            this.referenceImage_ = mlfourd.ImagingContext(img);
        end
        function img  = get.referenceImage(this)
            assert(~isempty(this.referenceImage_));
            img = mlfourd.ImagingContext(this.referenceImage_);
        end
        function this = set.roi(this, img)
            this.roi_ = mlfourd.ImagingContext(img);
        end
        function img  = get.roi(this)
            assert(~isempty(this.roi_));
            img = mlfourd.ImagingContext(this.roi_);
        end
        function this = set.segmentation(this, img)
            this.segmentation_ = mlfourd.ImagingContext(img);
        end
        function img  = get.segmentation(this)
            assert(~isempty(this.segmentation_));
            img = mlfourd.ImagingContext(this.segmentation_);
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
            this.structural_ = mlfourd.ImagingContext(img);
        end
        function img  = get.structural(this)
            if (isempty(this.structural_))
                img = mlfourd.ImagingContext(this.referenceImage_); return; end
            img = mlfourd.ImagingContext(this.structural_);
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
            this.t2_ = mlfourd.ImagingContext(obj);
        end
        function id   = get.targetId(this)
            assert(~isempty(this.targetId_));
            [~,id] = fileparts(trimpath(this.targetId_));
        end
        
        %%
        
        function this   = bbregisterNative(this)
            thisClone         = this.clone;
            thisClone.product = this.referenceImage;
            
            vtor      = mlsurfer.SurferVisitor.createFromBuilder(this);
            thisClone = vtor.visitBBRegisterNative(thisClone);
            this.dat  = thisClone.dat;
        end   	  
        function obj    = clone(this)
            obj = mlsurfer.SurferBuilderPrototype(this);
        end
        function ic     = defaultMask(this)
            %ic = mlfourd.ImagingContext(fullfile(this.fslPath, filename('bt1_default_mask')))
            ic = mlfourd.ImagingContext(fullfile(this.mriPath, 'brainmask.mgz'));
            ic = ic.binarized;
            
        end
        function ic     = defaultT1(this)
            %ic = mlfourd.ImagingContext(fullfile(this.fslPath, filename('bt1_default_restore')));
            ic = mlfourd.ImagingContext(fullfile(this.mriPath, 'T1.mgz'));
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
        function fqfn   = pialNative_fqfn(this, hemi)
            fqfn = this.surferFs_.pialNative_fqfn(hemi);
        end
        function fqfn   = segstats_fqfn(this, varargin)
            fqfn = this.surferFs_.segstats_fqfn(varargin{:});
        end
        function [mm,p] = sessionPathParts(this, pth)
            [mm,p] = this.surferFs_.sessionPathParts(pth);
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
                this.sessionData_      = varargin{:}.sessionData_;
                this.structural_       = varargin{:}.structural_;
                this.targetId_         = varargin{:}.targetId_;
                this.surferFs_         = varargin{:}.surferFs_;
                return
            end
            
            %% Input parsing
            import mlfsl.* mlsurfer.*;
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'dat',            '', @ischar);
            addParameter(ip, 'fsaverage',      [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'mask',           [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'product',        [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'image',          [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'referenceImage', [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'reference',      [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'roi',            [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'segmentation',   [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'segstats',       [], @ischar);
            addParameter(ip, 'sessionData',    [], @(x) isa(x, 'mlpipeline.ISessionData'));
            addParameter(ip, 'sessionPath',    [], @ischar);
            addParameter(ip, 'structural',     [], @(x) isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'targetId', ...
                            'fsaverage',          @ischar);
            parse(ip, varargin{:});
            
            this.sessionData_        = ip.Results.sessionData;
            this.dat_                = ip.Results.dat;
            this.targetId_           = ip.Results.fsaverage;
            this.product_            = ip.Results.image;
            if (~isempty(ip.Results.product))
                this.product_        = ip.Results.product; end
            this.referenceImage_     = ip.Results.reference;
            if (~isempty(ip.Results.referenceImage))
                this.referenceImage_ = ip.Results.referenceImage; end
            this.roi_                = ip.Results.roi;
            this.segmentation_       = ip.Results.segmentation;
            this.segstats_           = ip.Results.segstats;
            this.surferFs_           = SurferFilesystem(ip.Results.sessionPath); 
            this.targetId_           = ip.Results.targetId;            
            if (~isempty(ip.Results.mask))
                this.mask_ = ip.Results.mask;
            else
                this.mask_ = this.defaultMask;
            end
            if (~isempty(ip.Results.structural))
                this.structural_ = ip.Results.structural;
            else
                this.structural_ = this.defaultT1;
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
        sessionData_
        sessionPath_
        structural_
        surferFs_
        t1_
        t2_     
        targetId_   
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

