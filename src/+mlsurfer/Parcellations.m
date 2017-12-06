classdef Parcellations
	%% PARCELLATIONS presents data generated from Freesurfer in formats useful for Matlab.  
    %  Pubicallyl accessible containers.Map map segmentation numbers or segmentation names to numerical data
    %  organized by Freesurfer-specified parcellations. 
    %  Uses:  mlio.TextIO to read Freesurfer data from ascii files.
    %  See also:  ParcellationSegments.
    %  Symbols:  'dsa' denotes data hand-recorded from interventional radiology reports of hemodynamic impairment;
    %            'cvs' denotes the CVS database of normal volunteers provided by the Freesurfer developers.
    
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%% $Id$ 
 	 
    properties (Constant)
        HEMIS             = { 'lh' 'rh' }
        PARAMS            = { 'S0' 'CBF' 'CBV' 'MTT' 't0' 'alpha' 'beta' 'gamma' 'delta' 'eps' 'logProb' ...
                              'adc_default' 'dwi_default_meanvol' 'cvs' 'dsa' ...
                              'oefnq_default_161616fwhh' 'oo_sumt_737353fwhh' 'ho_sumt_737353fwhh' ...
                              'oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain'}
        PARAMS2           = { 'ho' 'oo' 'oc' 'oefratio'}
        PARAMS3           = { 'thickness' 'thicknessStd' 'area' 'volume' 'meancurv' }
        PARAMS_ALL        = [ mlsurfer.Parcellations.PARAMS ...
                              mlsurfer.Parcellations.PARAMS2 ...
                              mlsurfer.Parcellations.PARAMS3 ]                        
        SEGNAME_TO_IGNORE = { 'Medial_wall' };        
        STATISTICS        = { 'mean' 'stddev' 'std' 'min' 'max' 'range' 'volume' }        
        TERRITORIES       = { 'all' 'all_aca_mca' 'aca' 'aca_min' 'aca_max' 'mca' 'mca_min' 'mca_max' 'pca' 'pca_min' 'pca_max' 'cereb' }
        
        COLOR_LUT_FILENAME = '/Volumes/SeagateBP4/cvl/np755/JJLColorLUTshort_20151002.txt'
    end
    
    properties (Dependent)
        surferFilesystem
    end
    
    methods 
        
        %% GET
        
        function x = get.surferFilesystem(this)
            x = this.surferFs_;
        end

        %%
    
 		function this = Parcellations(varargin) 
 			%% PARCELLATIONS 
 			%  Usage:  this = Parcellations([surfer_filesystem_object]['SessionPath', path_to_session_data]) 
            %                                ^ ISurferFilesystem

            import mlsurfer.*;
            ip = inputParser;
            addOptional( ip, 'surferFs',    [],  @(x) isa(x, 'mlsurfer.ISurferFilesystem'));
            addParameter(ip, 'SessionPath', pwd, @isdir);
            parse(ip, varargin{:});
                  
            if (~isempty(ip.Results.surferFs))
                this.surferFs_ = SurferFilesystem(ip.Results.surferFs.sessionPath);
            else
                this.surferFs_ = SurferFilesystem(ip.Results.SessionPath);
            end
            this = this.generateSegidentifiedSegnameMap;
        end
        
        function fqfn = statsFilename(this, hemi, param)
            %% PARAMETERFILENAME returns a canonical filename for freesurfer statistics created by the user
            %  Use:   fully_qualified_filename = this.statsFilename(hemisphere, parameter_name)
            %                                                       ^ lh, rh    ^ from this.PARAMS or this.PARAMS2 or
            %                                                                     this.PARAMS3
            
            import mlsurfer.*;
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
            assert(ischar(param));             
            fqfn = fullfile(this.surferFilesystem.segstats_fqfn(hemi, param));
        end
        function fqfn = tableFilename(this, hemi, param)
            %% TABLEFILENAME returns the table-file of thicknesses for the subject identified by the ctor
            
            fqfn = fullfile(this.surferFilesystem.fslPath, ...
                           [hemi '_aparc_a2009s_' param '.table']);
        end
        function fqfn = thicknessCvsTableFilename(this)
            %% THICKNESSCVSTABLEFILENAME returns a table-file for thickness statistics from Freesurfer's 
            %  CVS dataset of normal volunteers
            
            fqfn = fullfile(this.surferFilesystem.studyPath, ...
                           'cvs_avg35_aparc_a2009s_lh_thickness.table');
        end
        function fqfn = dsaTableFilename(this, hemi)
            %% DSATABLEFILENAME returns the table-file for digital subtraction angiography results, 
            %  recorded from the subject's interventional radiology report; that table lists regions of 
            %  hemodynamic impairment.
            
            fqfn = fullfile(this.surferFilesystem.fslPath, ...
                           [hemi '_dsa.table']);
        end
        
        function tf = isInTerritory(this, segname, terr)
            %% ISINTERRITORY returns boolean for segmentation name belonging to a territory from list this.TERRITORY
            %  Use:   tf = this.isInTerritory(segmentation_name, territory_name)
            
            assert(ischar(segname));
            assert(lstrfind(terr, this.TERRITORIES));
            tf = lstrfind(segname, this.cachedTerritory(terr));
        end
        function tf = isInHemisphere(~, segname, hemi)
            if (lstrfind(segname, [hemi '_']))
                tf = true;
            else
                tf = false;
            end                
        end
        
        function aMap = segidentifiedStatsMap(this, hemi, param, varargin)
            %% SEGIDENTIFIEDSTATSMAP maps segmentation/parcellation id-numbers to stats. 
            %  The map values are scalar double.
            %  Usage:  aMap = obj.segidentifiedStatsMap(hemi, param[, terr, statistic])
            %                                           ^ from this.HEMIS
            %                                                 ^ from this.PARAMS
            %                                                         ^ from this.TERRITORIES 
            %                                                                ^ from this.STATISTICS
            
            p = inputParser;
            addRequired(p, 'hemi',                      @(x) lstrfind(x, this.HEMIS));
            addRequired(p, 'param',                     @ischar);
            addOptional(p, 'terr', this.TERRITORIES{2}, @(x) lstrfind(x, this.TERRITORIES));
            addOptional(p, 'statistic', 'mean',         @(x) lstrfind(x, this.STATISTICS));
            parse(p, hemi, param, varargin{:});  
            
            import mlsurfer.*; 
            if (lstrfind(param, { 'thicknessStd' 'thickness' 'area' 'volume' 'meancurv' 'cvs' 'dsa' })) 
                %% SPECIAL CASES
                
                aMap          = containers.Map('KeyType', 'double', 'ValueType', 'any');
                segname2stats = this.segnamedStatsMap(hemi, param, p.Results.terr);
                segid2segname = this.segidentifiedSegnameMap_;
                segids        = segid2segname.keys;                
                for s = 1:length(segids)
                    try
                        segname = segid2segname(segids{s}).segname;
                        if (this.isInHemisphere(segname, hemi) && this.isInTerritory(segname, p.Results.terr))
                            aMap(segids{s}) = segname2stats(segname);
                        end
                    catch ME2
                        if (~lstrfind(segname, this.SEGNAME_TO_IGNORE) && ...
                            ~lstrfind(param, PETSegstatsBuilder.OC_FILEPREFIX)) %% known to be missing in imaging data
                            this.fprintfException('segidentifiedStatsMap', '[table-file for dsa, cvs, thickness, thicknessstd]', ...
                                                   segids{s}, [segname '...']);
                            handwarning(ME2);
                        end
                    end
                end                
                aMap = Parcellations.singleStatMap(aMap, p.Results.statistic);
                return
            end                
            aMap = this.segidentifiedParameterizedMap(hemi, param, p.Results.terr);
            aMap = Parcellations.singleStatMap(aMap, p.Results.statistic);
        end        
        function aMap = segnamedStatsMap(this, hemi, param, varargin)
            %% SEGNAMEDSTATSMAP maps segmentation/parcellation names to stats.
            %  The map values are struct with fields that vary with param:
            %      param == 'dsa' -> mean
            %      param == 'cvs' -> (this.mapStructFieldname(param))
            %      param == 'thickness' -> (this.mapStructFieldname(param))
            %      param == 'thicknessStd' -> (this.mapStructFieldname(param))
            %      param == other from this.PARAMS -> segid, volume_mm3, mean, stddev, min, max
            %  Usage:   aMap = obj.segnamedStatsMap(hemi, param[, terr])
            %                                       ^ from this.HEMIS
            %                                             ^ from this.PARAMS
            %                                                     ^ from this.TERRITORIES  
            
            p = inputParser;
            addRequired(p, 'hemi',                      @(x) lstrfind(x, this.HEMIS));
            addRequired(p, 'param',                     @ischar);
            addOptional(p, 'terr', this.TERRITORIES{2}, @(x) lstrfind(x, this.TERRITORIES));
            addOptional(p, 'statistic', 'mean',         @(x) lstrfind(x, this.STATISTICS));
            parse(p, hemi, param, varargin{:});  
                     
            import mlsurfer.*;
            if (lstrfind(lower(param), 'dsa'))
                aMap = this.segnamedDsaMap(hemi); 
                return; 
            end
            if (lstrfind(lower(param), 'cvs'))
                param = 'thickness';
                aMap = this.segnamedThicknessCvsMap(hemi, param, p.Results.terr); 
                return; 
            end
            if (lstrfind(lower(param), 'thickness') || ...
                lstrfind(lower(param), 'thicknessStd') || ...
                lstrfind(lower(param), 'area') || ...
                lstrfind(lower(param), 'volume') || ...
                lstrfind(lower(param), 'meancurv'))
                aMap = this.segnamedTableFileMap(hemi, param, p.Results.terr); 
                return; 
            end      
            aMap = this.segnamedStatsFileMap(hemi, param, p.Results.terr);
        end
    end 
    
    methods (Static)
        function aMap = singleStatMap(aMap, stat)
            %% SINGLESTATMAP reduces structs in aMap.values to a single statistic from the struct
             
            assert(isa(aMap, 'containers.Map'));
            testval = aMap.values; 

            testval = testval{1};
            if (~isstruct(testval))
                return; end            
            
            if (lstrfind(lower(stat), 'mean'))
                stat = 'mean'; end
            if (lstrfind(lower(stat), 'std') || lstrfind(lower(stat), 'stddev') || lstrfind(lower(stat), 'sigma'))
                stat = 'stddev'; end
            if (lstrfind(lower(stat), 'min'))
                stat = 'min'; end
            if (lstrfind(lower(stat), 'max'))
                stat = 'max'; end
            if (lstrfind(lower(stat), 'range'))
                stat = 'range'; end
            if (lstrfind(lower(stat), 'volume'))
                stat = 'volume_mm3'; end
            vals = aMap.values;
            for v = 1:length(vals)
                vals{v} = vals{v}.(stat);
            end
            aMap = containers.Map(aMap.keys, vals);
        end
        function        fprintfException(meth, statsFn, line, textline)
            if (str2double(getenv('VERBOSITY')))
                fprintf(['mlsurfer.Parcellations.' meth ' encountered problem in:\n']);
                fprintf('\tfile->%s, line %i->%s\n', statsFn, line, textline);
            end
        end
    end
    
    %% PRIVATE
    
    properties (Constant, Access = 'private')
        DSA_TEXT_EXPR             = '(?<territory>\S+)\s+(?<impaired>\d)'
        INDEXED_TEXT_EXPR         = '(?<segid>\d+)\s+(?<segname>\S+)\s+(?<rgba>\d+\s+\d+\s+\d+\s+\d+)\s+(?<territory>\w+)';
        PARAMETER_TABLE_TEXT_EXPR = '(?<segname>\S+)\s+(?<parameter>\d+(\.\d+|))';
    end
    
    properties (Access = 'private')
        surferFs_
        cachedAcaLabels_
        cachedAcaMaxLabels_
        cachedAcaMcaLabels_
        cachedAcaMinLabels_        
        cachedAllLabels_
        cachedMcaLabels_
        cachedMcaMaxLabels_
        cachedMcaMinLabels_  
        cachedPcaLabels_
        cachedPcaMaxLabels_
        cachedPcaMinLabels_  
        cachedSinusLabels_
        cachedCerebLabels_
        segidentifiedSegnameMap_ % maps segmentation numbers to segmentation names
    end
        
    methods (Access = 'private')
        
        %% MAP GENERATORS
        
        function this  = generateSegidentifiedSegnameMap(this)
            %% GENERATESEGIDENTIFIEDSEGNAMEMAP generates a mapping of segid to segname from file this.COLOR_LUT_FILENAME.
            %  It should be called only once per session-level analysis.
            %  Private territory caches are generated for territorial analyses.
            %  The caller must update object this.
            
            theText = mlio.TextIO.textfileToCell(this.COLOR_LUT_FILENAME);
            this.segidentifiedSegnameMap_ = containers.Map('KeyType', 'double', 'ValueType', 'any');
            this = this.initializeTerritoryCaches;
            for t = 2:length(theText)
                txtLine = theText{t};
                if (~isempty(txtLine))
                    if (~strcmp('#', txtLine(1)))
                        rgxnames = regexp(theText{t}, this.INDEXED_TEXT_EXPR, 'names');
                        this.segidentifiedSegnameMap_( ...
                             this.numericSegId(rgxnames.segid)) = ...
                                   struct('segname', rgxnames.segname, 'RGBA', str2num(rgxnames.rgba), 'territory', rgxnames.territory); %#ok<ST2NM>
                        if (~lstrfind(rgxnames.segname, this.SEGNAME_TO_IGNORE))
                            switch (rgxnames.territory)
                                case 'aca'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedAcaLabels_    = [this.cachedAcaLabels_    rgxnames.segname];
                                    this.cachedAcaMaxLabels_ = [this.cachedAcaMaxLabels_ rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                case 'aca_min'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedAcaLabels_    = [this.cachedAcaLabels_    rgxnames.segname];
                                    this.cachedAcaMinLabels_ = [this.cachedAcaMinLabels_ rgxnames.segname];
                                    this.cachedAcaMaxLabels_ = [this.cachedAcaMaxLabels_ rgxnames.segname];
                                case 'mca'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedMcaLabels_    = [this.cachedMcaLabels_    rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                case 'mca_min'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedMcaLabels_    = [this.cachedMcaLabels_    rgxnames.segname];
                                    this.cachedMcaMinLabels_ = [this.cachedMcaMinLabels_ rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                case 'pca'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedPcaLabels_    = [this.cachedPcaLabels_    rgxnames.segname];
                                    this.cachedPcaMaxLabels_ = [this.cachedPcaMaxLabels_ rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                case 'pca_min'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedPcaLabels_    = [this.cachedPcaLabels_    rgxnames.segname];
                                    this.cachedPcaMinLabels_ = [this.cachedPcaMinLabels_ rgxnames.segname];
                                    this.cachedPcaMaxLabels_ = [this.cachedPcaMaxLabels_ rgxnames.segname];
                                case 'border_aca_mca'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedAcaMaxLabels_ = [this.cachedAcaMaxLabels_ rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                case 'border_mca_pca'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                    this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                    this.cachedPcaMaxLabels_ = [this.cachedPcaMaxLabels_ rgxnames.segname];
                                case 'sinus'
                                    this.cachedSinusLabels_  = [this.cachedSinusLabels_  rgxnames.segname];
                                case 'cereb'
                                    this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                    this.cachedCerebLabels_  = [this.cachedCerebLabels_  rgxnames.segname];
                            end
                        end
                    end
                end
            end 
        end        
        function aMap  = segnamedDsaMap(this, hemi)
            %% SEGNAMEDDSAMAP returns a struct with field:  mean
            
            shortMap = containers.Map;
            try
                theText = mlio.TextIO.textfileToCell(this.dsaTableFilename(hemi));
                for t = 1:length(theText)
                    if (~isempty(theText{t}))
                        if (~strncmp(theText{t}, '#', 1))
                            textline = theText{t};
                            rgxnames = regexp(textline, this.DSA_TEXT_EXPR, 'names');
                            shortMap(rgxnames.territory) = str2double(rgxnames.impaired);
                        end
                    end
                end
            catch ME %#ok<NASGU>
                shortMap = containers.Map({'aca' 'mca' 'pca'}, {0 0 0});
            end
            impaired = impairmentList(shortMap);
            
            aMap          = containers.Map;
            segid2segname = this.segidentifiedSegnameMap_;
            tmkeys        = segid2segname.keys;
            for k = 1:length(tmkeys)
                segname = segid2segname(tmkeys{k});
                if (lstrfind(segname.territory, impaired))
                    aMap(segname.segname) = struct('mean',1); 
                else
                    aMap(segname.segname) = struct('mean',0);
                end
            end
            
            function cll = impairmentList(map)
                cll = {};
                kys = map.keys;
                for c = 1:length(kys)
                    if (map(kys{c}))
                        cll = [cll kys{c}]; end %#ok<AGROW>
                end
            end
        end
        function aMap  = segnamedThicknessCvsMap(this, hemi, param, terr)
            %% SEGNAMEDTHICKNESSCVSMAP returns a struct with field:   (this.mapStructFieldname(param))
            
            theText = mlio.TextIO.textfileToCell(this.thicknessCvsTableFilename);              
            aMap = containers.Map;
            for t = 2:length(theText)
                if (~isempty(theText{t}))
                    if (~lstrfind(theText{t}, this.parameterStatsHeader(param)))
                        textline = theText{t};
                        if (~strcmp('#', textline(1)))
                            try
                                rgxnames = regexp(textline, this.PARAMETER_TABLE_TEXT_EXPR, 'names');
                                segname  = ['ctx_' hemi '_' ...
                                               this.clipBeginning( ...
                                                   this.clipEnding(rgxnames.segname, ['_' param]), 'lh_')];
                                if (this.isInTerritory(segname, terr))
                                    aMap(segname) = ...
                                        struct(this.mapStructFieldname(param), str2double(rgxnames.parameter));
                                end
                            catch ME2
                                this.fprintfException('segnamedThicknessCvsMap', ...
                                                      this.thicknessCvsTableFilename, t, textline);
                                if (~lstrfind(textline, 'nan'))
                                    handerror(ME2);
                                end
                            end
                        end
                    end
                end
            end
        end
        function aMap  = segnamedTableFileMap(this, hemi, param, terr)
            %% SEGNAMEDTABLEFILEMAP returns a struct with field:  (this.mapStructFieldname(param))
            
            theText = mlio.TextIO.textfileToCell(this.tableFilename(hemi, param));
            aMap = containers.Map;
            for t = 2:length(theText)
                if (~isempty(theText{t}))
                    if (~lstrfind(theText{t}, this.parameterStatsHeader(param)))
                        textline = theText{t};
                        if (~strcmp('#', textline(1)))
                            try
                                rgxnames = regexp(textline, this.PARAMETER_TABLE_TEXT_EXPR, 'names');
                                segname  = ['ctx_' ...
                                               this.clipEnding(rgxnames.segname, ['_' param])];
                                if (this.isInTerritory(segname, terr))
                                    aMap(segname) = ...
                                        struct(this.mapStructFieldname(param), str2double(rgxnames.parameter));
                                end
                            catch ME2
                                this.fprintfException('segnamedTableFileMap', statsFn, t, textline);
                                if (~lstrfind(textline, 'nan'))
                                    handerror(ME2);
                                end
                            end
                        end
                    end
                end
            end
        end
        function aMap  = segnamedStatsFileMap(this, hemi, param, terr)
            %% SEGNAMEDSTATSFILEMAP returns a struct with fields:
            %  segid, volume_mm3, mean, stddev, min, max
            
            EXCLUSIONS = '_Unknown';
            theText    = mlio.TextIO.textfileToCell( ...
                         this.statsFilename(hemi, param));
            aMap       = containers.Map;
            for t = 5:length(theText)
                if (~isempty(theText{t}))
                    if (~lstrfind(theText{t}, EXCLUSIONS))
                        textline = theText{t};
                        if (~strcmp('#', textline(1)))
                            try
                                rgxnames = regexp(textline, this.segstatsExpression, 'names');
                                if (this.isInTerritory(rgxnames.segname, terr))
                                    aMap(rgxnames.segname) = ...
                                        struct('segid',      str2double(rgxnames.segid), ...
                                               'volume_mm3', str2double(rgxnames.volume_mm3), ...
                                               'mean',       str2double(rgxnames.mean), ...
                                               'stddev',     str2double(rgxnames.stddev), ...
                                               'min',        str2double(rgxnames.min), ...
                                               'max',        str2double(rgxnames.max));
                                end
                            catch ME2                                    
                                this.fprintfException('segnamedStatsFileMap', ...
                                                      this.statsFilename(hemi, param), t, textline);
                                if (~lstrfind(textline, 'nan'))
                                    handerror(ME2);
                                end
                            end
                        end
                    end
                end
            end
        end
        function aMap  = segidentifiedParameterizedMap(this, hemi, param, terr)
            %% SEGIDENTIFIEDPARAMETERIZEDMAP returns a struct with fields:
            %  segname, volume_mm3, mean, stddev, min, max
            
            EXCLUSIONS = '_Unknown';
            theText    = mlio.TextIO.textfileToCell( ...
                         this.statsFilename(hemi, param));
            aMap       = containers.Map('KeyType', 'double', 'ValueType', 'any');
            for t = 5:length(theText)
                if (~isempty(theText{t}))
                    if (~lstrfind(theText{t}, EXCLUSIONS))
                        textline = theText{t};
                        if (~strcmp('#', textline(1)))
                            try
                                rgxnames = regexp(textline, this.segstatsExpression, 'names');
                                if (this.isInTerritory(rgxnames.segname, terr))
                                    aMap(this.numericSegId(rgxnames.segid)) = ...
                                        struct('segname',               rgxnames.segname, ...
                                               'volume_mm3', str2double(rgxnames.volume_mm3), ...
                                               'mean',       str2double(rgxnames.mean), ...
                                               'stddev',     str2double(rgxnames.stddev), ...
                                               'min',        str2double(rgxnames.min), ...
                                               'max',        str2double(rgxnames.max));
                                end
                            catch ME2                                    
                                this.fprintfException('segidentifiedParameterizedMap', ...
                                                      this.statsFilename(hemi, param), t, textline);
                                if (~lstrfind(textline, 'nan'))
                                    handerror(ME2);
                                end
                            end
                        end
                    end
                end
            end
        end
        
        %% MAPPING UTILITIES
        
        function cache = cachedTerritory(this, terr)
            switch (terr)
                case 'all'
                    cache = this.cachedAllLabels_;
                case 'all_aca_mca'
                    cache = this.cachedAcaMcaLabels_;
                case 'aca_min'
                    cache = this.cachedAcaMinLabels_;
                case 'aca'
                    cache = this.cachedAcaLabels_;
                case 'aca_max'
                    cache = this.cachedAcaMaxLabels_;
                case 'mca_min'
                    cache = this.cachedMcaMinLabels_;
                case 'mca'
                    cache = this.cachedMcaLabels_;
                case 'mca_max'
                    cache = this.cachedMcaMaxLabels_;
                case 'pca_min'
                    cache = this.cachedPcaMinLabels_;
                case 'pca'
                    cache = this.cachedPcaLabels_;
                case 'pca_max'
                    cache = this.cachedPcaMaxLabels_;
                case 'sinus'
                    cache = this.cachedSinusLabels_;
                case 'cereb'
                    cache = this.cachedCerebLabels_;
                otherwise
                    error('mlsurfer:unsupportedParamValue', 'Parcellations.cachedTerritory.terr->%s', terr);
            end
        end
        function this  = initializeTerritoryCaches(this)  
            this.cachedAllLabels_       = {};   
            this.cachedAcaMcaLabels_    = {};
            this.cachedAcaLabels_       = {};
            this.cachedAcaMaxLabels_    = {};
            this.cachedAcaMinLabels_    = {}; 
            this.cachedMcaLabels_       = {};
            this.cachedMcaMaxLabels_    = {};
            this.cachedMcaMinLabels_    = {};
            this.cachedPcaLabels_       = {};
            this.cachedPcaMaxLabels_    = {};
            this.cachedPcaMinLabels_    = {};
            this.cachedSinusLabels_     = {};
            this.cachedCerebLabels_     = {};
        end
        function id    = numericSegId(~, id)
            if (ischar(id))
                id = str2double(id); end
            assert(isnumeric(id));
        end
        function str   = clipBeginning(~, str, toclip)
            if (length(toclip) >= length(str)); return; end
            loc = strfind(str, toclip);
            if (isempty(loc)); return; end
            str = str(loc+length(toclip):end);
        end
        function str   = clipEnding(~, str, toclip)
            if (length(toclip) >= length(str)); return; end
            loc = strfind(str, toclip);
            if (isempty(loc)); return; end
            str = str(1:loc-1);
        end        
        function ssexp = segstatsExpression(this)
            ssexp = [ ...
                '\s*(?<index>\d+)' ...
                '\s+(?<segid>\d+)' ...
                '\s+(?<nvoxels>\d+)' ...
                this.segstatsRgx('volume_mm3') ...
                '\s+(?<segname>\S+)' ...
                this.segstatsRgx('mean') ...
                this.segstatsRgx('stddev') ...
                this.segstatsRgx('min') ...
                this.segstatsRgx('max') ...
                this.segstatsRgx('range')];
        end
        function rgx   = segstatsRgx(~, lbl)
            rgx = ['\s+(?<' lbl '>(\-|)(\d+\.?\d*|nan))'];
        end        
        function str   = mapStructFieldname(~, param)
            if (lstrfind(lower(param), 'std'))
                str = 'stddev'; return; end
            if (lstrfind(lower(param), 'min'))
                str = 'min'; return; end
            if (lstrfind(lower(param), 'max'))
                str = 'max'; return; end
            if (lstrfind(lower(param), 'range'))
                str = 'range'; return; end
            if (lstrfind(lower(param), 'volume'))
                str = 'volume'; return; end
            str = 'mean';
        end
        function str   = parameterStatsHeader(~, param)
            str = ['.aparc.a2009s.' param];
        end
        
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

