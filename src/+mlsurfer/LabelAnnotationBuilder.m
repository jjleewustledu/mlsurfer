classdef LabelAnnotationBuilder  
	%% LABELANNOTATIONBUILDER ... 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.3.0.73043 (R2014a) 
 	%  $Id$ 
 	 
    properties (Constant)
        CTAB_FILENAME = 'acamca.aparc.annot.a2009s.ctab'
        LABEL_FOLDER  = 'label_manual'
    end

	properties 
        sessionPath
        studyPath
        hemis = { 'lh' 'rh' }
    end 
    
    properties (Dependent)
        ctab
        fslPath
        labelPath
        subject
    end
    
    methods %% GET
        function c = get.ctab(this)            
            c = fullfile(this.studyPath, this.CTAB_FILENAME);
            assert(lexist(c, 'file'));
        end
        function p = get.fslPath(this)
            p = fullfile(this.sessionPath, 'fsl', '');
        end
        function p = get.labelPath(this)
            p = fullfile(this.sessionPath, this.LABEL_FOLDER, '');
        end
        function s = get.subject(this)
            [~,s] = fileparts(this.sessionPath);
        end
    end

	methods         
        function [s,r] = mri_annotation2label(this)
            if (~lexist(this.labelPath, 'dir'))
                mlbash(strcat('mkdir -p ', this.labelPath));
            end
            for h = 1:length(this.hemis)
                [s,r] = this.surferBash( ...
                    sprintf('mri_annotation2label --subject %s --hemi %s --outdir %s --annotation aparc.a2009s', ...
                    this.subject, this.hemis{h}, this.labelPath));
            end
        end
        function [s,r] = mris_label2annot(this)
            if (~lexist(this.labelPath, 'dir'))
                mlbash(strcat('mkdir -p ', this.labelPath));
            end
            for h = 1:length(this.hemis)
                [s,r] = mlbash( ...
                    sprintf('mris_label2annot --ctab %s --ldir %s --s %s --a acamca.aparc.a2009s --h %s --nhits %s --no-unknown', ...
                    this.ctab, this.labelPath, this.subject, this.hemis{h}, this.nhitsFilename(this.hemis{h})));
            end
        end   
        function f = nhitsFilename(this, hemi)
            f = fullfile(this.labelPath, [hemi '.nhits.mgh']);
        end     
        function [s,r] = mri_vol2surf(this, varargin)
            p = inputParser;
            import mlsurfer.*;
            addOptional(p, 'volumeFqfn', ...
                           fullfile(this.fslPath, ...
                           ['oefnq_default_161616fwhh_on_' SurferFilesystem.T1_FILEPREFIX '_on_fsanatomical.mgz']), ...
                           @(x) lexist(x, 'file'));
            parse(p, varargin{:});
            
            for h = 1:length(this.hemis)
                [s,r] = mlbash( ...
                    sprintf('mri_vol2surf --mov %s --regheader %s --hemi %s --o %s', ...
                                                p.Results.volumeFqfn, ...
                                                this.subject, ...
                                                this.hemis{h}, ...
                                                this.surfacedFilename(this.hemis{h}, p.Results.volumeFqfn)));
            end
        end
        function f = surfacedFilename(this, hemi, volfn)
            f = fullfile(this.sessionPath, 'surf', [hemi '.' this.volumeParameter(volfn) '.mgh']);
        end
        function p = volumeParameter(~, volfn)
            [~,fn] = fileparts(volfn);
            p = strtok(fn, '_');
        end
        function [s,r] = freeview(this)
            cd(this.sessionPath);
            [s,r] = mlbash( ...
                sprintf(['freeview -f  surf/lh.inflated:overlay=%s:name=%s ' ...
                                      'surf/lh.inflated:overlay=%s:name=%s ' ...
                                      'surf/rh.inflated:overlay=%s:name=%s ' ...
                                      'surf/rh.inflated:overlay=%s:name=%s    &'], ...
                                      'lh.thickness',                       'lh_inflated_thickness', ...
                                      this.surfacedFilename('lh', 'oefnq'), 'lh_inflated_oefnq', ...
                                      'rh.thickness',                       'rh_inflated_thickness', ...
                                      this.surfacedFilename('rh', 'oefnq'), 'rh_inflated_oefnq'));
        end
        function [s,r]  = surferBash(this, cmdlin)
            %% SURFERBASH wraps mlbash with the shell environment required by freesurfer
            
            assert(ischar(cmdlin));
            setenv('SUBJECTS_DIR', this.studyPath)
            try
                r = ''; [s,r] = mlbash(cmdlin); 
                r  = checkReturnOf(s,r);
            catch ME
                handexcept(ME,r);
            end
        end
        
        function this = LabelAnnotationBuilder(varargin)
            p = inputParser;
            addOptional(p, 'SessionPath', pwd, @(x) lstrfind(x, 'mm0') && lexist(x, 'dir'));
            parse(p, varargin{:});
            
            this.sessionPath = p.Results.SessionPath;
            this.studyPath   = fileparts(this.sessionPath); 
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

