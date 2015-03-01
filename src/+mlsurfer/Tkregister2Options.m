classdef Tkregister2Options < mlsurfer.SurferOptions 
	%% TKREGISTER2OPTIONS  
 	%  tkregister_tcl /Applications/freesurfer/tktools/tkregister2.tcl
    %  USAGE: /Applications/freesurfer/tktools/tkregister2.bin 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
        mov  % movable volume  <fmt> 
        targ % target volume <fmt>
        fstarg % : target is relative to subjectid/mri
        reg % register.dat : input/output registration file
        check_reg % : only check, no --reg needed
        regheader % : compute regstration from headers
        fsl_targ % : use FSLDIR/data/standard/avg152T1.nii.gz
        fsl_targ_lr % : use FSLDIR/data/standard/avg152T1_LR-marked.nii.gz
        fstal % : set mov to be tal and reg to be tal xfm  
        gca % subject : check linear GCA registration  
        gca_skull % subject : check linear 'with skull' GCA registration  
        no_zero_cras % : do not zero target cras (done with --fstal)
        movbright % f : brightness of movable volume
        no_inorm % : turn off intensity normalization
        fmov % fmov : set mov brightness 
        fmov_targ % : apply fmov brightness to the target
        plane % orient  : startup view plane <cor>, sag, ax
        slice % sliceno : startup slice number
        volview % volid  : startup with targ or mov
        fov % FOV  : window FOV in mm (default is 256)
        movscale % scale : scale size of mov by scale
        surf % surfname : display surface as an overlay 
        surf_rgb % R G B : set surface color (0-255) 
        lh_only % : only load/display left hemi 
        rh_only % : only load/display right hemi 
        ixfm % file : MNI-style inverse registration input matrix
        xfm % file : MNI-style registration input matrix
        xfmout % file : MNI-style registration output matrix
        fsl % file : FSL-style registration input matrix
        fslregout % file : FSL-Style registration output matrix
        freeview % file : FreeView registration output matrix
        vox2vox % file : vox2vox matrix in ascii
        lta % ltafile : Linear Transform Array
        ltaout % ltaoutfile : Output a Linear Transform Array
        feat % featdir : check example_func2standard registration
        fsfeat % featdir : check reg/freesurfer/register.dat registration
        identity % : use identity as registration matrix
        s % subjectid : set subject id 
        sd % dir : use dir as SUBJECTS_DIR
        noedit % : do not open edit window (exit) - for conversions
        nofix % : don't fix old tkregister matrices
        float2int % code : spec old tkregister float2int
        title % title : set window title
        tag % : tag mov vol near the col/row origin
        mov_orientation % ostring : supply orientation string for mov
        targ_orientation % ostring : supply orientation string for targ
        int % intvol intreg : use registration from intermediate volume 
        
%        2 : double window size 

        size % scale : scale window by scale (eg, 0.5, 1.5) 
        det %  detfile : save determinant of reg mat here
        aseg % : load aseg (hit 'd' to toggle)
        
%        aparc+aseg : load aparc+aseg (hit 'c' to toggle)

        wmparc  % : load wmparc (hit 'c' to toggle)
        gdiagno % n : set debug level
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

