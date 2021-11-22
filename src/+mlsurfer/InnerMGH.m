classdef InnerMGH < handle & mlfourd.AbstractInnerImagingFormat
	%% INNERMGH  

	%  $Revision$
 	%  was created 21-Jul-2018 23:14:24 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties (Dependent)
 		hdxml
        orient % RADIOLOGICAL, NEUROLOGICAL
        untouch
 	end

	methods (Static)
        function this = create(fn, varargin)
            import mlsurfer.*;
            this = InnerMGH( ...
                InnerMGH.createImagingInfo(fn, varargin{:}), varargin{:});
        end
        function info = createImagingInfo(fn, varargin)
            import mlfourd.*;
            fn2 = [tempFqfilename(myfileparts(fn)) NIfTIInfo.defaultFilesuffix]; 
            mlbash(sprintf('mri_convert %s %s', fn, fn2)); 
            info = NIfTIInfo(fn2, varargin{:});
        end
        function [s,ninfo] = imagingInfo2struct(fn, varargin)
            import mlfourd.*;
            fn2 = [tempFqfilename(myfileprefix(fn)) NIfTIInfo.defaultFilesuffix]; 
            mlbash(sprintf('mri_convert %s %s', fn, fn2));            
            ninfo = NIfTIInfo(fn2, varargin{:});
            nii = ninfo.make_nii;
            s = struct( ...
                'hdr', nii.hdr, ...
                'filetype', ninfo.filetype, ...
                'fileprefix', [myfileprefix(fn) NIfTIInfo.defaultFilesuffix], ...
                'machine', ninfo.machine, ...
                'ext', ninfo.ext, ...
                'img', nii.img, ...
                'untouch', nii.untouch);            
            deleteExisting(fn2);
        end
    end

	methods 	
        
        %% GET/SET
        
        function x = get.hdxml(~)
            x = '';
        end
        function o = get.orient(this)
            if (~isempty(this.orient_))
                o = this.orient_;
                return
            end
            o = '';
        end
        function u = get.untouch(this)
            u = this.imagingInfo_.untouch;
        end
        function     set.untouch(this, s)
            this.imagingInfo_.untouch = logical(s);
        end
        
        %%
        
        function e = fslentropy(~)
            e = nan;
        end
        function E = fslEntropy(~)
            E = nan;
        end
        function this = mutateInnerImagingFormatByFilesuffix(this)
            import mlfourd.* mlfourdfp.* mlsurfer.*;  
            hdr_ = this.hdr;
            switch (this.filesuffix)
                case FourdfpInfo.SUPPORTED_EXT   
                    %deleteExisting([this.fqfileprefix '.4dfp.*']);
                    [this.img_,hdr_] = FourdfpInfo.exportFreeSurferSpaceToFourdfp(this.img_, hdr_);
                    info = FourdfpInfo(this.fqfilename, ...
                        'datatype', this.datatype, 'ext', this.imagingInfo.ext, 'filetype', this.imagingInfo.filetype, 'N', this.N , 'untouch', false, 'hdr', hdr_);      
                    this = InnerFourdfp(info, ...
                       'creationDate', this.creationDate, 'img', this.img, 'label', this.label, 'logger', this.logger, ...
                       'orient', this.orient_, 'originalType', this.originalType, 'seriesNumber', this.seriesNumber, ...
                       'separator', this.separator, 'stack', this.stack, 'viewer', this.viewer);
                    this.imagingInfo.hdr = hdr_;
                case [NIfTIInfo.SUPPORTED_EXT]
                    %deleteExisting([this.fqfileprefix '.nii*']);
                    info = NIfTIInfo(this.fqfilename, ...
                        'datatype', this.datatype, 'ext', this.imagingInfo.ext, 'filetype', this.imagingInfo.filetype, 'N', this.N , 'untouch', false, 'hdr', hdr_);
                    this = InnerNIfTI(info, ...
                       'creationDate', this.creationDate, 'img', this.img, 'label', this.label, 'logger', this.logger, ...
                       'orient', this.orient_, 'originalType', this.originalType, 'seriesNumber', this.seriesNumber, ...
                       'separator', this.separator, 'stack', this.stack, 'viewer', this.viewer);
                    this.imagingInfo.hdr = hdr_;
                case MGHInfo.SUPPORTED_EXT 
                otherwise
                    error('mlfourd:unsupportedSwitchcase', ...
                        'InnerNIfTI.filesuffix->%s', this.filesuffix);
            end
        end
        
        function this = InnerMGH(varargin)
 			%  @param imagingInfo is an mlfourd.ImagingInfo object and is required; it may be an aufbau object.
            
            this = this@mlfourd.AbstractInnerImagingFormat(varargin{:});
        end 
    end
    
    %% PROTECTED
    
    methods (Access = protected)
    end
    
    %% HIDDEN
    
    methods (Hidden) 
        function save__(this)
            that = copy(this);
            assert(strcmp(that.filesuffix, '.mgz') || ...
                   strcmp(that.filesuffix, '.mgh') || ...
                   strcmp(that.filesuffix, '.nii') || ...
                   strcmp(that.filesuffix, '.nii.gz'));
            try
                warning('off', 'MATLAB:structOnObject');
                mlniftitools.save_nii(struct(that), that.fqfileprefix_nii_gz);            
                mlbash(sprintf('mri_convert %s %s', that.fqfileprefix_nii_gz, that.fqfileprefix_mgz));
                %deleteExisting(this.fqfileprefix_nii_gz);  
                %this.filesuffix = '.mgz';
                warning('on', 'MATLAB:structOnObject');
            catch ME
                dispexcept(ME, ...
                    'mlfourd:IOError', ...
                    'InnerNIfTI.save_mgz erred while attempting to save %s', that.fqfilename);
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

