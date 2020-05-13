classdef Rois 
	%% ROIS  

	%  $Revision$
 	%  was created 07-May-2020 14:35:39 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.8.0.1359463 (R2020a) Update 1 for MACI64.  Copyright 2020 John Joowon Lee.
 	
	properties
 		parc
 	end

	methods
        function c = imagingCollection(this, pth, varargin)
            ip = inputParser;
            addRequired(ip, 'pth', @isfolder)
            parse(ip, pth, varargin{:})
            ipr = ip.Results;
            
            % indices = [2:85 251:255 1000:1035 2000:2035 3000:3035 4000:4035 5001:5002];
            assert(isfile(fullfile(ipr.pth, 'wmparc.nii.gz')))
            this.parc = mlfourd.ImagingFormatContext(fullfile(ipr.pth, 'wmparc.nii.gz'));
            
            m0 = containers.Map();
            m0('thalamus') = [10 49];
            m0('basal_ganglia') = [11 12 13 26 28 50 51 52 58 60];
            m0('hippocampus') = [17 53 1016 2016 3016 4016];
            m0('amygdala') = [18 54];
            c = this.collectMasksFromParc({}, m0);
            
            m = containers.Map();
            m('cingulate') = [1002 1010 1023 1026];
            m('middle_frontal') = [1003 1027];
            m('cuneus') = [1005];
            m('entorhinal') = [1006];
            m('fusiform') = [1007];
            m('parietal') = [1008 1029 1031];
            m('inferior_temporal') = [1009];
            m('lateral_occipital') = [1011];
            m('orbitofrontal') = [1012 1014];
            m('lingual') = [1013];
            m('middle_temporal') = [1015];
            m('central') = [1017 1022 1024];
            m('opercularis_triangularis') = [1018 1020];
            m('orbitalis') = [1019];
            m('calcarine') = [1021];
            m('precuneus') = [1025];
            m('superior_frontal') = [1028];
            m('superior_temporal') = [1030 1034];
            m('frontal_pole') = [1032];
            m('temporal_pole') = [1033];
            m('insula') = [1035]; %#ok<*NBRAK>
            for k = m.keys % add contralateral and gray-white junctions
                m(k{1}) = [m(k{1}) m(k{1})+1000 m(k{1})+2000 m(k{1})+3000];
            end            
            c = this.collectMasksFromParc(c, m);
        end
        function c = collectMasksFromParc(this, c, map)
            %  @param c is cell
            %  @param map is containers.Map with parc_name =: freesurfer_index
            %  @return c
            
            assert(isa(map, 'containers.Map'))
            for k = map.keys
                c1 = copy(this.parc);
                c1.img = zeros(size(c1));
                for amap = map(k{1})
                    c1.img = c1.img + (this.parc.img == amap);
                end
                if ~this.maskIsempty(c1)
                    c1.fileprefix = k{1};
                    c1 = mlfourd.ImagingContext2(c1);
                    c = [c {c1}]; %#ok<AGROW>
                end
            end
        end
        function tf = maskIsempty(~, m)
            assert(isa(m, 'mlfourd.ImagingFormatContext'))
            tf = 0 == dipsum(m.img);
        end  
		  
 		function this = Rois(varargin)
 			%% ROIS
 			%  @param .

 			
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

