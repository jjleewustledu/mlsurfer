classdef MGH < mlfourd.NIfTIdecoratorProperties
	%% MGH is a NIfTIdecorator that composes an internal INIfTI object according to the decorator design pattern.
    %  It is presently a stub for future development of freesurfer tools.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  
    
    properties (Constant) 
        MGH_EXT = '.mgz';
    end

	properties (Dependent)
        niftid
    end
    
    methods %% Get
        function g = get.niftid(this)
            g = this.component;
        end
    end
    
    methods (Static)
        function this  = load(varargin)
            %% LOAD
            %  Usage:  this = MGH.load((filename[, description]); % args passed to NIfTId
            
            import mlfourd.*;
            this = mlsurfer.MGH(NIfTId.load(varargin{:}));
        end
        function niifn = mghFilename2niiFilename(mghfn)
            fqfp  = mghfn(1:end-length(mlsurfer.MGH.MGH_EXT));
            niifn = filename(fqfp);
            if (~lexist(niifn, 'file'))
                mlsurfer.MGH.mri_convert(mghfn, niifn); end
        end
        function mghfn = niiFilename2mghFilename(niifn)
            fqfp  = niifn(1:end-length(mlfourd.INIfTId.FILETYPE_EXT));
            mghfn = [fqfp mlsurfer.MGH.MGH_EXT];
            if (~lexist(mghfn, 'file'))
                mlsurfer.MGH.mri_convert(niifn, mghfn); end
        end
    end    
    
    methods
        function obj = clone(this)
            obj = mlsurfer.MGH(this.component.clone);
        end
        function       save(this)
            this.component.save;
            mlsurfer.MGH.mri_convert([this.fqfp this.FILETYPE_EXT], [this.fqfp this.MGH_EXT]);
            deleteExisting([this.fqfp '.nii']);
            deleteExisting([this.fqfp '.nii.gz']);
        end
        function obj = saveas(this, fqfn)
            obj = this.clone;
            [pth,fp,x] = myfileparts(fqfn);
            if (isempty(x))
                fqfp = fullfile(pth, fp);
                obj.component = this.component.saveas([fqfp this.FILETYPE_EXT]);
                mlsurfer.MGH.mri_convert([fqfp this.FILETYPE_EXT], [fqfp this.MGH_EXT]);
                obj.filesuffix = this.MGH_EXT;
                deleteExisting([fqfp '.nii']);
                deleteExisting([fqfp '.nii.gz']);
                return
            end
            obj.component = this.component.saveas(fqfn);
        end
        
        function this = MGH(cmp, varargin) %#ok<VANUS>
            %% MGH 
            %  Usage:  this = MGH(NIfTIdecorator_object[, option-name, option-value, ...])
            
            import mlfourd.*; 
            this = this@mlfourd.NIfTIdecoratorProperties(cmp, varargin{:});
            if (nargin == 1 && isa(cmp, 'mlsurfer.MGH'))
                this = this.component;
                return
            end
            this = this.append_descrip('decorated by mlsurfer.MGH');
        end
    end

    %% PRIVATE
    
    methods (Static, Access = 'private')
        function f2 = mri_convert(f1, f2)
            assert(lexist(f1, 'file'), sprintf('MGH.mri_convert:  file not found:  %s', f1));
            if (~exist('f2', 'var'))
                [~,~,fsuffix] = myfileparts(f1);
                if (strcmp('.nii.gz', fsuffix) || strcmp('.nii', fsuffix))
                    f2 = filename( ...
                         fileprefix(f1, fsuffix), mlsurfer.MGH.MGH_EXT); 
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

