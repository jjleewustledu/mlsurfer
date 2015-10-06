classdef SurferRois < mlrois.AbstractRois
	%% SURFERROIS generates freesurfer data based on user-defined ROIs
    %  May require subsequent implementation of http://surfer.nmr.mgh.harvard.edu/fswiki/VolumeRoiCorticalThickness
    
	%  $Revision: 2541 $
 	%  was created $Date: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferRois.m $, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id: SurferRois.m 2541 2013-08-18 23:13:31Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

    properties (Dependent)
        aparcIndexedRois
        aparcIndices
        aparcFileprefix
        aparcSeparatedRois     
        atlasFolder
        atlasFileprefix
        averageSurfPath
        Destrieux
        DestrieuxNoDot
        extraParenchymalRoi
        hemisLabels
        maskFileprefix   
        rememberSeparatedRois
        saveSeparatedRois
        separatedRoiFileprefix
        structuralFileprefix
        thicknessMap
    end
    
    methods (Static)
        function this = createFromSessionPath(sessPth)
            this = mlsurfer.SurferRois();
            this.sessionPath = sessPth;
        end
        function h    = index2hemisphere(idx)
            %% INDEX2HEMISPHERE returns 'unpaired', 'unknown', 'lh' or 'rh'
            %  hemisphere = this.index2hemisphere(index)
            %  ^ string                                 ^ integer
            
            import mlsurfer.*
            if (idx < 1)
                h = ''; return
            end
            if (SurferRois.START_INDEX_UNPAIRED <= idx && idx < SurferRois.START_INDEX_CORTEX)
                h = ''; return; 
            end

            if (idx < SurferRois.START_INDEX_UNPAIRED)
                %% subcortical
                if (idx < (SurferRois.START_INDEX_SUBCORTEX + SurferRois.DELTA_INDEX_SUBCORTEX))
                    h = 'lh'; return; 
                end
                h = 'rh'; return
            end
            
                %% cortex
                if (idx < (SurferRois.START_INDEX_CORTEX + SurferRois.DELTA_INDEX_CORTEX))
                    h = 'lh'; return
                end
                h = 'rh';
        end
    end
    
    methods %% Set/Get
        function this  = set.aparcIndexedRois(this, air)
            this.aparcIndexedRois_ = imcast(air, 'mlfourd.NIfTI');
        end
        function nii   = get.aparcIndexedRois(this)
            import mlfourd.*;
            if (isempty(this.aparcIndexedRois_))
                ic = this.makeImageAsNeeded( ...
                    fullfile(this.fslPath, this.aparcFileprefix), ...
                    'makeAparcWithExclusions');
                this.aparcIndexedRois_ = ic.nifti;
            end
            assert(isa(this.aparcIndexedRois_, 'mlfourd.NIfTIInterface'));
            nii = this.aparcIndexedRois_;
        end
        function this  = set.aparcIndices(this, ai)
            assert(isnumeric(ai));
            this.aparcIndices_ = ai;
        end
        function ind   = get.aparcIndices(this)
            assert(isnumeric(this.aparcIndices_), 'SurferRois:  generate aparcIndexedRois and aparcIndices by first running method aparcIndicesAndRois');
            assert(~isempty(this.aparcIndices_),  'SurferRois:  generate aparcIndexedRois and aparcIndices by first running method aparcIndicesAndRois');
            ind = this.aparcIndices_;
        end
        function lbl   = get.aparcFileprefix(this)
            lbl = ['aparc_a2009s+aseg_on_' this.structuralFileprefix];
        end
        function imcmp = get.aparcSeparatedRois(this)
            assert(~isempty(this.aparcSeparatedRois_));
            assert(isa(this.aparcSeparatedRois_, 'mlfourd.ImagingComponent'));
            imcmp = this.aparcSeparatedRois_;
        end
        function fldr  = get.atlasFolder(this) %#ok<MANU>
            fldr = 'fsl';
        end
        function fp    = get.atlasFileprefix(this)
            fp = this.aparcFileprefix;
        end
        function adir  = get.averageSurfPath(this)
            adir = fullfile(this.studyPath, this.AVER_ID, 'surf');
        end
        function fp    = get.Destrieux(this)
            fp = this.DESTRIEUX_FILEPREFIX;
        end
        function fp    = get.DestrieuxNoDot(this)
            [a,b] = strtok(this.Destrieux, '.');
            fp = [a '_' b(2:end)];
        end
        function ic    = get.extraParenchymalRoi(this) %#ok<MANU>
            import mlrois.*;
            csf   = CsfRois;
            brain = ParenchymaRois; 
            nii   = ~brain.mask | csf.mask;
            nii.fileprefix = 'extraParenchymal';
            nii.save;
            ic = mlfourd.ImagingContext.load(nii);
        end
        function cll   = get.hemisLabels(this)
            cll = this.HEMISPHERES_LABELS;
        end
        function fp    = get.maskFileprefix(this) %#ok<MANU>
            fp = 'bt1_default_mask';
        end
        function this  = set.rememberSeparatedRois(this, tf)
            if (islogical(tf))
                this.rememberSeparatedRois_ = tf; end
        end
        function tf    = get.rememberSeparatedRois(this)
            tf = this.rememberSeparatedRois_;
        end
        function this  = set.saveSeparatedRois(this, tf)
            if (islogical(tf))
                this.saveSeparatedRois_ = tf; end
        end
        function tf    = get.saveSeparatedRois(this)
            tf = this.saveSeparatedRois_;
        end
        function fp    = get.separatedRoiFileprefix(this)
            fp = this.INDEXED_ROI_PREFIX;
        end
        function fp    = get.structuralFileprefix(this) %#ok<MANU>
            fp = 't1_default';
        end
        function mp    = get.thicknessMap(this)
            if (isempty(this.thicknessMap_))
                this.thicknessMap_ = this.surferSegstatsOnTargetId; end
            mp = this.thicknessMap_;
        end
    end
    
    methods
        function                         mgh2nifti(~, mfp, nfp)
            mfp = fileprefix(mfp, '.mgh');
            nfp = fileprefix(nfp, '.nii.gz');
            mlbash(sprintf('mri_convert %s.mgh %s.nii.gz', mfp, nfp));
        end
        function                         mgz2nifti(~, mfp, nfp)
            mfp = fileprefix(mfp, '.mgz');
            nfp = fileprefix(nfp, '.nii.gz');
            mlbash(sprintf('mri_convert %s.mgz %s.nii.gz', mfp, nfp));
        end
        function                         registerAparcOnRawavg(this)
            mlbash( ...
                sprintf('mri_label2vol --seg %s --temp %s --o %s --regheader %s', ...
                    fullfile(this.mriPath, [this.Destrieux '.mgz']), ...
                    fullfile(this.mriPath, 'rawavg.mgz'), ...
                    fullfile(this.mriPath, [this.Destrieux '_on_rawavg.mgz']), ...
                    fullfile(this.mriPath, [this.Destrieux '.mgz'])));
            this.mgz2nifti( ...
                    fullfile(this.mriPath, [this.Destrieux '_on_rawavg']), ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_rawavg']));
            mlbash( ...
                sprintf('fslreorient2std %s %s', ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_rawavg']), ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_rawavg'])));
            mlbash( ...
                sprintf('cp %s %s', ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_rawavg']), ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_' this.structuralFileprefix])));
        end
        function nii                   = aparcIndexedRoiChoice(this, idx)
            %% APARCINDEXEDROICHOICE returns an ROI for aparcIndexedRois == index
            %  Usage:   nifti = obj.aparcIndexedRoiChoice(roi_index)
            if(ischar(idx))
                idx     = str2double(idx); end
            assert(isfinite(idx));
            idx     = ceil(idx);
            nii     = this.aparcIndexedRois.zeros( ...
                      sprintf('SurferRois.aparcIndexedRoiChoice(idx->%i)',    idx), ...
                      sprintf('%s%i', this.separatedRoiFileprefix, idx));
            nii.img = this.aparcIndexedRois.img == idx;
        end
        function [indices, rois, this] = aparcIndicesAndRois(this, varargin)
            %% APARCINDICESANDROIS uses aparc.a2009s+aseg to generate ROIs in the patient's native space (rawavg).
            %  Usage:  [indices, rois, obj] = obj.aparcIndicesAndRois([save_separated_rois])
            %           ^ double                                       ^ logical
            %                    ^ ImagingComposite/ImagingComponent
            
            p = inputParser;
            addOptional(p, 'saveSeparated', false, @islogical);
            parse(p, varargin{:});
            this.saveSeparatedRois = p.Results.saveSeparated;
            this.cd(this.fslPath);            
            this.aparcIndexedRois_ = this.aparcIndexedRois; %%% KLUDGE
            fprintf('\nSurferRois.aparcIndicesAndRois:  working with %s, index:  ', ...
                     this.aparcIndexedRois.fqfilename);
            
            this.aparcIndices_ = []; 
            airimg             = this.aparcIndexedRois.img;
            found              = 0; 
            for r = 11000:dipmax(airimg) % 1:255, 11000:aparc.dipmax
                trues = airimg == r;
                if (any(trues(:)))
                    fprintf('%i ', r);
                    found = found + 1;
                    this.aparcIndices_(found) = r;
                    if (this.rememberSeparatedRois)
                        choice = this.aparcIndexedRoiChoice(r);
                        if (1 == found)
                            this.aparcSeparatedRois_ = mlfourd.ImagingComponent.load(choice);
                        else
                            this.aparcSeparatedRois_.add(choice);
                        end
                    end
                end
            end
            fprintf('\n');
            this.aparcIndexedRois = this.aparcIndexedRois.append_descrip( ...
                                    sprintf('non-zero indices:  %s', num2str(this.aparcIndices)));
            indices = this.aparcIndices;            
            if (this.rememberSeparatedRois)
                rois = this.aparcSeparatedRois;
            else
                rois = this.aparcIndexedRois;
            end
        end 
        function [paramParced,this]    = parcellateMapping(this, paramMap, varargin)
            %% PARCELLATEMAPPING accepts a containers.Map that maps any number of aparcIndices to parameter values and
            %  returns an image of parcellated parameter values on the raster defined by aparcIndexedRois.
            %  Returned image is onto, but not necessarily one-to-one.  
            %  Saved parcellated image will be 4D with parameter mean and stddev in the last dimension.
            %  Usage:  [parameter_image, obj] = obj.parcellateMap(mapping)
            %           ^ structural image                        ^ containers.Map:   aparcIndices -> parameter values
            %             used for aparcIndexedRois
            %  See also:  AbstractRois.structural, aparcIndexedRoiChoice
            
            p = inputParser;
            addRequired(  p, 'paramMap',                @(x) isa(x, 'containers.Map') & ~isempty(x));
            addParamValue(p, 'paramLabel', 'parameter', @ischar);
            addParamValue(p, 'threshold',  0.05,        @isnumeric);
            parse(p, paramMap, varargin{:});
            
            keys    = p.Results.paramMap.keys;
            thresh  = p.Results.threshold;
            means   = zeros(this.structural.nifti.size);
            %stddevs = zeros(this.structural.nifti.size);
            for cardinalIdx = 1:length(paramMap)
                roi  = this.aparcIndexedRoiChoice(keys{cardinalIdx}); 
                roi  = roi.img;
                vals = paramMap(keys{cardinalIdx});
                if (lany(roi > thresh))
                    means(  roi > thresh) = vals(1);
                    %stddevs(roi > thresh) = vals(2);
                end
            end
            
            paramParced = this.structural.nifti.makeSimilar( ...
                this.structural.nifti.zeros, ....
                'SurferRois.parcellateMapping.paramParced:  mean, stddev', ...
                [p.Results.paramLabel '_on_' this.aparcFileprefix]);  
            paramParced.img(:,:,:,1) = means;
            %paramParced.img(:,:,:,2) = stddevs;
            paramParced.save;
            paramParced = imcast(paramParced, 'mlfourd.ImagingContext');
        end 
        function [imParced,  this]     = parcellateImage(this, imobj)
            %% PARCELLATEIMAGE using aparc_a2009s+aseg as a source of ROIs for any structurally aligned image-object ...
            %  Usage:  [parcellated_image, obj] = obj.parcellateImage(structurally_aligned_image)
            %           ^ ImagingContenxt
            %  Uses:   parcellateMapping
            
                       this.cd(this.fslPath);
            imobj    = imcast(imobj, 'mlfourd.NIfTI');
            imParced = imobj.zeros( ...
                ['from mlsurfer.SurferRois.parcellateImage.' imobj.fileprefix], ...
                [imobj.fileprefix '_on_' this.aparcFileprefix]);
            this = this.ensureAparcSeparatedRois;
            roisCmp  = this.aparcSeparatedRois;
            for r = 1:length(roisCmp)
                roi = roisCmp.get(r);
                imParced.img = ...
                    imParced.img + mean(imobj.img(roi.img ~= 0)) * double(roi.img); % for partial-volume ROIs
            end
            imParced = imcast(imParced, 'mlfourd.ImagingContext');
            imParced.nifti.save;
        end  
        function [idx, this]           = parcellateIndices(this)
            this.aparcIndices = this.aparcIndicesAndRois;
            idxSelfmap        = containers.Map(this.aparcIndices, this.aparcIndices);
            [idx,this]        = this.parcellateMapping(idxSelfmap, 'paramLabel', 'indices');
        end
        function [thickParced,this]    = parcellateThickness(this)
            [thmap,      this] = this.surferSegstatsOnTargetId;
            [thickParced,this] = this.parcellateMapping(thmap, 'paramLabel', 'thickness');
        end  
        function roi                   = segids2roi(this, ids)
            assert(isnumeric(ids));
            assert(length(ids) > 1);
            roi = this.aparcIndexedRoiChoice(ids(1));
            for s = 2:length(ids)
                roi = roi | this.aparcIndexedRoiChoice(ids(s));
            end
        end
        function [thmap, this]         = surferSegstats(this, varargin)
            %% SURFERSEGSTATS implements http://surfer.nmr.mgh.harvard.edu/fswiki/VolumeRoiCorticalThickness
            %  Usage:   [mapping_of_indices_to_rois, this] = obj.surferSegstats
            %            ^ containers.Map
                          
            p = inputParser;
            addOptional(p, 'stat', 'mean', @(x) lstrfind(x, this.STATS_AVAILABLE));
            parse(p, varargin{:});

            import mlsurfer.*;
            bldr = VolumeRoiCorticalThicknessBuilder( ...
                'product',     this.mask, ...
                'roi',         this.mask, ...
                'sessionPath', this.sessionPath, ...
                'sessionId',   this.sessionId, ...
                'targetId',    this.sessionId);            
            thmap = containers.Map;
            try
                vtor  = SurferVisitor;
                for h = 1:length(this.hemisLabels)
                    vtor.visitVolumeRoiCorticalThicknessSegstats(bldr, this.hemisLabels{h});
                    segstats = mlio.TextIO.textfileToCell(bldr.segstats_fqfn(this.hemisLabels{h}));
                    for s = 1:length(segstats)
                        if (~strcmp('#', segstats{s}(1)))
                            rgxnames = regexp(segstats{s}, this.segstatsExpression, 'names' );
                            if (~isempty(rgxnames) && isfield(rgxnames, p.Results.stat))
                                thmap(rgxnames.segid) = str2double(rgxnames.(p.Results.stat)); end;
                        end
                    end
                end
            catch ME
                handexcept(ME);
            end
            this.thicknessMap_ = thmap;  
        end      
        function [thmap, this]         = surferSegstatsOnTargetId(this)
            %% SURFERSEGSTATSONTARGETID implements http://surfer.nmr.mgh.harvard.edu/fswiki/VolumeRoiCorticalThickness
            %  Usage:   [mapping_of_indices_to_rois, this] = obj.surferSegstats
            %            ^ containers.Map
            
            import mlsurfer.*;
            this = this.ensureAparcSeparatedRois;
            bldr = VolumeRoiCorticalThicknessBuilder( ...
                'product',     this.mask, ...
                'roi',         this.mask, ...
                'sessionPath', this.sessionPath, ...
                'sessionId',   this.sessionId, ...
                'targetId',    this.sessionId);            
            thmap = containers.Map('KeyType', 'uint64', 'ValueType', 'any');
            vtor  = SurferVisitor;
            vtor.visitFslregister(bldr);
            for r = 1:length(this.aparcIndices);
                try
                    bldr.roi = this.aparcIndexedRoiChoice(this.aparcIndices(r));  
                    hemi     = this.index2hemisphere(r);             
                    vtor.visitRoiVol2surf(bldr, hemi); 
                    vtor.visitSurf2surf(  bldr, hemi);
                    vtor.visitRoiSegstats(bldr, hemi);

                    rgxnames = regexp( mlio.TextIO.textfileToString(bldr.segstats_fqfn(hemi)), this.segstatsExpression2Rows, 'names' );
                    if (~isempty(rgxnames))
                        thmap(this.aparcIndices(r)) = [str2double(rgxnames.mean) str2double(rgxnames.stddev)]; 
                    else
                        thmap(this.aparcIndices(r)) = [0 0];
                    end
                catch ME2
                    handwarning(ME2);
                end
            end
            this.thicknessMap_ = thmap;  
        end
        function                         makeAparcWithExclusions(this)
            try            
                aparc = this.makeImageFileAsNeeded( ...
                    fullfile(this.fslPath, [this.DestrieuxNoDot '_on_rawavg']), ...
                    'registerAparcOnRawavg');
                aparc = aparc.nifti;
                if (this.EXCLUDE_EXTRAPARENCHYMAL)
                    aparc = aparc .* ~this.extraParenchymalRoi.nifti; end
                aparc.saveas(fullfile( ...
                    this.fslPath, filename(this.aparcFileprefix)));
            catch ME
                handexcept(ME);
            end
        end
        function [xvec,unused_indices] = makeVectors(this, imobj, indices, normalize)
            %% MAKEVECTORS using aparc.a2009s+aseg for ROIs
            %  Usage:  [intensities,unused_indices] = prototype4(image, indices, normalize)
            %          ^            ^ double vecs                ^ NIfTI or filename
            %                         ordinal indices                            ^ double ^ scalar double
            
            %% Version $Revision: 2541 $ was created $Date: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $ by $Author: jjlee $,
            %% last modified $LastChangedDate: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferRois.m $
            %% Developed on Matlab 8.1.0.604 (R2013a)
            %% $Id: SurferRois.m 2541 2013-08-18 23:13:31Z jjlee $
                        
            this.cd(this.fslPath);
            import mlfourd.*;
            imobj  = imcast(imobj, 'mlfourd.NIfTI');
            assert(isnumeric(indices));
            if (~exist('normalize', 'var'))
                normalize = 1; end
            
            import mlrois.*;
            aparc = this.aparcIndexedRois;
            cereb = CerebellumRois; cereb = cereb.mask;
            pca   = PcaRois;          pca = pca.mask;
            aparc = aparc .* ~cereb .* ~pca;
            if (this.EXCLUDE_EXTRAPARENCHYMAL)
                aparc = aparc .* ~this.extraParenchymalRoi.nifti; end
            
            xvec = zeros(size(indices));
            unused_indices = [];
            for sl = 1:length(indices)
                trues = aparc.img == indices(sl);
                if (sum(trues(:)) > this.MINIMUM_SAMPLE)
                    xvec(sl) = mean(imobj.img(trues)) / normalize; %% reindexing
                else
                    unused_indices = [unused_indices sl]; %#ok<AGROW>
                end
            end
        end % makeVectors        
        function splits                = splitLandR(this, obj, varargin) %#ok<INUSL>
            %% SPLITLANDR separates left hemisphere indices from right ones
            %  Usage:  splits = stripzeros(vector[, indices]) 
            %          ^ struct.leftHemisphere   structure matches input argument types
            %                  .rightHemisphere
            %                 [.leftIndices]
            %                 [.rightIndices]
            %                                                                      ^ Nx2 ordered-poirs double, or 
            %                                                                        Nx1 double with Nx1 indices also sent
            
            %% Version $Revision: 2541 $ was created $Date: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $ by $Author: jjlee $,  
            %% last modified $LastChangedDate: 2013-08-18 18:13:31 -0500 (Sun, 18 Aug 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferRois.m $ 
            %% Developed on Matlab 8.1.0.604 (R2013a) 
            %% $Id: SurferRois.m 2541 2013-08-18 23:13:31Z jjlee $ 

            p = inputParser;
            addRequired(p, 'obj', @isnumeric);
            addOptional(p, 'indices', []);
            parse(p, obj, varargin{:});

            if (isvector(p.Results.obj))
                assert(~isempty(p.Results.varargin));
                range  = p.Results.obj;
                domain = p.Results.varargin{1};
            end            
            if (size(p.Results.obj,1) < size(p.Results.obj,2)) % wide rows
                range  = p.Results.obj(2,:);
                domain = p.Results.obj(1,:);
            end
            if (size(p.Results.obj,1) > size(p.Results.obj,2)) % tall first columns
                range  = p.Results.obj(:,2); 
                domain = p.Results.obj(:,1);
            end
            assert(size(p.Results.obj,1) ~= size(p.Results.obj,2), 'ambiguous domain and range');
            assert(length(range) == length(domain));

            [splits.leftHemisphere,splits.rightHemisphere] = assignSplits(range);
            [splits.leftIndices,   splits.rightIndices]    = assignSplits(domain);
            
            function [vec1,vec2] = assignSplits(this, vec)
                vec  = vec(isfinite(vec));
                vec  = vec(vec ~= 0);
                vec1 = vec(this.leftIndexMask(vec));
                vec2 = vec(this.rightIndexMask(vec));
            end
        end        
 		function this                  = SurferRois(varargin) 
 			%% SURFERROIS 
 			%  Usage:  obj = SurferRois([...]) 
            %                            ^ cf. mlrois.AbstractRois
            
            this = this@mlrois.AbstractRois(varargin{:});
            this.rememberSeparatedRois_ = true;
            this.saveSeparatedRois_     = true;
 		end %  ctor 
    end 
    
    %% PROTECTED
    
    methods (Access = 'protected')  
        function         cd(~, varargin)
            cd(varargin{:});
            fprintf('SurferRois is now working in %s\n', pwd);
        end
        function this  = ensureAparcSeparatedRois(this)
            if (isempty(this.aparcSeparatedRois_))
                [~,~,this] = this.aparcIndicesAndRois; end
        end
        function msk   = leftIndexMask(this, vec)
            if (~exist('vec','var'))
                vec = this.aparcIndices; end
             msk = ( this.START_INDEX_CORTEX <= vec ) && ...
                   ( vec < this.START_INDEX_CORTEX + this.DELTA_INDEX_CORTEX );
        end
        function fqfn  = mghThicknessFile(this, hemi, target)
            if (~exist('target','var'))
                target = this.AVER_ID; end
            fqfn = fullfile(this.surfPath, [hemi '.thickness.' target '.mgh']);
        end
        function rgx   = rgxnname(~, lbl)
            rgx = ['\s+(?<' lbl '>\d+\.?\d*)'];
        end
        function fn    = regfile(this, target)
            if (~exist('target','var'))
                target = this.AVER_ID; end
            fn = fullfile(this.surfPath, [this.structuralFileprefix '_to_' target '.dat']);
        end
        function msk   = rightIndexMask(this, vec)
            if (~exist('vec','var'))
                vec = this.aparcIndices; end
            msk = vec >= this.START_INDEX_CORTEX + this.DELTA_INDEX_CORTEX;
        end
        function fn    = roi_fqfn(this, roilbl)
            if (~exist('roilbl', 'var'))
                roilbl = this.INDEXED_ROI_PREFIX; end
            fn = fullfile(this.fslPath, [roilbl '.nii.gz']);
        end
        function fn    = segfile(this, hemi, roilbl)
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
            if (~exist('roilbl', 'var'))
                roilbl = this.INDEXED_ROI_PREFIX; end
            fn = fullfile(this.surfPath, [hemi '.' this.AVER_ID '.' roilbl '.mgh']);
        end
        function fn    = sumfile(this, hemi, roilbl)
            assert(strcmp('l', hemi) || strcmp('r', hemi));
            if (~exist('roilbl','var'))
                roilbl = this.INDEXED_ROI_PREFIX; end
            fn = fullfile(this.surfPath, ['segstats_' hemi '_' roilbl '.txt']);
        end
        function ssexp = segstatsExpression(this) 
            ssexp = [ ...
                this.rgxnname('index') ...
                this.rgxnname('segid') ...
                this.rgxnname('nvoxels') ...
                this.rgxnname('volume_mm3') ...
                '\s+(?<segname>\w+\d*)' ...
                this.rgxnname('mean') ...
                this.rgxnname('stddev') ...
                this.rgxnname('min') ...
                this.rgxnname('max') ...
                this.rgxnname('range')];
        end
        function ssexp = segstatsExpression2Rows(this) 
            ssexp = [this.COL_HEADERS ...
                this.rgxnname('index') ...
                this.rgxnname('segid') ...
                this.rgxnname('nvoxels') ...
                this.rgxnname('volume_mm3') ...
                '\s+(?<segname>\w+\d*)' ...
                this.rgxnname('mean') ...
                this.rgxnname('stddev') ...
                this.rgxnname('min') ...
                this.rgxnname('max') ...
                this.rgxnname('range')];
        end
    end
    
    %% PRIVATE
    
	properties (Constant, Access = 'private')
        START_INDEX_CORTEX       = 11000;
        DELTA_INDEX_CORTEX       = 1000;  %% for indices > 11000, right > left
        START_INDEX_SUBCORTEX    = 1;
        DELTA_INDEX_SUBCORTEX    = 39; %% for indices < 80, right > left
        START_INDEX_UNPAIRED     = 80; %% for 79 < indices 11000, hemispheric symmetry may be absent
        AVER_ID                  = 'fsaverage';
        COL_HEADERS              = '\#\s+ColHeaders\s+Index\s+SegId\s+NVoxels\s+Volume_mm3\s+StructName\s+Mean\s+StdDev\s+Min\s+Max\s+Range';
        DESTRIEUX_FILEPREFIX     = 'aparc.a2009s+aseg';
        EXCLUDE_EXTRAPARENCHYMAL = false;
        HEMISPHERES_LABELS       = { 'lh' 'rh' }; %% expected by freesurfer routines; cf. SurferVisitor
        INDEXED_ROI_PREFIX       = 'aparcIndexedRoi';
        MINIMUM_SAMPLE           = 27; %% cube of nearest-neighbors
        STATS_AVAILABLE          = { 'index' 'segid' 'nvoxels' 'volume_mm3' 'segname' 'mean' 'stddev' 'min' 'max' 'range' };
    end
    
    properties (Access = 'private')
        aparcIndices_
        aparcIndexedRois_
        aparcSeparatedRois_
        rememberSeparatedRois_ = true;
        saveSeparatedRois_     = true;
        thicknessMap_
    end
    

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

