classdef Mri_vol2volOptions < mlsurfer.SurferOptions 
	%% MRI_VOL2VOLOPTIONS   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties  		 
        mov  % movvol       : input (or output template with --inv)
        targ % targvol      : output template (or input with --inv)
        o    % outvol       : output volume
        disp % dispvol      : displacement volume
        lta  % register.lta : Linear Transform Array (usually only 1 transform)
        reg  % register.dat : tkRAS-to-tkRAS matrix   (tkregister2 format)
        fsl  % register.fsl : fslRAS-to-fslRAS matrix (FSL format)
        xfm  % register.xfm : ScannerRAS-to-ScannerRAS matrix (MNI format)
        regheader %         : ScannerRAS-to-ScannerRAS matrix = identity
        mni152reg %         : $FREESURFER_HOME/average/mni152.register.dat
        s         % subject : set matrix = identity and use subject for any templates
        inv %               : sample from targ to mov
        m3z %               : the non-linear warp to be applied
        noDefM3zPath %      : do not use the default non-linear morph path; look at --m3z
        inv_morph %         : invert the non-linear warp to be applied
        tal    %            : map to a sub FOV of MNI305 (with --reg only)
        talres % resolution : set voxel size 1mm or 2mm (def is 1)
        talxfm % xfmfile    : default is talairach.xfm (looks in mri/transforms)
        fstarg % <vol>      : use vol <orig.mgz> from subject in --reg as target
        crop   % scale      : crop and change voxel size
        slice_crop % sS sE  : crop output slices to be within sS and sE
        slice_reverse %     : reverse order of slices, update vox2ras
        slice_bias % alpha  : apply half-cosine bias field
        trilin            % : trilinear interpolation (default)
        nearest           % : nearest neighbor interpolation
        cubic             % : cubic B-Spline interpolation
        interp % interptype : interpolation cubic, trilin, nearest (def is trilin)

        precision  % precisionid : output precision (def is float)
        keep_precision         % : set output precision to that of input
        kernel                 % : save the trilinear interpolation kernel instead
        no_resample            % : do not resample, just change vox2ras matrix
        rot           % Ax Ay Az : rotation angles (deg) to apply to reg matrix
        trans         % Tx Ty Tz : translation (mm) to apply to reg matrix
        shear      % Sxy Sxz Syz : xz is in-plane
        reg_final % regfinal.dat : final reg after rot and trans (but not inv)

        synth       % : replace input with white gaussian noise
        seed   % seed : seed for synth (def is to set from time of day)
        no_save_reg % : do not write out output volume registration matrix
        debug
        version
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

