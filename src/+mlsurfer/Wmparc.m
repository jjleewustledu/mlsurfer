classdef Wmparc < handle & mlsystem.IHandle
    %% To use native wmparc from FreeSurfer, this = mlsurfer.Wmparc.createFromBids(bids).
    %  To generate wmparc on an imaging obj, this = mlsurfer.Wmparc.createCoregisteredFromBids(bids).
    %  this.product provides sought wmparc implementation as mlfourd.ImagingContext2.
    %  
    %  Created 12-Jan-2022 19:26:18 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
    %  Developed on Matlab 9.11.0.1837725 (R2021b) Update 2 for MACI64.  Copyright 2022 John J. Lee.
    
    methods (Static)
    end

    properties (Dependent)
        product
        T1
        wmparc
    end

    methods %% GET
        function g = get.product(this)
            g = this.wmparc;
        end
        function g = get.T1(this)
            g = this.T1_;
        end
        function g = get.wmparc(this)
            g = this.wmparc_;
        end
    end

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
            this.T1_ = mlfourd.ImagingContext2( ...
                strrep(this.wmparc_.fqfn, 'wmparc', 'T1'));
        end

        function initialize(~, varargin)
            error("mlsurfer:NotImplementedError", stackstr())
        end
        function n = label_to_num(~, lbl)
            switch lbl
                case 'brainstem+'
                    n = [16 28 60 170 173 174 175]; % brainstem + FreeSurfer diencephalon
                case 'cerebellum'
                    n = [7 8 46 47];
                case 'csf'
                    n = [1 4 5 24 43 44];
                case 'dura'
                    n = 99;
                case 'subcortical'
                    n = [9:13 18 48:52 54 101 102 104 105 107 110 111 113 114 116];
                case 'thalamus'
                    n = [10 49];
                case 'caudate'
                    n = [11 50];
                case 'putamen'
                    n = [12 51];
                case 'pallidum'
                    n = [13 52];
                case 'hippocampus'
                    n = [17 53];
                case 'hypothalamus'
                    n = 801:810;
                case 'insula'
                    n = [19 55];
                case 'operculum'
                    n = [20 56];
                case 'amygdala'
                    n = [18 54];
                case 'venous'
                    n = [40 6000]; % co-opting right cerebral exterior
                case 'ponsvermis'
                    n = [172 174];
                case 'centrumsemiovale'
                    n = [5001 5002];
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
        function ic = select_all(this)
            ic = this.wmparc_.numgt(0);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_all');
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
            if length(indices) < 10
                form.fileprefix = strcat(form.fileprefix, '_', this.num_to_label(indices));
            else
                form.fileprefix = strcat(form.fileprefix, '_', ...
                    string(indices(1)), '-', string(indices(end)));
            end   
            ic = mlfourd.ImagingContext2(form);
        end
        function ic = select_cortex(this)
            ic = this.select_gray() | this.select_white();
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_cortex');
        end
        function ic = select_gray(this)
            %% cortical gray

            ic = (this.wmparc_.numge( 1000) & this.wmparc_.numle( 2212)) | ...
                 (this.wmparc_.numge(11100) & this.wmparc_.numle(12175));
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_gray');
        end
        function ic = select_white(this)
            %% cortical white

            ic = (this.wmparc_.numge( 3000) & this.wmparc_.numle( 4181)) | ...
                 (this.wmparc_.numge(13100) & this.wmparc_.numle(14175)) | ...
                 this.wmparc_.numeq(192); 
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_white');
        end
        function ic = select_subcortex(this)
            ic = this.wmparc_.numge(9) & this.wmparc_.numle(13) | ...
                 this.wmparc_.numeq(18) | ...
                 this.wmparc_.numge(48) & this.wmparc_.numle(52) | ...
                 this.wmparc_.numeq(54) | ...
                 this.wmparc_.numeq(101) | ...
                 this.wmparc_.numeq(102) | ...
                 this.wmparc_.numeq(104) | ...
                 this.wmparc_.numeq(105) | ...
                 this.wmparc_.numeq(107) | ...
                 this.wmparc_.numeq(110) | ...
                 this.wmparc_.numeq(111) | ...
                 this.wmparc_.numeq(113) | ...
                 this.wmparc_.numeq(114) | ...
                 this.wmparc_.numeq(116);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_subcortex');
        end
        function ic = select_cerebellum(this)
            ic = this.select_cereb_gray() | this.select_cereb_white();
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_cerebellum');
        end
        function ic = select_cereb_gray(this)
            ic = this.wmparc_.numeq(8) | ...
                 this.wmparc_.numeq(47);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_cereb_gray');
        end
        function ic = select_cereb_white(this)
            ic = this.wmparc_.numeq(7) | ...
                 this.wmparc_.numeq(46);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_cereb_white');
        end
        function ic = select_csf(this)
            ic = this.wmparc_.numeq(1) | ...
                 this.wmparc_.numeq(4) | ...
                 this.wmparc_.numeq(5) | ...
                 this.wmparc_.numeq(24) | ...
                 this.wmparc_.numeq(43) | ...
                 this.wmparc_.numeq(44);
            ic.fileprefix = strcat(this.wmparc_.fileprefix, '_csf');
        end
    end

    methods (Static)
        function this = create(varargin)
            this = mlsurfer.Wmparc(varargin{:});
        end
        function this = create_for_kinetics(opts)
            arguments
                opts.bids_med mlpipeline.ImagingMediator {mustBeNonempty}
                opts.representation = []
            end

            this = mlsurfer.Wmparc(opts.bids_med.wmparc_ic);
            this.bids_med_ = opts.bids_med;
            this.representation_ = opts.representation;
        end
        function this = createCoregisteredFromBids(bids, obj)
            %% Creates an instance of Wmparc in the space of the imaging obj.
            %  The imaging obj must have anatomical features which flirt can co-register with Freesurfer's T1.mgz.
            %  Args:
            %      obj (any): understood by mlfourd.ImagingContext2, able to be co-registered with T1.mgz

            assert(isprop(bids, 'derivAnatPath'))
            assert(isprop(bids, 'T1_ic'))
            obj = mlfourd.ImagingContext2(obj);
            assert(isfile(obj.fqfn))
            
            % return if obj is already coregistered
            if endsWith(obj.fileprefix, strcat('_on_', bids.T1_ic.fileprefix))                
                this = mlsurfer.Wmparc(bids.wmparc_ic);
                return
            end

            % otherwise build this with wmparc_on_obj
            wmparc_on_obj = mlfourd.ImagingContext2( ...
                fullfile(obj.filepath, strcat(bids.wmparc_ic.fileprefix, '_on_', obj.filename)));
            if ~isfile(wmparc_on_obj.fqfn)
                omat = fullfile(obj.filepath, strcat(bids.T1_ic.fileprefix, '_on_', obj.fileprefix, '.mat'));
                out  = fullfile(obj.filepath, strcat(bids.T1_ic.fileprefix, '_on_', obj.filename));
                f = mlfsl.Flirt( ...
                    'in', bids.T1_ic, ...
                    'ref', obj, ...
                    'omat', omat, ...
                    'out', out, ...
                    'cost', 'corratio', 'searchrx', 90, 'interp', 'trilinear', ...
                    'noclobber', true);
                if ~isfile(omat)
                    f.flirt(); % T1 -> obj
                end
                f.in = bids.wmparc_ic;
                f.ref = obj;
                f.out = wmparc_on_obj;
                f.interp = 'nearestneighbour';
                f.applyXfm();
            end
            this = mlsurfer.Wmparc(wmparc_on_obj);
        end
        function this = createFromBids(bids)
            assert(isprop(bids, 'wmparc_ic'))
            this = mlsurfer.Wmparc(bids.wmparc_ic);
        end
    end

    %% PROTECTED

    properties (Access = protected)
        bids_med_
        representation_
        T1_
        wmparc_
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
