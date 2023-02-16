classdef SurferFacade 
	%% SURFERFACADE  

	%  $Revision$
 	%  was created 30-Dec-2015 17:40:37
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties (SetAccess = protected)
 		sessionData
 	end

	methods 
		  
 		function this = SurferFacade(varargin)
 			%% SURFERFACADE
 			%  Usage:  this = SurferFacade()

            ip = inputParser;
            addParameter(ip, 'sessionData', [], @(x) isa(x, 'mlpipeline.ISessionData'));
            parse(ip, varargin{:});
            
            this.sessionData = ip.Results.sessionData;
        end
        
        function ic = aparcA2009sAseg(this)
            ic = mlfourd.ImagingContext( ...
                fullfile(this.sessionData.mriPath, 'aparc.a2009s+aseg.mgz'));
            ic.filesuffix = '.nii.gz';
        end
        function ic = maskRegion(~, hparc, region)
            assert(isa(hparc, 'function_handle'));
            switch region
                case 'amygdala'
                    ic = hparc('include', [18 54]);
                    ic.fileprefix = [ic.fileprefix '_amygdala'];
                case 'cerebellum'
                    ic = hparc('include', [7 8 46 47]);
                    ic.fileprefix = [ic.fileprefix '_cerebellum'];
                case 'cerebrum'
                    ic = hparc('exclude', [16 7 8 46 47 14 15 4 43 31 63 24]); % brainstem cerebellumx4 ventriclesx4 choroidplexus csf
                    ic.fileprefix = [ic.fileprefix '_cerebrum'];
                case 'hippocampus'
                    ic = hparc('include', [17 53]);
                    ic.fileprefix = [ic.fileprefix '_hippocampus'];
                case 'thalamus'
                    ic = hparc('include', [10 49]);
                    ic.fileprefix = [ic.fileprefix '_thalamus'];
                otherwise
                    error('mlfsl:unsupportedSwitchCase', 'SurferFacade.maskRegion.region->%s', region);
            end  
            ic.save;
        end
        function ic = maskAparcA2009sAseg(this, selection, idxList)
            import mlfourd.*;
            switch selection
                case 'include'
                    ic = this.aparcA2009sAseg;
                    niid = ic.niftid;
                    for idx = 1:length(idxList)
                        niid.img(niid.img == idxList(idx)) = -1;
                    end
                    ic = ImagingContext(MaskingNIfTId(niid, 'uthresh', 0, 'binarized', true));
                case 'exclude'
                    ic = this.aparcA2009sAseg;
                    niid = ic.niftid;
                    for idx = 1:length(idxList)
                        niid.img(niid.img == idxList(idx)) = 0;
                    end
                    ic = ImagingContext(MaskingNIfTId(niid, 'binarized', true));
                otherwise
                    error('mlfsl:unsupportedSwitchCase', 'SurferFacade.maskAparcA2009sAseg.selection->%s', selection);
            end
        end
        function ic = maskWmparc(this, selection, idxList)
            import mlfourd.*;
            switch selection
                case 'include'
                    ic = this.wmparc;
                    niid = ic.niftid;
                    for idx = 1:length(idxList)
                        niid.img(niid.img == idxList(idx)) = -1;
                    end
                    ic = ImagingContext(MaskingNIfTId(niid, 'uthresh', 0, 'binarized', true));
                case 'exclude'
                    ic = this.wmparc;
                    niid = ic.niftid;
                    for idx = 1:length(idxList)
                        niid.img(niid.img == idxList(idx)) = 0;
                    end
                    ic = ImagingContext(MaskingNIfTId(niid, 'binarized', true));
                otherwise
                    error('mlfsl:unsupportedSwitchCase', 'SurferFacade.maskAparcA2009sAseg.selection->%s', selection);
            end
        end
        function ic = wmparc(this)            
            ic = mlfourd.ImagingContext( ...
                fullfile(this.sessionData.mriPath, 'wmparc.mgz'));
            ic.filesuffix = '.nii.gz';
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

