classdef TkmeditOptions < mlsurfer.SurferOptions 
	%% TKMEDITOPTIONS   
 	%   usage: tkmedit {[subject image_type]|[-f absolute_path]}
    %   [surface_file] 
    %   [options ...]
             
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

	properties 
        
        %% Anatomical Data

        subject % image_type  : looks in $SUBJECTS_DIR/subject/mri for image_type. If subject=getreg, gets subject from ov reg
        f % absolute_path     : specify volume directory or file

        %% Surface

%       surface_file % : surface file to load (relative to $SUBJECTS_DIR/surf 
                     % : or absolute)

        %% Options

        aux % <volume>                          : load volume as auxilliary anatomical volume. relative to
                                              % : in $SUBJECTS_DIR/subject/mri or specify absolute path
        pial % <surface>                        : load pial surface locations from  <surface>
        orig % <surface>                        : load orig surface locations from  <surface>
        surface % <surface>                     : load surface as main surface. Relative to
                                              % : in $SUBJECTS_DIR/subject/surf or specify absolute path
        aux_surface % <surface>                 : load surface as auxilliary surface. relative to
                                              % : in $SUBJECTS_DIR/subject/surf or specify absolute path
        surfs                                 % : load lh.white and rh.white
        annotation % <annotation> <color table> : import a surface annotation and color
                                              %   table to the main surface
        main_transform % <transform>            : loads a display transform for the main volume
        aux_transform  % <transform>            : loads a display transform for the aux volume

        bc_main % <brightness> <contrast>       : brightness and contrast for main volume
        bc_main_fsavg                         % : use .58 and 14 for main volume (good for fsaverage)
        mm_main % <min> <max>                   : color scale min and max for main volume
        bc_aux  % <brightness> <contrast>       : brightness and contrast for aux volume
        mm_aux  % <min> <max>                   : color scale min and max for aux volume

        conform     % : conform the main anatomical volume
        aux_conform % : conform the aux anatomical volume

        overlay % <file>             : load functional overlay volume (-ov)
        overlay_reg_find           % : find overlay registration (-ovreg)volume in data dir
        overlay_reg_identity       % : generate identity for overlay registration volume
        overlay_reg % <registration> : load registration file for overlay volume 
                                   % : (default is register.dat in same path as
                                   % :  volume)

        reg % regfile     : use regfile for both overlay and time course

        fthresh % <value> : threshold for overlay (FS_TKFTHRESH)
        fmax    % <value> : max/sat for overlay (FS_TKFMAX)
        fmid    % <value> : values for functional overlay display
        fslope  % <value> : (default is 0, 1.0, and 1.0)
        fsmooth % <sigma> : smooth functional overlay after loading
        noblend         % : do not blend activation color with backgound

        revphaseflag   % <1|0> : reverses phase display in overlay (default off)
        truncphaseflag % <1|0> : truncates overlay values below 0 (default off)
        overlaycache   % <1|0> : uses overlay cache (default off)

        sdir % <subjects dir>           : (default is getenv(SUBJECTS_DIR)
        timecourse % <file>             : load functional timecourse volume (-t)
        timecourse_reg_find           % : find timecourse registration (-treg)volume in data dir
        timecourse_reg_identity       % : generate identity for timecourse registration volume
        timecourse_reg % <registration> : load registration file for timecourse   
                                      % : volume (default is register.dat in
                                      % : same path as volume)
        timecourse_offset % <path/stem> : load timecourse offset volume

        segmentation         % <volume> [colors] : load segmentation volume and color file
        aux_segmentation     % <volume> [colors] : load aux segmentation volume and color file
        segmentation_opacity % <opacity>         : opacity of the segmentation 
                                               % : overlay (default is 0.3)
        aseg                                   % : load aseg.mgz and standard color table
%       aparc+aseg                             % : load aparc+aseg.mgz and standard color table
        wmparc                                 % : load wmparc.mgz and standard color table

        seg_conform     % : conform the main segmentation volume
        aux_seg_conform % : conform the aux segmentation volume

        headpts % <points> [<trans>]   : load head points file and optional
                                     % : transformation

        mip               % : turn on maximum intensity projection
        interface % script  : specify interface script (default is tkmedit.tcl)
        exit              % : exit after rendering
    end 
    
    methods        
        function s = updateOptionsString(this, s, fldname, val)
            if (islogical(val))
                val = ' '; end
            if (isnumeric(val))
                val = num2str(val); end
            s = sprintf('%s --%s %s', s, this.underscores2dashes(fldname), char(val));
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

