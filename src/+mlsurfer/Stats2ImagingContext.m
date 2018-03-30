classdef Stats2ImagingContext 
	%% STATS2IMAGINGCONTEXT  

	%  $Revision$
 	%  was created 22-Oct-2017 19:03:58 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
        sessionPath
 		aparcAsegIC
        territory
        statistic
            
        hemis = {'lh' 'rh'}
        ids   = {11101:11175 12101:12175} % constrained by this.territory
        paramOo = 'oo_sumt_737353fwhh'
        paramHo = 'ho_sumt_737353fwhh'
 	end

	methods 
        function c = category(this)
            % CATEGORY calls ParcellationSegments.asMaps to find valid keys for parcs/segs.
            % @param files oo_sumt_737353fwhh_*.stats with listing of valid parcs/segs.
            % @return c.map:  keys -> session string
            %         c.mapsHemis:  {session session}
            %         c.ids:  {region_ids region_ids}
            
            import mlsurfer.*;
            cMap = containers.Map('KeyType', 'double', 'ValueType', 'any');
            [~,sess] = fileparts(this.sessionPath);
            for h = 1:2
                % containers.Map
                ooMap = ParcellationSegments.asMap( ...
                    this.paramOo, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);    
                for ii = 1:length(this.ids{h})
                    if (ooMap.isKey(this.ids{h}(ii)))
                        cMap(this.ids{h}(ii)) = sess;
                    end
                end
            end
            c.map = cMap;
            c.mapsHemis = {sess sess};
            c.ids = this.ids;
        end
        function ooho = oohoCerebDouble(this)
            
            import mlsurfer.*;
            ooho   = [];
            ids_   = {[7 8] [46 47]};
            for h = 1:2
                % containers.Map
                ooMap = ParcellationSegments.asMap( ...
                    this.paramOo, this.hemis{h}, ...
                    'Territory',   'cereb', ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);                
                hoMap = ParcellationSegments.asMap( ...
                    this.paramHo, this.hemis{h}, ...
                    'Territory',   'cereb', ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:2
                    ooho = [ooho ooMap(ids_{h}(ii))/hoMap(ids_{h}(ii))]; %#ok<*AGROW>
                end
            end
            ooho = mean(ooho);
        end
        function oi = oefIndex(this, varargin)
            % OEFINDEX calls ParcellationSegments.asMaps to find valid keys for parcs/segs.
            % @param files {oo,ho}_sumt_737353fwhh_*.stats with listing of valid parcs/segs.
            % @return oi.imagingContext:  for oefIndex mapped to this.aparcAsegIC
            %         oi.map:  keys -> session string
            %         oi.mapsHemis:  {session session}
            %         oi.ids:  {region_ids region_ids}
            
            ip = inputParser;
            addOptional(ip, 'paramOo', this.paramOo, @ischar);
            addOptional(ip, 'paramHo', this.paramHo, @ischar);
            addParameter(ip, 'ICFileprefix', 'oefIndex_737353fwhh_on_T1', @ischar);
            parse(ip, varargin{:})
            
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            oohoCereb = this.oohoCerebDouble;
            oefMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            oefMapsHemis = {[] []};
            for h = 1:2
                % containers.Map
                ooMap = ParcellationSegments.asMap( ...
                    ip.Results.paramOo, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);                
                hoMap = ParcellationSegments.asMap( ...
                    ip.Results.paramHo, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:length(this.ids{h})                    
                    if (hoMap.isKey(this.ids{h}(ii)) && ooMap.isKey(this.ids{h}(ii)))
                        ratio = ooMap(this.ids{h}(ii))/hoMap(this.ids{h}(ii))/oohoCereb;
                        oefMap(this.ids{h}(ii)) = ratio;
                        oefMapsHemis{h} = [oefMapsHemis{h} ratio];
                        if (~isempty(ratio) && ~isnan(ratio))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = ratio;                        
                        end
                    end
                end
                oefMapsHemis{h} = mean(oefMapsHemis{h});
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', 'oefIndex_737353fwhh_on_T1');
            oi.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            oi.map = oefMap;
            oi.mapsHemis = oefMapsHemis;
            oi.ids = this.ids;
        end
        function td = thicknessDiff(this)
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            tdMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            tdMapsHemis = {[] []};
            for h = 1:2
                % containers.Map
                thiMap = ParcellationSegments.asMap( ...
                    'thickness', this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);                
                cvsMap = ParcellationSegments.asMap( ...
                    'cvs', this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:length(this.ids{h})                    
                    if (cvsMap.isKey(this.ids{h}(ii)) && thiMap.isKey(this.ids{h}(ii)))
                        diff = thiMap(this.ids{h}(ii)) - cvsMap(this.ids{h}(ii));
                        tdMap(this.ids{h}(ii)) = diff;
                        tdMapsHemis{h} = [tdMapsHemis{h} diff];
                        if (~isempty(diff) && ~isnan(diff))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = diff;                        
                        end
                    end
                end
                tdMapsHemis{h} = mean(tdMapsHemis{h});
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', 'thicknessDiff_737353fwhh_on_T1');
            td.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            td.map = tdMap;
            td.mapsHemis = tdMapsHemis;
            td.ids = this.ids;
        end
        function t = thickness(this)
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            tdMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            tdMapsHemis = {[] []};
            for h = 1:2
                % containers.Map
                thiMap = ParcellationSegments.asMap( ...
                    'thickness', this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:length(this.ids{h})                    
                    if (thiMap.isKey(this.ids{h}(ii)))
                        thick = thiMap(this.ids{h}(ii));
                        tdMap(this.ids{h}(ii)) = thick;
                        tdMapsHemis{h} = [tdMapsHemis{h} thick];
                        if (~isempty(thick) && ~isnan(thick))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = thick;                        
                        end
                    end
                end
                tdMapsHemis{h} = mean(tdMapsHemis{h});
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', 'thicknessDiff_737353fwhh_on_T1');
            t.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            t.map = tdMap;
            t.mapsHemis = tdMapsHemis;
            t.ids = this.ids;
        end
        function ti = thicknessIndex(this)
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            tiMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            for h = 1:2
                % containers.Map
                thiMap = ParcellationSegments.asMap( ...
                    'thickness', this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);                
                cvsMap = ParcellationSegments.asMap( ...
                    'cvs', this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:length(this.ids{h})                    
                    if (cvsMap.isKey(this.ids{h}(ii)) && thiMap.isKey(this.ids{h}(ii)))
                        ratio = thiMap(this.ids{h}(ii))/cvsMap(this.ids{h}(ii));
                        tiMap(this.ids{h}(ii)) = ratio;
                        if (~isempty(ratio) && ~isnan(ratio))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = ratio;                        
                        end
                    end
                end
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', 'thicknessIndex_on_T1');
            ti.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            ti.map = tiMap;
            ti.ids = this.ids;
        end
        function p = aParameter(this, param)
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            pMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            for h = 1:2
                % containers.Map
                pMap = ParcellationSegments.asMap( ...
                    param, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath); 
                for ii = 1:length(this.ids{h})                    
                    if (pMap.isKey(this.ids{h}(ii)))
                        val = pMap(this.ids{h}(ii));
                        if (~isempty(val) && ~isnan(val))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = val;                        
                        end
                    end
                end
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', [param '_on_T1']);
            p.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            p.map = pMap;
            p.ids = this.ids;
        end
        function p = paramImagingContext(this, param)
            assert(ischar(param));
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            for h = 1:2
                % containers.Map
                pMap = ParcellationSegments.asMap( ...
                    param, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'Statistic',   this.statistic, ...
                    'SessionPath', this.sessionPath);
                for ii = 1:length(this.ids{h})
                    if (pMap.isKey(this.ids{h}(ii)))
                        cnts = pMap(this.ids{h}(ii));
                        if (~isempty(cnts) && ~isnan(cnts))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = cnts;                        
                        end
                    end
                end
            end
            aparcZerosNN.fqfileprefix = fullfile(this.sessionPath, 'fsl', [param '_on_T1']);
            p = mlfourd.ImagingContext(aparcZerosNN);
        end
		  
 		function this = Stats2ImagingContext(varargin)
 			%% STATS2IMAGINGCONTEXT
 			%  Usage:  this = Stats2ImagingContext()

            ip = inputParser;
 			addParameter(ip, 'sessionPath', @isdir);
            addParameter(ip, 'aparcAseg', 'aparc.a2009s+aseg.mgz', @ischar);
            addParameter(ip, 'reference', 'T1', @ischar);
            addParameter(ip, 'territory', 'all', @ischar);
            addParameter(ip, 'statistic', 'mean', @ischar);
            parse(ip, varargin{:});           
            
            this.sessionPath = ip.Results.sessionPath;
            if (isa(ip.Results.aparcAseg, 'mlfourd.ImagingContext'))                
                this.aparcAsegIC = ip.Results.aparcAseg;
            else
                this.aparcAsegIC = mlfourd.ImagingContext( ...
                    fullfile(ip.Results.sessionPath, 'mri', ip.Results.aparcAseg));
            end
            this.territory = ip.Results.territory;            
            this.statistic = ip.Results.statistic;
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

