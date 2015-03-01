classdef VascularTerritories

	%% VASCULARTERRITORIES

	%  $Revision$
	%  %Date$
	%  $Author$
	%  $LastChangedDate$
	%  $URL$
	%  developed on Matlab 8.1.0.604 (R2013a)
	%  $Id$

	methods
        function roi  = territoryRoi(this, hemi, terr)
            roi = imcast( ...
                      this.surferRois_.segids2roi( ...
                          this.territory2segids(hemi, terr)), 'mlfourd.ImagingContext');
        end
		function this = VascularTerritories(bldr)
			assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            import mlsurfer.*;
			this.parc_       = Parcellations(bldr);
            this.surferRois_ = SurferRois.createFromSessionPath(bldr.sessionPath); 
		end
    end

    %% PRIVATE
    
	properties (Access = 'private')
		parc_
        surferRois_
    end
    
    methods (Access = 'private')
        function ids = territory2segids(this, hemi, terr)
            [tMap,this.parc_] = this.parc_.territoryMap;
            ids = this.map2segids(tMap, hemi, terr);
        end
        function ids = map2segids(this, itMap, hemi, terr)
            ids       = [];
            indexKeys = itMap.keys;
            for k = 1:length(indexKeys)
                if (this.parc_.isInTerritory(itMap(indexKeys{k}).segname, terr))
                    ids = [ids indexKeys{k}]; %#ok<AGROW>
                end
            end
            ids = this.adjustIds2hemi(ids, hemi);
        end
        function ids = adjustIds2hemi(this, ids, hemi)
            switch (hemi)
                case 'lh'
                    ids = ids + this.parc_.SEGID_LH_OFFSET;
                case 'rh'
                    ids = ids + this.parc_.SEGID_RH_OFFSET;
                otherwise
                    error('mlsurfer:unsupportedParamValue', 'VascularTerritories.adjustIds2hemi.hemi->%s', hemi);
            end
        end
    end
end
