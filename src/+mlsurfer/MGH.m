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
        FILETYPE      = 'MGZ'
        FILETYPE_EXT  = '.mgz'
        % '.img' is SPM format to mri_convert
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
        end
        function obj = saveas(this, fqfn)
            obj = this.clone;
            [pth,fp,x] = myfileparts(fqfn);
            if (isempty(x))
                fqfp = fullfile(pth, fp);
                obj.component_ = this.component.saveas([fqfp mlfourd.MGHInfo.MGH_EXT]);
                mlfourd.MGHState.mri_convert([fqfp this.filesuffix], [fqfp mlfourd.MGHInfo.MGH_EXT]);
                obj.filesuffix = mlfourd.MGHInfo.MGH_EXT;
                deleteExisting([fqfp '.nii']);
                deleteExisting([fqfp '.nii.gz']);
                return
            end
            obj.component_ = this.component.saveas(fqfn);
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
            this.component_.filesuffix = mlfourd.MGHInfo.MGH_EXT;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

