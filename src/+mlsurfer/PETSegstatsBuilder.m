classdef PETSegstatsBuilder < mlsurfer.SurferBuilderPrototype
	%% PETSEGSTATSBUILDER   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

    properties (Constant)
        HO_MEANVOL_FILEPREFIX = mlpet.O15Builder.HO_MEANVOL_FILEPREFIX
        OO_MEANVOL_FILEPREFIX = mlpet.O15Builder.OO_MEANVOL_FILEPREFIX
        OC_FILEPREFIX         = [mlpet.O15Builder.OC_FILEPREFIX '_131315fwhh']
        OEFNQ_FILEPREFIX      = 'oefnq_default_161616fwhh'
        TR_FILEPREFIX         = mlpet.O15Builder.TR_FILEPREFIX
        ALIGN_WITH_TR         = true
        NORM_BY_DOSE_SUFFIX   = '_normByDose'
    end
    
	properties (Dependent)
        hoMeanvol
        oc
        ooMeanvol
        o15Composite
        tr        
    end 

    methods %% GET/SET
        function ic   = get.hoMeanvol(this)
            if (~isempty(this.hoMeanvol_))
                ic = this.hoMeanvol_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.HO_MEANVOL_FILEPREFIX)));
        end
        function this = set.hoMeanvol(this, obj)
            this.hoMeanvol_ = mlfourd.ImagingContext(obj);
        end
        function c    = get.o15Composite(this)
            if (this.ALIGN_WITH_TR)
                if (lexist(this.oc.fqfilename, 'file'))
                    c = mlfourd.ImagingComposite.load( ...
                        {this.oc this.ooMeanvol this.hoMeanvol this.tr});
                else
                    c = mlfourd.ImagingComposite.load( ...
                                {this.ooMeanvol this.hoMeanvol this.tr});
                end
            else
                if (lexist(this.oc.fqfilename, 'file'))
                    c = mlfourd.ImagingComposite.load( ...
                        {this.oc this.ooMeanvol this.hoMeanvol});
                else
                    c = mlfourd.ImagingComposite.load( ...
                                {this.ooMeanvol this.hoMeanvol});
                end
            end
        end
        function ic   = get.oc(this)
            if (~isempty(this.oc_))
                ic = this.oc_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.OC_FILEPREFIX)));
        end
        function this = set.oc(this, obj)
            this.oc_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.ooMeanvol(this)
            if (~isempty(this.ooMeanvol_))
                ic = this.ooMeanvol_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.OO_MEANVOL_FILEPREFIX)));
        end
        function this = set.ooMeanvol(this, obj)
            this.ooMeanvol_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.tr(this)
            if (~isempty(this.tr_))
                ic = this.tr_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.TR_FILEPREFIX)));
        end
        function this = set.tr(this, obj)
            this.tr_ = mlfourd.ImagingContext(obj);
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
                    fprintf('PETSegstatsBuilder.fsanatomicalStatsForStudy working in %s\n', dt.fqdns{d});
                    ssb = mlsurfer.PETSegstatsBuilder('SessionPath', dt.fqdns{d});
                    ssb.fsanatomicalStats;
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
        function sessions = fsanatomicalStatsPrealignedForStudy(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            sessions = {};
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('PETSegstatsBuilder.fsanatomicalStatsForStudy working in %s\n', dt.fqdns{d});
                    ssb = mlsurfer.PETSegstatsBuilder('SessionPath', dt.fqdns{d});
                    ssb.fsanatomicalStatsPrealigned;
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
        function            fsanatomicalStatsRevisions(studyPth, sessionsList)
            cd(studyPth);
            assert(iscell(sessionsList));
            for d = 1:length(sessionsList)
                try
                    sessPth = fullfile(studyPth, sessionsList{d}, '');
                    cd(sessPth);
                    fprintf('PETSegstatsBuilder.fsanatomicalStatsRevisions is working in %s\n', sessPth);
                    ssb = mlsurfer.PETSegstatsBuilder('SessionPath', sessPth);
                    ssb.fsanatomicalStats;
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
    end
    
	methods  
        function this    = alignPET(this)
            petad = mlpet.PETAlignmentDirector.factory( ...
                   'product', this.product, 'referenceImage', this.referenceImage);
            this  = petad.filterPETOptimally(this);
            if (this.ALIGN_WITH_TR)
                this = petad.alignPETUsingTransmission(this);
            else
                this = petad.alignPETSequentially(this);
            end
            cd(this.sessionPath);
        end
        function statfns = fsanatomicalStats(this)
            this    = this.alignPET;
            statfns = this.fsanatomicalStatsAppended;
            cd(this.sessionPath);
        end
        function statfns = fsanatomicalStatsPrealigned(this)
            import mlfourd.* mlsurfer.*;
            this.product = ImagingComposite.load( ...
                           { ImagingContext.load(fullfile(this.fslPath, filename([this.OC_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX]))) ...
                             ImagingContext.load(fullfile(this.fslPath, filename([this.OO_MEANVOL_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX]))) ...
                             ImagingContext.load(fullfile(this.fslPath, filename([this.HO_MEANVOL_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX]))) });
            statfns      = this.fsanatomicalStatsAppended;
        end
        function statfns = fsanatomicalStatsAppended(this)
            this  = this.appendOefToProduct;
            assert(isa(this.product, 'mlfourd.ImagingComponent') || ...
                   isa(this.product, 'mlfourd.ImagingContext'));            
             
            statfns = this.fsanatomicalStatsForProducts(this.product);
        end  
        function statfns = fsanatomicalStatsForProducts(this, prods)
            prods   = mlfourd.ImagingContext(prods);
            this = this.ensureDat;
            
            import mlpatterns.* mlsurfer.*;
            statfns  = CellArrayList;
            this.dat = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            for p = 1:length(prods)
                aProd = prods{p};
                aProd = this.ensureOnT1Default(aProd);
                if (~lstrfind(aProd.fileprefix, this.OEFNQ_FILEPREFIX))
                    aProd = this.normalizePETByTotalDose(aProd); end
                [~,lhstat,rhstat] = this.surferRegisteredSegstats( ...
                                    mlfourd.ImagingContext(aProd), ...
                                    ':colormap=heat:heatscale=0,2,6:heatscaleoptions=truncate:opacity=0.5');
                statfns.add(lhstat);
                statfns.add(rhstat);
            end
        end 
        function this    = ensureDat(this)
            import mlsurfer.*;
            this.dat = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            if (~lexist(this.dat, 'file'))
                this = this.bbregisterNative; end 
        end
        function nii     = ensureOnT1Default(~, nii)
            import mlsurfer.*;
            if (~lstrfind(nii.fileprefix, ['_on_' SurferFilesystem.T1_FILEPREFIX]))
                nii = mlfourd.NIfTI.load( ...
                    fullfile(nii.filepath, [nii.fileprefix '_on_' SurferFilesystem.T1_FILEPREFIX '.nii.gz']));
            end
        end
        function this    = appendOefToProduct(this)
            import mlfourd.* mlsurfer.*;
            oeffp        = this.constructOEF;
            petAlignBldr = mlpet.PETAlignmentBuilder( ...
                'product',        ImagingContext.load(fullfile(this.fslPath, filename(oeffp))), ...
                'referenceImage', ImagingContext.load(fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX))), ...
                'xfm',                                fullfile(this.fslPath, [this.HO_MEANVOL_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX '.mat']));
            petAlignBldr = petAlignBldr.buildTransformed;
            prd          = mlfourd.ImagingContext(this.product);
            this.product = prd.add(petAlignBldr.product); 
        end
        function fp      = constructOEF(this)
            import mlsurfer.*;
            pwd0 = pwd;
            cd(this.fslPath);
            fp = this.OEFNQ_FILEPREFIX;   
            this.ensureXfmForOef(this.HO_MEANVOL_FILEPREFIX, SurferFilesystem.T1_FILEPREFIX);
            this.ensureXfmForOef(this.OO_MEANVOL_FILEPREFIX, SurferFilesystem.T1_FILEPREFIX);
            mlpet.NonquantitativeCOSS.constructOEF('OO',            this.ooMeanvol, ...
                                                   'HO',            this.hoMeanvol, ...
                                                   'OEFFileprefix', fullfile(this.fslPath, filename(fp)));
            cd(pwd0);                                               
        end
        function product = normalizePETByTotalDose(this, product)
            product            = imcast(product, 'mlfourd.NIfTI');
            product.img        = product.img * prod(product.size) / product.dipsum;
            product.fileprefix = [product.fileprefix this.NORM_BY_DOSE_SUFFIX];
            product.save;
            product            = mlfourd.ImagingContext(product);
        end
        
 		function this    = PETSegstatsBuilder(varargin)
 			%% PETSEGSTATSBUILDER 
 			%  Usage:  this = PETSegstatsBuilder([...]) 
            %                                     ^ cf. SurferBuilderPrototype

            this = this@mlsurfer.SurferBuilderPrototype(varargin{:});
            import mlsurfer.*;
            this.product_ = this.o15Composite;
            this.referenceImage = fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX));
 		end 
    end 

    %% PRIVATE
    
    properties (Access = 'private')
        hoMeanvol_
        oc_
        ooMeanvol_
        tr_        
    end
    
    methods (Access = 'private')
        function ensureXfmForOef(this, petFp, refFp)
            if (~lexist(fullfile(this.fslPath, [petFp '_on_' refFp '.mat']), 'file'))
                try
                    this.concatXfmsForOef( ...
                        fullfile(this.fslPath, [petFp '_on_' this.TR_FILEPREFIX '_131315fwhh' '.mat']), ...
                        fullfile(this.fslPath, [this.TR_FILEPREFIX '_131315fwhh' '_on_' refFp '.mat']));
                catch ME
                    handexcept(ME);
                end
            end
        end
        function concatXfmsForOef(this, x1, x2)
            %% KLUDGE
           
            mlbash(sprintf('convert_xfm -omat %s -concat %s %s', this.concatted(x1, x2), x1, x2))
        end
        function x12 = concatted(~, x1, x2)
            %% KLUDGE
            
            import mlchoosers.*;
            [pth,x1] = fileparts(x1);
                 x1  = ImagingChoosers.splitFilename(x1);            
            [~,  x2] = fileparts(x2);
                 x2  = ImagingChoosers.splitFilename(x2);
                 x12 = fullfile(pth, [x1{1} '_on_' x2{2} '.mat']);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

