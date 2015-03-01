classdef Mri_label2volOptions < mlsurfer.SurferOptions 
	%% MRI_LABEL2VOLOPTIONS   
    %  USAGE: mri_label2vol
    %  $Id: mri_label2vol.c,v 1.34.2.5 2012/06/08 17:31:03 greve Exp $

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
        label           %   labelid <--label labelid>  
        annot % annotfile : surface annotation file  
        seg % segpath     : segmentation
   
% %   --aparc+aseg  : use aparc+aseg.mgz in subjectdir as seg

        temp % tempvolid      : output template volume
        reg % regmat          : VolXYZ = R*LabelXYZ
        regheader % volid     : label template volume (needed with --label or --annot)
                  % for --seg, use the segmentation volume
        identity        %     : set R=I
        invertmtx       %     : Invert the registration matrix
        fillthresh % thresh   : between 0 and 1 (def 0)
        labvoxvol % voxvol    : volume of each label point (def 1mm3)
        proj              %   type start stop delta
        subject % subjectid   : needed with --proj or --annot
        hemi % hemi           : needed with --proj or --annot
        surf % surface        : use surface instead of white
        o % volid             : output volume
        hits % hitvolid       : each frame is nhits for a label
        label_stat % statvol  : map the label stats field into the vol
        stat_thresh  % thresh : only use label point where stat > thresh
        offset % k            : add k to segmentation numbers (good when 0 should not be ignored)
        native_vox2ras      % : use native vox2ras xform instead of tkregister-style
        version             % : print version and exit
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

