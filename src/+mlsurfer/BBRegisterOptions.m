classdef BBRegisterOptions < mlsurfer.SurferOptions 
	%% BBREGISTEROPTIONS defines options for bbregister which performs within-subject, cross-modal registration using a
	%  boundary-based cost function. The registration is constrained to be 6 DOF (rigid). It is required that you have 
    %  an anatomical scan of the subject that has been analyzed in freesurfer.
    %  Usage:  bbregister --s <subj> --mov <volid> --reg <regfile>  --init-<type> --<contrast>

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 

	properties 

        %% REQUIRED FLAGGED ARGUMENTS
        
        s % subject
        % FreeSurfer subject name as found in $SUBJECTS_DIR.
         
        mov % volid
        % "Moveable" volume. This is the template for the cross-modal 
        % volume. Eg, for fMRI, it is the volume used for motion 
        % correction.
         
        reg % register.dat
        % Output FreeSurfer (tkregister-style) registration file (simple text).
         
        %% INITIALIZATION ARGUMENTS (ONE REQUIRED)
         
        init_fsl
        % Initialize using FSL FLIRT (requires that FSL be installed).
         
        init_spm
        % Initialize using SPM spm_coreg (requires that SPM and matlab 
        % be installed).
         
        init_header
        % Assume that the geometry information in the cross-modal and 
        % anatomical are sufficient to get a close voxel-to-voxel 
        % registration. This usually is only the case if they were 
        % acquired in the same session.
         
        init_reg % initregfile
        % Supply an initial registration matrix.
         
        %% CONTRAST ARGUMENTS (ONE REQUIRED)
         
        t1
        % Assume t1 contrast, ie, White Matter brighter than Grey Matter
         
        t2
        % Assume t2 contrast, ie, Gray Matter brighter than White Matter
         
        bold
        % Same as --t2
         
        dti
        % Same as --t2

        %% OPTIONAL FLAGGED ARGUMENTS

        int % intvol
        % Supply a volume to use an an intermediate volume when 
        % performing registration. This is useful for when the 
        % cross-modal is volume is a partial field-of-view (FoV). If you
        % acquire in the same session a whole-head FoV, then pass the 
        % whole-head as the intermediate and the partial as the 
        % moveable.
         
        mid_frame
        % reg to middle frame (not with --frame)
         
        frame % frameno
        % reg to frameno (default 0=1st)
         
        template_out % template
        % save template (good with --frame)
         
        o % outvol
        % resample mov and save as outvol
         
        s_from_reg % reg
        % get subject name from regfile
         
        rms % rmsfile
        % RMS change in cortical surface position
         
        fslmat % flirt.mtx
        % output an FSL FLIRT matrix
         
        lta % output.lta
        % output an LTA registration matrix (This flag can be used along with or instead of --reg!) 
         
        lh_only
        % only use left hemi
         
        rh_only
        % only use right hemi
         
        slope1 % slope1
        % cost slope for 1st stage (default is 0.5)
         
        slope2 % slope2
        % cost slope for 2nd stage (default is 0.5)
         
        offset2 % offset2
        % cost offset for 2nd stage (default is 0)
         
        tol1d % tol1d
        % 2nd stage 1D tolerance 
         
        tol % tol
        % 2nd stage loop tolerance (same as --tolf)
         
        tolf % tolf
        % 2nd stage loop tolerance (same as --tol)
        % Be careful making these tolerances more stringent as they can cause underflows and NaNs.
         
        nmax % nPowellMax
        % set max number of iterations (default 36)
        
        rand_init % randmax
        % randomly change input to 1st stage reg
         
        gm_proj_frac % frac
        % default is 0.5
         
        gm_proj_abs % abs
        % use absolute instead of relative
         
        wm_proj_abs % dist
        % 2nd stage, default is 2mm
         
        proj_abs % dist
        % use wm and gm proj abs in 2nd stage
         
        subsamp % nsub
        % 2nd stage vertex subsampling, default is 1
         
        nearest
        % 2nd stage, use nearest neighbor interp (defalt is trilinear)
         
        epi_mask
        % mask out brain edge and B0 regions (1st and 2nd stages)
         
        no_cortex_label
        % Do not use ?h.cortex.label to mask. 
         
        label % labelfile
        % Use label to mask. 
         
        brute1max % max
        % pass 1 search -max to +max (default 4)
         
        brute1delta % delta
        % pass 1 search -max to +max step delta (default 4)
         
        subsamp1 % nsubsamp
        % pass 1 vertex subsampling (default 1)
         
        no_pass1
        % turn off pass 1
         
        surf % surfname
        % change surface to surfname from ?h.white 
         
        surf_cost % basename
        % saves final cost as basename.?h.mgh
         
        surf_con % basename
        % saves final contrast as basename.?h.mgh
         
        init_reg_out % outinitreg
        % save initial reg
         
        initcost % initcostfile
        % save initial cost
         
        spm_nii
        % Use NIFTI format as input to SPM when using --init-spm 
        % (spmregister). Ordinarily, it uses ANALYZE images to be 
        % compatible with older versions of SPM, but this has caused 
        % some left-right reversals in SPM8.
         
        feat % featdir
        % FSL FEAT directory. Sets mov to featdir/example_func, uses 
        % --init-fsl, --bold, sets reg to featdir/reg/freesurfer/
        % anat2exf.register.dat. This replaces reg-feat2anat.
         
        tmp % tmpdir
        % temporary dir (implies --nocleanup)
         
        nocleanup
        % do not delete temporary files
         
        version
        % print version and exit
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

