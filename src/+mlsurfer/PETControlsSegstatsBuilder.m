classdef PETControlsSegstatsBuilder < mlsurfer.SurferBuilderPrototype
	%% PETCONTROLSSEGSTATSBUILDER ... 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.3.0.73043 (R2014a) 
 	%  $Id$  	 

    properties (Constant)
        OEFNQ_FILEPREFIX    = 'oefnq_default_101010fwhh'
        ALIGN_WITH_TR       = false
        NORM_BY_DOSE_SUFFIX = '_normByDose'
        SESSION_PATTERN     = 'p*' % for use by DirTool
    end
    
	    
	properties (Dependent)
        hoMeanvol
        hoFileprefix
        oc
        ocFileprefix
        ooMeanvol
        ooFileprefix
        o15Composite
        oefnqFileprefix
        pNumber
        t1Prefix
        tisPrefix
        tr        
    end 

    methods %% GET/SET
        function this = set.hoMeanvol(this, obj)
            this.hoMeanvol_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.hoMeanvol(this)
            if (~isempty(this.hoMeanvol_))
                ic = this.hoMeanvol_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.hoFileprefix)));
        end
        function fp   = get.hoFileprefix(this)
            fp = ['r' this.pNumber 'ho1_g3'];
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
        function this = set.oc(this, obj)
            this.oc_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.oc(this)
            if (~isempty(this.oc_))
                ic = this.oc_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.ocFileprefix)));
        end
        function fp   = get.ocFileprefix(this)
            fp = ['r' this.pNumber 'oc1_g3'];
        end
        function this = set.ooMeanvol(this, obj)
            this.ooMeanvol_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.ooMeanvol(this)
            if (~isempty(this.ooMeanvol_))
                ic = this.ooMeanvol_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.ooFileprefix)));
        end
        function fp   = get.ooFileprefix(this)
            fp = ['r' this.pNumber 'oo1_g3'];
        end
        function fp   = get.oefnqFileprefix(this)
            fp = this.OEFNQ_FILEPREFIX;
        end
        function p    = get.pNumber(this)
            [~,p] = fileparts(this.sessionPath);
            assert(strcmp('p', p(1)));
            assert(5 == length(p));
        end
        function fp   = get.t1Prefix(this) %#ok<MANU>
            fp = 'MNI152_T1_1mm_brain';
        end
        function fp   = get.tisPrefix(this)
            fp = ['r' this.pNumber 'tis_thr'];
        end
        function ic   = get.tr(this)
            if (~isempty(this.tr_))
                ic = this.tr_; return; end
            error('mlsurfer:unsupportedParam', ...
                  'PETControlsSegstatsBuilder.get.tr was requested, but this class does not implement tr');
        end
        function this = set.tr(this, obj)
            this.tr_ = mlfourd.ImagingContext(obj);
        end
    end
    
    methods (Static)        
        function sessions = fsanatomicalStatsForStudy(varargin)
            %% FSANATOMICALSTATSFORSTUDY
            %  Usage:   sessions_list = PETControlsSegstatsBuilder.fsanatomicalStatsForStudy([...])
            %           ^ cell array of traversed session folders
            %                                                  'studyPath', a directory path ^ 
            %                                                         'doAlignment', logical ^
            
            p = inputParser;
            addOptional(p, 'studyPath',   pwd,   @isdir);
            addOptional(p, 'doAlignment', false, @islogical);
            parse(p, varargin{:});
            
            cd(p.Results.studyPath);
            dt = mlsystem.DirTools(mlsurfer.PETControlsSegstatsBuilder.SESSION_PATTERN);
            sessions = {};
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('PETControlsSegstatsBuilder.fsanatomicalStatsForStudy working in %s\n', dt.fqdns{d});
                    ssb = mlsurfer.PETControlsSegstatsBuilder('SessionPath', dt.fqdns{d});
                    ssb.fsanatomicalStats(p.Results.doAlignment);
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
    end
    
	methods  
        function statfns = fsanatomicalStats(this, varargin)
            p = inputParser;
            addOptional(p, 'doAlignment', false, @islogical);
            parse(p, varargin{:});
            
            if (p.Results.doAlignment)
                this = this.alignPET; 
            else
                this = this.loadPrealignedProduct; 
            end
            statfns  = this.fsanatomicalStatsAppended;
            cd(this.sessionPath);
        end
        function statfns = fsanatomicalStatsPrealigned(this)
            statfns = this.fsanatomicalStats(false);
        end        
        function this    = alignPET(this)
            petad = mlpet.PETAlignmentDirector.factory( ...
                                               'product', this.product, ... 
                                               'referenceImage', this.referenceImage);
            this  = petad.filterPETOptimally(this);
            if (this.ALIGN_WITH_TR)
                this = petad.alignPETUsingTransmission(this);
            else
                this = petad.alignPETSequentially(this);
            end
            cd(this.sessionPath);
        end
        function this    = loadPrealignedProduct(this)
            import mlfourd.*;
            this.product = ImagingComposite.load( ...
                           { ImagingContext.load(fullfile(this.fslPath, filename([this.ooFileprefix '_on_' this.t1Prefix]))) ...
                             ImagingContext.load(fullfile(this.fslPath, filename([this.hoFileprefix '_on_' this.t1Prefix]))) });            
        end
        function statfns = fsanatomicalStatsAppended(this)
            this  = this.appendOefToProduct;
            assert(isa(this.product, 'mlfourd.ImagingComponent') || ...
                   isa(this.product, 'mlfourd.ImagingContext'));            
             
            statfns = this.fsanatomicalStatsForProducts(this.product);
        end  
        function this    = appendOefToProduct(this)
            import mlfourd.*;
            oeffp        = this.constructOEF;
            petAlignBldr = mlpet.PETAlignmentBuilder( ...
                'product',        ImagingContext.load(fullfile(this.fslPath, filename(oeffp))), ...
                'referenceImage', ImagingContext.load(fullfile(this.fslPath, filename(this.t1Prefix))), ...
                'xfm',                                fullfile(this.fslPath, [this.hoFileprefix '_on_' this.t1Prefix '.mat']));
            petAlignBldr = petAlignBldr.buildTransformed;
            prd          = mlfourd.ImagingContext(this.product);
            this.product = prd.add(petAlignBldr.product); 
        end
        function fp      = constructOEF(this)
            pwd0 = pwd;
            cd(this.fslPath);
            fp = this.oefnqFileprefix;   
            this.ensureXfmForOef(this.hoFileprefix, this.t1Prefix);
            this.ensureXfmForOef(this.ooFileprefix, this.t1Prefix);
            if (~lexist(fullfile(this.fslPath, filename([this.oefnqFileprefix '_on_' this.t1Prefix]))))
                mlpet.NonquantitativeCOSS.constructOEF('OO',            this.ooMeanvol, ...
                                                       'HO',            this.hoMeanvol, ...
                                                       'OEFFileprefix', fullfile(this.fslPath, filename(fp)), ...
                                                       'Workpath',      this.fslPath);
            end
            cd(pwd0);
        end
        function statfns = fsanatomicalStatsForProducts(this, prods)
            prods = mlfourd.ImagingContext(prods);
            this  = this.ensureDat;
            
            import mlpatterns.* mlsurfer.*;
            statfns  = CellArrayList;
            this.dat = SurferFilesystem.datFilename(this.fslPath, this.t1Prefix);
            for p = 1:length(prods)
                aProd = prods{p};
                aProd = this.ensureOnT1Default(aProd);
                if (~lstrfind(aProd.fileprefix, this.oefnqFileprefix))
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
            this.dat = SurferFilesystem.datFilename(this.fslPath, this.t1Prefix);
            if (~lexist(this.dat, 'file'))
                this = this.bbregisterNative; end 
        end
        function nii     = ensureOnT1Default(this, nii)
            if (~lstrfind(nii.fileprefix, ['_on_' this.t1Prefix]))
                nii = mlfourd.NIfTI.load( ...
                    fullfile(nii.filepath, filename([nii.fileprefix '_on_' this.t1Prefix])));
            end
        end
        function product = normalizePETByTotalDose(this, product)
            product            = imcast(product, 'mlfourd.NIfTI');
            product.img        = product.img * prod(product.size) / product.dipsum;
            product.fileprefix = [product.fileprefix this.NORM_BY_DOSE_SUFFIX];
            product.save;
            product            = mlfourd.ImagingContext(product);
        end
        
 		function this    = PETControlsSegstatsBuilder(varargin)
 			%% PETSEGSTATSBUILDER 
 			%  Usage:  this = PETControlsSegstatsBuilder([...]) 
            %                                            ^ cf. SurferBuilderPrototype

            this = this@mlsurfer.SurferBuilderPrototype(varargin{:});
            this.product_ = this.o15Composite;
            this.referenceImage = fullfile(this.fslPath, filename(this.t1Prefix));
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
                        fullfile(this.fslPath, [petFp '_on_' this.tisPrefix '.mat']), ...
                        fullfile(this.fslPath, [this.tisPrefix '_on_' refFp '.mat']));
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

