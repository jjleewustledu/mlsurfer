classdef MGH <  mlio.IOInterface
	%% MGH has-an mlfourd.NIfTI by composition

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  
    
    properties (Constant) 
        FILETYPE_EXT = '.mgz';
    end

	properties (Dependent)
        filename
        filepath
        fileprefix 
        filesuffix
        fqfilename
        fqfileprefix
        fqfn
        fqfp
        noclobber
    end
    
    methods %% Set/Get
        function this = set.filename(this, fn)
            [this.filepath,this.fileprefix,this.filesuffix] = gzfileparts(fn);
        end
        function fn   = get.filename(this)
            fn = [this.fileprefix this.filesuffix];
        end
        function this = set.filepath(this, pth)
            assert(ischar(pth));
            this.nifti_.filepath = pth;
        end
        function pth  = get.filepath(this)
            pth = this.nifti_.filepath;
        end
        function this = set.fileprefix(this, fp)
            assert(ischar(fp));
            [~,this.nifti_.fileprefix] = gzfileparts(fp);
        end
        function fp   = get.fileprefix(this)
            fp = this.nifti_.fileprefix;
        end
        
        function fs   = get.filesuffix(this)
            fs = this.FILETYPE_EXT;
        end
        
        function this = set.fqfilename(this, fqfn)
            [this.nifti_.filepath,this.nifti_.fileprefix] = gzfileparts(fqfn);
        end
        function fqfn = get.fqfilename(this)
            fqfn = [this.nifti_.fqfileprefix this.filesuffix];
        end
        function this = set.fqfileprefix(this, fqfp)
            [this.nifti_.filepath, this.nifti_.fileprefix] = gzfileparts(fqfp);
        end
        function fqfp = get.fqfileprefix(this)
            fqfp = fullfile(this.filepath, this.fileprefix);
        end
        function this = set.fqfn(this, f)
            this.fqfilename = f;
        end
        function f    = get.fqfn(this)
            f = this.fqfilename;
        end
        function this = set.fqfp(this, f)
            this.fqfileprefix = f;
        end
        function f    = get.fqfp(this)
            f = this.fqfileprefix;
        end
        function this = set.noclobber(this, nc)
            assert(islogical(nc));
            this.nifti_.noclobber = nc;
        end
        function tf   = get.noclobber(this)
            tf = this.nifti_.noclobber;
        end
    end
    
    methods (Static)
        function this  = load(filestr)
            %% LOAD
            %  Usage:   mgh_object = mgh_object.load(file_string)
            %                                        ^ .mgz, .mgh, .nii.gz, .nii
            
            import mlfourd.*;
            this = mlsurfer.MGH;
            assert(ischar(filestr));
            if (lstrfind(filestr, {'.mgz' '.mgh'}))
                this.mri_convert(filestr); 
                this.nifti_ = NIfTI.load( ...
                              this.mghFilename2niiFilename(filestr));
                return
            end
            this.nifti_ = NIfTI.load(filestr);
        end
        function niifn = mghFilename2niiFilename(mghfn)
            fqfp  = mghfn(1:end-length(mlsurfer.MGH.FILETYPE_EXT));
            niifn = filename(fqfp);
            if (~lexist(niifn, 'file'))
                mlsurfer.MGH.mri_convert(mghfn); end
        end
    end    
    
    methods
        function        save(this) 
            this.nifti_.save;
            this.mri_convert( ...
                 this.nifti_.fqfilename);
        end
        function this = saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save;
        end
        function c    = char(this)
            c = this.fqfilename;
        end
        function obj  = clone(this)
            obj = mlsurfer.MGH(this);
        end
        
        function this = MGH(varargin)
            %% MGH
            %  Usage:   obj = MGH([mgh_object, nifti_object);
            
            if (nargin > 0)
                if (isa(varargin{1}, 'mlsurfer.MGH'))
                    this.nifti_ = varargin{1}.nifti_;
                end
                if (isa(varargin{1}, 'mlfourd.NIfTIInterface'))
                    varargin{1}.save;
                    this = this.load( ...
                           this.mri_convert(varargin{1}.fqfilename));
                end
            end
        end
    end

    %% PRIVATE
    
    properties (Access = 'private')
        nifti_
    end
    
    methods (Static, Access = 'private')        
        function f2 = mri_convert(f1, f2)
            assert(lexist(f1, 'file'), sprintf('MGH.mri_convert:  file not found:  %s', f1));
            if (~exist('f2', 'var'))
                [~,~,fsuffix] = gzfileparts(f1);
                if (strcmp('.nii.gz', fsuffix) || strcmp('.nii', fsuffix))
                    f2 = filename( ...
                         fileprefix(f1, fsuffix), mlsurfer.MGH.FILETYPE_EXT); 
                end
                if (strcmp('.mgz', fsuffix)    || strcmp('.mgh', fsuffix))
                    f2 = filename( ...
                         fileprefix(f1, fsuffix), mlfourd.NIfTI.FILETYPE_EXT); 
                end
            end
            mlbash(sprintf('mri_convert %s %s', f1, f2));
        end
    end
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

