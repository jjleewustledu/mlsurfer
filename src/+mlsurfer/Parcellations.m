classdef Parcellations  
	%% PARCELLATIONS slices, dices and presents data from Freesurfer in formats useful for Matlab
    
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%% $Id$ 
 	 
    properties (Constant)
        HEMIS           = { 'lh' 'rh' }
        PARAMS          = { 'S0' 'CBF' 'CBV' 'MTT' 't0' 'alpha' 'beta' 'gamma' 'delta' 'eps' 'logProb' 'adc_default' 'dwi_default_meanvol' ...
                            'thickness' 'thicknessStd' 'thicknessStddev' 'cvs' ...
                            'dsa' ...
                             mlsurfer.PETControlsSegstatsBuilder.OEFNQ_FILEPREFIX }; 
        PARAMS2         = {  'ho' 'oo' 'oc' };  
        STATS_SUFFIX    =   '_on_fsanatomical.stats';
        TERRITORIES     = { 'all' 'all_aca_mca' 'aca' 'aca_min' 'aca_max' 'mca' 'mca_min' 'mca_max' 'pca' 'pca_min' 'pca_max' ...
                            'border_aca_mca' 'border_mca_pca' 'sinus' 'cereb' };
        STATISTICS      = { 'mean' 'stddev' 'std' 'min' 'max' 'range' 'volume' };
        T1_DEFAULT      = 'MNI152_T1_1mm_brain'
    end
    
    properties (Dependent)
        segidentifiedSegnameMap
    end
    
    methods %% GET
        function map = get.segidentifiedSegnameMap(this)
            assert(~isempty(this.segidentifiedSegnameMap_), 'segidentifiedSegnameMap was called before interval data was set');
            map = this.segidentifiedSegnameMap_;
        end
    end
    
    methods (Static)
        function [m3,m4] = intersectMappingKeys(m, m2)
            %% INTERSECTMAPS accepts two maps, determines the set-intersection of their keys, 
            %  then returns two maps that share identical keys and identical lengths but non-identical values.
            
            kys  = m.keys; 
            kys2 = m2.keys; 
            
            import mlsurfer.*;
            ikys = intersect(Parcellations.keys2str(kys), Parcellations.keys2str(kys2));
            if (length(ikys) == length(kys) && length(ikys) == length(kys2))
                m3 = m; m4 = m2; return; end
            if (isnumeric(kys{1}))
                ikys = Parcellations.keys2double(ikys); end
            m3 = Parcellations.remap(m,  ikys);
            m4 = Parcellations.remap(m2, ikys);
        end
        function  m1     = invertMap(m, structField)
            if (~lexist('structField', 'var'))
                structField = 'segname'; end
            vals = cell(1, m.length);
            for k = 1:length(m.keys)
                vals{k} = m(k).(structField);
            end
            m1 = containers.Map(vals, m.keys, 'UniformValues', false);
        end
    end
    
	methods 
 		function this        = Parcellations(varargin) 
 			%% PARCELLATIONS 
 			%  Usage:  this = Parcellations(aSurferBuilder) 
            %                               ^ only used for filesystem locations

            p = inputParser;
            addRequired(p, 'bldr', @(x) isa(x, 'mlsurfer.SurferBuilder'));
            parse(p, varargin{:});            
            import mlio.*;
                      
            this.bldr_ = p.Results.bldr;
            this = this.generateSegidentifiedSegnameMap;
        end
        
        function fn          = statsFilename(this, hemi, param)
            %% PARAMETERFILENAME returns a canonical filename for freesurfer statistics
            %  Use:   fully_qualified_filename = this.statsFilename(hemisphere, parameter_name)
            %                                                       ^ lh, rh
            %                                                                   ^ from this.PARAMS or this.PARAMS2
            
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
            assert(ischar(param));
            
            if (lstrfind(this.PARAMS, param))
                param = [param '_on_' this.T1_DEFAULT];
            elseif (lstrfind(this.PARAMS2, param))
                param = [param '_on_' this.T1_DEFAULT mlsurfer.PETSegstatsBuilder.NORM_BY_DOSE_SUFFIX];
            else
                error('mlsurfer:unsupportedParamValue', 'Parcellations.statsFilenameMap.param->%s', param);
            end            
            fn = fullfile(this.bldr_.fslPath, [hemi '_' param this.STATS_SUFFIX]);
        end
        function fqfn        = tableFilename(this, hemi, param)
            fqfn = fullfile(this.bldr_.fslPath, [hemi '_aparc_a2009s_' param '.table']);
        end
        function fqfn        = thicknessCvsTableFilename(this)
            fqfn = fullfile(this.bldr_.studyPath, 'cvs_avg35_aparc_a2009s_lh_thickness.table');
        end
        function fqfn        = dsaTableFilename(this, hemi)
            fqfn = fullfile(this.bldr_.fslPath, [hemi '_dsa.table']);
        end
        function tf          = isInTerritory(this, segname, terr)
            %% ISINTERRITORY returns boolean for segmentation name belonging to a territory from list this.TERRITORY
            %  Use:   tf = this.isInTerritory(segmentation_name, territory_name)
            
            assert(ischar(segname));
            assert(lstrfind(terr, this.TERRITORIES));
            tf = lstrfind(segname, this.cachedTerritory(terr));
        end
        function tf          = isInHemisphere(~, segname, hemi)
            if (lstrfind(segname, [hemi '_']))
                tf = true;
            else
                tf = false;
            end                
        end
        function this        = generateSegidentifiedSegnameMap(this)
            %% GENERATESEGIDENTIFIEDSEGNAMEMAP generates a mapping of segid to segname from file this.COLOR_LUT_FILENAME.
            %  It is public & browsable for purposes of troubleshooting.
            %  It should be called only once per session-level analysis.
            %  Private territory caches are generated for territorial analyses; caller must update object this.
            
            theText = mlio.TextIO.textfileToCell( ...
                                  fullfile(this.bldr_.studyPath, this.COLOR_LUT_FILENAME));
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
                        switch (rgxnames.territory)
                            case 'aca'
                                this.cachedAllLabels_    = [this.cachedAllLabels_    rgxnames.segname];
                                this.cachedAcaMcaLabels_ = [this.cachedAcaMcaLabels_ rgxnames.segname];
                                this.cachedAcaLabels_    = [this.cachedAcaLabels_    rgxnames.segname];
                                this.cachedAcaMaxLabels_ = [this.cachedAcaMaxLabels_ rgxnames.segname];
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
                                this.cachedPcaLabels_    = [this.cachedPcaLabels_    rgxnames.segname];
                                this.cachedPcaMaxLabels_ = [this.cachedPcaMaxLabels_ rgxnames.segname];
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
                                this.cachedMcaMaxLabels_ = [this.cachedMcaMaxLabels_ rgxnames.segname];
                                this.cachedPcaMaxLabels_ = [this.cachedPcaMaxLabels_ rgxnames.segname];
                            case 'sinus'
                                this.cachedSinusLabels_  = [this.cachedSinusLabels_  rgxnames.segname];
                            case 'cereb'
                                this.cachedCerebLabels_  = [this.cachedCerebLabels_  rgxnames.segname];
                        end
                    end
                end
            end 
        end
        
        function aMap        = segidentifiedStatsMap(this, hemi, param, varargin)
            %% SEGIDENTIFIEDSTATSMAP maps segmentation id-numbers to stats
            %  Usage:   aMap = obj.segidentifiedStatsMap(hemi, param[, terr, statistic])
            %                                            ^ 'lh'|'rh'
            %                                                  ^ from this.PARAMS
            %                                                          ^ from this.TERRITORIES 
            %                                                                 ^ from this.STATISTICS
            
            p = inputParser;
            addRequired(p, 'hemi',                      @(x) lstrfind(x, this.HEMIS));
            addRequired(p, 'param',                     @ischar);
            addOptional(p, 'terr', this.TERRITORIES{2}, @(x) lstrfind(x, this.TERRITORIES));
            addOptional(p, 'statistic', 'mean',         @(x) lstrfind(x, this.STATISTICS));
            parse(p, hemi, param, varargin{:});  
            
            import mlsurfer.*;
            if (lstrfind(param, { 'dsa' 'cvs' 'thicknessStd' 'thickness' })) 
                %% SPECIAL CASES
                
                aMap          = containers.Map('KeyType', 'double', 'ValueType', 'any');
                segname2stats = this.segnamedStatsMap(hemi, param, p.Results.terr);
                segid2segname = this.segidentifiedSegnameMap;
                segids        = segid2segname.keys;                
                for s = 1:length(segids)
                    try
                        segname = segid2segname(segids{s}).segname;
                        if (this.isInHemisphere(segname, hemi) && this.isInTerritory(segname, p.Results.terr))
                            aMap(segids{s}) = segname2stats(segname);
                        end
                    catch ME2
                        if (~lstrfind(segname, 'Medial_wall') && ...
                            ~lstrfind(param, mlsurfer.PETSegstatsBuilder.OC_FILEPREFIX)) %% known to be missing in imaging data
                            this.fprintfException('segidentifiedStatsMap', '[table-file for dsa, cvs, thickness, thicknessstd]', ...
                                                   segids{s}, [segname '...']);
                            handwarning(ME2);
                        end
                    end
                end
            else
                
                aMap = this.segidentifiedParameterizedMap(hemi, param, p.Results.terr);
            end
            
            aMap = Parcellations.singleStatMap(aMap, p.Results.statistic);
        end        
        function aMap        = segnamedStatsMap(this, hemi, param, varargin)
            %% SEGNAMEDSTATSMAP maps segmentation names to stats, returned as a struct
            %  Usage:   aMap = obj.segnamedStatsMap(hemi, param[, terr])
            %                                       ^ 'lh'|'rh'
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
            if (lstrfind(lower(param), 'thickness') || lstrfind(lower(param), 'thicknessStd'))
                aMap = this.segnamedThicknessMap(hemi, param, p.Results.terr); 
                return; 
            end      
            aMap = this.segnamedParameterizedMap(hemi, param, p.Results.terr);
        end
    end 
    
    %% PRIVATE
    
    properties (Constant, Access = 'private')
        DSA_TEXT_EXPR             = '(?<territory>\S+)\s+(?<impaired>\d)'
        INDEXED_TEXT_EXPR         = '(?<segid>\d+)\s+(?<segname>\S+)\s+(?<rgba>\d+\s+\d+\s+\d+\s+\d+)\s+(?<territory>\w+)';
        PARAMETER_TABLE_TEXT_EXPR = '(?<segname>\S+)\s+(?<parameter>\d+(\.\d+|))';
        COLOR_LUT_FILENAME        = 'JJLColorLUTshort.txt';
    end
    
    properties (Access = 'private')
        bldr_
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
        segidentifiedSegnameMap_
    end
    
    methods (Static, Access = 'private')
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
        function keys = keys2str(keys)
            if (ischar(keys{1}))
                return; end
            if (isnumeric(keys{1}))
                keys = cellfun(@(x) num2str(x), keys); return; end
            try
                keys = cellfun(@(x) char(x), keys); 
            catch ME
                handexcept(ME);
            end
        end
        function keys = keys2double(keys)
            if (isnumeric(keys{1}))            
                keys = cellfun(@(x) double(x), keys); return; end
            if (ischar(keys{1}))
                keys = cellfun(@(x) str2double(x), keys); return; end
            error('mlsurfer:unsupportedType', 'Parcellations.keys2double.keys have type %s', class(keys{1}));
        end
        function keys = keys2num(keys)
            if (isnumeric(keys{1}))            
                return; end
            if (ischar(keys{1}))
                keys = cellfun(@(x) str2num(x), keys); return; end %#ok<ST2NM>
            error('mlsurfer:unsupportedType', 'Parcellations.keys2num.keys have type %s', class(keys{1}));
        end
        function m1   = remap(m, kys)
            assert(length(kys) <= length(m));
            m1 = containers.Map;
            for k = 1:length(kys)
                try
                    m1(kys{k}) = m(kys{k});
                catch ME
                    handwarning(ME);
                end
            end
        end
        function        fprintfException(meth, statsFn, line, textline)
            fprintf(['mlsurfer.Parcellations.' meth ' encountered problem in:\n']);
            fprintf('\tfile->\n\t%s\n', statsFn);                                
            fprintf('\tline %i->%s\n', line, textline);
        end
    end
    
    methods (Access = 'private')
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
            rgx = ['\s+(?<' lbl '>(\-|)\d+\.?\d*)'];
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
        
        function aMap  = segnamedDsaMap(this, hemi)
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
            segid2segname = this.segidentifiedSegnameMap;
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
        function aMap  = segnamedThicknessMap(this, hemi, param, terr)
            theText = mlio.TextIO.textfileToCell(this.tableFilename(hemi, param));
        
            try
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
                                    this.fprintfException('segnamedThicknessMap', statsFn, t, textline);
                                    if (~lstrfind(textline, 'nan'))
                                        handerror(ME2);
                                    end
                                end
                            end
                        end
                    end
                end
            catch ME                
                this.fprintfException('segnamedThicknessMap', statsFn, t, textline);
                fprintf('\tSTOPPING\n');
                handerror(ME);
            end
        end
        function aMap  = segnamedThicknessCvsMap(this, hemi, param, terr)
            theText = mlio.TextIO.textfileToCell(this.thicknessCvsTableFilename);  
            
            try
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
                                    this.fprintfException('segnamedThicknessCvsMap', statsFn, t, textline);
                                    if (~lstrfind(textline, 'nan'))
                                        handerror(ME2);
                                    end
                                end
                            end
                        end
                    end
                end
            catch ME
                this.fprintfException('segnamedThicknessCvsMap', statsFn, t, textline);
                fprintf('\tSTOPPING\n');
                handerror(ME);
            end
        end
        function aMap  = segnamedParameterizedMap(this, hemi, param, terr)
            EXCLUSIONS = '_Unknown';
            statsFn    = this.statsFilename(hemi, param);
            theText    = mlio.TextIO.textfileToCell(statsFn);
            
            try
                aMap  = containers.Map;
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
                                    this.fprintfException('segnamedParameterizedMap', statsFn, t, textline);
                                    if (~lstrfind(textline, 'nan'))
                                        handerror(ME2);
                                    end
                                end
                            end
                        end
                    end
                end
            catch ME                
                this.fprintfException('segnamedParameterizedMap', statsFn, t, textline);
                fprintf('\tSTOPPING\n');
                handerror(ME);
            end
        end
        function aMap  = segidentifiedParameterizedMap(this, hemi, param, terr)
            EXCLUSIONS = '_Unknown';
            statsFn    = this.statsFilename(hemi, param);
            theText    = mlio.TextIO.textfileToCell(statsFn);
            
            try
                aMap  = containers.Map('KeyType', 'double', 'ValueType', 'any');
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
                                    this.fprintfException('segidentifiedParameterizedMap', statsFn, t, textline);
                                    if (~lstrfind(textline, 'nan'))
                                        handerror(ME2);
                                    end
                                end
                            end
                        end
                    end
                end
            catch ME                
                this.fprintfException('segidentifiedParameterizedMap', statsFn, t, textline);
                fprintf('\tSTOPPING\n');
                handerror(ME);
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

