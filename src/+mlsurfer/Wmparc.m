classdef Wmparc < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
    %% line1
    %  line2
    %  
    %  Created 12-Jan-2022 19:26:18 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
    %  Developed on Matlab 9.11.0.1837725 (R2021b) Update 2 for MACI64.  Copyright 2022 John J. Lee.
    
    methods
        function this = Wmparc(varargin)
            %  Args:
            %      obj (any): understood by mlfourd.ImagingContext2.  Must reference a file representing wmparc.
            
            ip = inputParser;
            addRequired(ip, "obj", @(x) ~isempty(x))
            parse(ip, varargin{:})
            ipr = ip.Results;
            
            this.wmparc_ = mlfourd.ImagingContext2(ipr.obj);
            assert(isfile(this.wmparc_.fqfn))
        end

        function n = label_to_num(~, lbl)
            switch lbl
                case 'brainstem+'
                    n = [16 60 28]; % brainstem + FreeSurfer diencephalon
                otherwise
                    n = 0;
            end
        end
        function lbl = num_to_label(~, n)
            lbl = mat2str(n);
            lbl = strrep(lbl, ' ', ',');
            lbl = strrep(lbl, '[', '');
            lbl = lbl(2:end-1); % remove '[' and ']'
        end
        function ic = select_roi(this, varargin)
            ip = inputParser;
            addRequired(ip, "selection", @(x) ~isempty(x))
            parse(ip, varargin{:})
            ipr = ip.Results;

            if istext(ipr.selection)
                indices = this.label_to_num(ipr.selection);
            end
            this.wmparc_.selectImagingTool();
            form = this.wmparc_.imagingFormat;
            img = form.img;
            z = zeros(size(img), class(img));
            for i = asrow(indices)
                z(img == i) = 1;
            end
            form.img = z;
            form.fileprefix = strcat(form.fileprefix, '_', this.num_to_label(indices));
            ic = mlfourd.ImagingContext2(form);
        end
        function ic = select_gray(this)
            ic = this.wmparc_.numge(1000) & this.wmparc_.numle(2035);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_gray');
        end
        function ic = select_cortex(this)
            ic = this.wmparc_.numge(1000) & this.wmparc_.numle(14175);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_cortex');
        end
    end

    %% PROTECTED

    properties (Access = protected)
        T1_
        wmparc_
    end
    
    methods (Access = protected)
        function that = copyElement(this)
            %%  See also web(fullfile(docroot, 'matlab/ref/matlab.mixin.copyable-class.html'))
            
            that = copyElement@matlab.mixin.Copyable(this);
            if ishandle(this.T1_)
                that.T1_ = copy(this.T1_);
            end
            if ishandle(this.wmparc_)
                that.wmparc_ = copy(this.wmparc_);
            end
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
