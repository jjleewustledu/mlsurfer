classdef SurferFacade 
	%% SURFERFACADE  

	%  $Revision$
 	%  was created 30-Dec-2015 17:40:37
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties (SetAccess = protected)
 		studyData
 	end

	methods 
		  
 		function this = SurferFacade(varargin)
 			%% SURFERFACADE
 			%  Usage:  this = SurferFacade()

            ip = inputParser;
            ip.addParameter(ip, 'studyData', [], @(x) isa(x, 'mlpipeline.StudyDataSingleton'));
            parse(ip, varargin{:});
        end
        
        function ic = aparcA2009sAseg(this)
            ic = mlfourd.ImagingContext( ...
                fullfile(this.studyData.mriPath, 'aparc.a2009s+aseg.mgz'));
            ic.filesuffix = '.nii.gz';
        end
        function ic = maskRegion(this, region)
            switch region
                case 'amygdala'
                    ic = this.maskAparcA2009sAseg('include', [18 54]);
                    ic.append_fileprefix('_amygdala');
                case 'cerebellum'
                    ic = this.maskAparcA2009sAseg('include', [7 8 46 47]);
                    ic.append_fileprefix('_cerebellum');
                case 'cerebrum'
                    ic = this.maskAparcA2009sAseg( ...
                         'exclude', [16 7 8 46 47 14 15 4 43 31 63 24]); % brainstem cerebellumx4 ventriclesx4 choroidplexus csf
                    ic.append_fileprefix('_cerebrum');
                case 'hippocampus'
                    ic = this.maskAparcA2009sAseg('include', [17 53]);
                    ic.append_fileprefix('_hippocampus');
                case 'thalamus'
                    ic = this.maskAparcA2009sAseg('include', [10 49]);
                    ic.append_fileprefix('_thalamus');
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
                    ic = ImagingContext(MaskingNIfTId(niid, 'uthresh', 0, 'binarized'));
                case 'exclude'
                    ic = this.aparcA2009sAseg;
                    niid = ic.niftid;
                    for idx = 1:length(idxList)
                        niid.img(niid.img == idxList(idx)) = 0;
                    end
                    ic = ImagingContext(MaskingNIfTId(niid, 'binarized'));
                otherwise
                    error('mlfsl:unsupportedSwitchCase', 'SurferFacade.maskAparcA2009sAseg.selection->%s', selection);
            end
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

