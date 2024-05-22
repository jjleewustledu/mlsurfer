classdef Schaeffer < handle & mlsystem.IHandle
    %% 165 ~ bone
    %  4,5,14,15,24,43,44,257 ~ csf
    %  85 ~ optic-chiasm
    %  3001-3035,3101-3181,4001-4035,4101-4181 ~ grey-white
    %  20001-20200 ~ Schaeffer cortex
    %  
    %  Created 25-Feb-2024 13:43:14 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
    %  Developed on Matlab 23.2.0.2485118 (R2023b) Update 6 for MACA64.  Copyright 2024 John J. Lee.


    properties (Dependent)
        product
        schaeffer
    end

    methods %% GET
        function g = get.product(this)
            g = this.schaeffer;
        end
        function g = get.schaeffer(this)
            g = this.schaeffer_;
        end
    end
    
    methods
        function this = Schaeffer(varargin)
            %  Args:
            %      obj (any): understood by mlfourd.ImagingContext2.  Must reference a file representing schaeffer parcs/segs.
            
            ip = inputParser;
            addRequired(ip, "obj", @(x) ~isempty(x))
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            this.schaeffer_ = mlfourd.ImagingContext2(ipr.obj);
            assert(isfile(this.schaeffer_.fqfn))
        end

        function n = label_to_num(~, lbl)
            switch convertStringsToChars(lbl)
                case 'head-extra-cerebral'
                    n = 258;
                case 'bone'
                    n = 165;
                case 'air'
                    n = 130;
                case 'csf'
                    n = [4 5 14 15 24 43 44];

                case 'brainstem+'
                    n = [16 28 60 174]; % brainstem + FreeSurfer diencephalon
                case 'cerebellum'
                    n = [7 8 46 47];
                case 'cortex'
                    n = 20001:20200;
                case 'grey-white'
                    n = [3001:3035 3101:3181 4001:4035 4101:4181];
                case 'deep-white'
                    n = [2 41];
                case 'subcortical'
                    n = [10:13 18 49:52 54];
                case 'thalamus'
                    n = [10 49];
                case 'caudate'
                    n = [11 50];
                case 'putamen'
                    n = [12 51];
                case 'pallidum'
                    n = [13 52];
                case 'amygdala'
                    n = [18 54];
                case 'hippocampus'
                    n = [17 53];
                case 'ponsvermis'
                    n = [172 174];
                case {'whole-brain', 'wholebrain', 'brain'}
                    n = [16 28 60 174 ...
                         7 8 46 47 ...
                         20001:20200 ...
                         3001:3035 3101:3181 4001:4035 4101:4181 ...
                         2 41 ...
                         10:13 18 49:52 54 ...
                         17 53 ...
                         172 174];
                    n = unique(n);
                otherwise
                    n = [258 165 130 ...
                         4 5 14 15 24 43 44 ...
                         16 28 60 174 ...
                         7 8 46 47 ...
                         20001:20200 ...
                         3001:3035 3101:3181 4001:4035 4101:4181 ...
                         2 41 ...
                         10:13 18 49:52 54 ...
                         17 53 ...
                         172 174];
                    n = unique(n);
            end
        end
        function lbl = num_to_label(~, n)
            lbl = mat2str(n);
            lbl = strrep(lbl, ' ', ',');
            lbl = strrep(lbl, '[', '');
            lbl = lbl(2:end-1); % remove '[' and ']'
        end
        function ic = select_all(this)
            ic = this.schaeffer_.numgt(0);
            ic.fileprefix = strcat(this.schaeffer_.fileprefix, '_all');
        end
        function ic = select_brain(this)
            ic = this.select_roi("whole-brain");
        end
        function ic = select_gm(this)
            ic = this.select_roi("cortex");
        end
        function ic = select_wm(this)
            ic = this.select_roi("deep-white");
        end
        function ic = select_subcortical(this)
            ic = this.select_roi("subcortical");
        end
        function ic = select_roi(this, varargin)
            ip = inputParser;
            addRequired(ip, "selection", @(x) ~isempty(x))
            parse(ip, varargin{:})
            ipr = ip.Results;

            if istext(ipr.selection)
                indices = this.label_to_num(ipr.selection);
            end
            this.schaeffer_.selectImagingTool();
            ifc = this.schaeffer_.imagingFormat;
            img = ifc.img;
            z = zeros(size(img), class(img));
            for i = asrow(indices)
                z(img == i) = 1;
            end
            ifc.img = z;
            if length(indices) < 10
                ifc.fileprefix = strcat(ifc.fileprefix, '_', this.num_to_label(indices));
            else
                ifc.fileprefix = strcat(ifc.fileprefix, '_', ...
                    string(indices(1)), '-', string(indices(end)));
            end            
            ic = mlfourd.ImagingContext2(ifc);
        end
        function ics = select_rois(this, varargin)
            ip = inputParser;
            addOptional(ip, "selection", "all", @istext)
            addParameter(ip, "save_rois", false, @islogical)
            addParameter(ip, "return_rois", true, @islogical)
            parse(ip, varargin{:})
            ipr = ip.Results;

            if istext(ipr.selection)
                indices = this.label_to_num(ipr.selection);
            end

            if ipr.return_rois
                ics = cell(size(indices));
            else
                ics = {};
            end
            this.schaeffer_.selectImagingTool();
            for ici = 1:numel(indices)
                ifc = this.schaeffer_.imagingFormat;
                img = ifc.img;
                z = zeros(size(img), class(img));
                z(img == indices(ici)) = 1;
                ifc.img = z;
                ifc.fileprefix = sprintf("%s_idx%i", ifc.fileprefix, indices(ici));
                if ipr.save_rois
                    ifc.save();
                end
                if ipr.return_rois
                    ics{ici} = mlfourd.ImagingContext2(ifc);
                end
            end
        end
    end
    methods (Static)
        function this = create(varargin)
            this = mlsurfer.Schaeffer(varargin{:});
        end
        % function this = create_for_kinetics(opts)
        %     arguments
        %         opts.bids_med mlpipeline.ImagingMediator {mustBeNonempty}
        %         opts.representation = []
        %     end
        % 
        %     this = mlsurfer.Schaeffer(opts.bids_med.schaeffer_ic);
        %     this.bids_med_ = opts.bids_med;
        %     this.representation_ = opts.representation;
        % end
        % function this = createFromBids(bids)
        %     assert(isprop(bids, 'schaeffer_ic'))
        %     this = mlsurfer.Wmparc(bids.schaeffer_ic);
        % end
    end

    %% PROTECTED

    properties (Access = protected)
        bids_med_
        representation_
        schaeffer_
    end
    
    methods (Access = protected)
        function that = copyElement(this)
            %%  See also web(fullfile(docroot, 'matlab/ref/matlab.mixin.copyable-class.html'))
            
            that = copyElement@matlab.mixin.Copyable(this);
            if ishandle(this.bids_med_)
                that.bids_med_ = copy(this.bids_med_);
            end
            if ishandle(this.representation_)
                that.representation_ = copy(this.representation_);
            end
            if ishandle(this.schaeffer_)
                that.schaeffer_ = copy(this.schaeffer_);
            end
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
