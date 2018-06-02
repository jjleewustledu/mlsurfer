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
    
    methods (Static)
        function this  = load(varargin)
            %% LOAD
            %  Usage:  this = MGH.load((filename[, description]); % args passed to NIfTId
            
            import mlfourd.*;
            this = mlsurfer.MGH(NIfTId.load(varargin{:}));
        end
    end    
    
    methods
        function obj = clone(this)
            obj = mlsurfer.MGH(this.component.clone);
        end
        function       save(this)
            this.component.save;
            mlfourd.MGHState.mri_convert([this.fqfp '.nii'], [this.fqfp this.MGH_EXT]);
            deleteExisting([this.fqfp '.nii']);
            deleteExisting([this.fqfp '.nii.gz']);
        end
        function obj = saveas(this, fqfn)
            obj = this.clone;
            [pth,fp,x] = myfileparts(fqfn);
            if (isempty(x))
                fqfp = fullfile(pth, fp);
                obj.component = this.component.saveas([fqfp this.FILETYPE_EXT]);
                mlfourd.MGHState.mri_convert([fqfp this.FILETYPE_EXT], [fqfp this.MGH_EXT]);
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
            this.filesuffix = this.MGH_EXT;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

