classdef Mri_segstatsOptions < mlsurfer.SurferOptions
	%% MRI_SEGSTATSOPTIONS   
    %  Usage: 	mri_segstats --seg segvol --annot  subject hemi parc --slabel subject hemi label --sum file
    
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$
    
	properties 

        %% POSITIONAL ARGUMENTS

        %% REQUIRED FLAGGED ARGUMENTS

        seg % segvol
        % 		Input segmentation volume. A segmentation is a volume whose 
        % 		voxel values indicate a segmentation or class. This can be as 
        % 		complicaated as a FreeSurfer automatic cortical or subcortial 
        % 		segmentation or as simple as a binary mask. The format of 
        % 		segvol can be anything that mri_convert accepts as input (eg, 
        % 		analyze, nifti, mgh, bhdr, bshort, bfloat).
        % 		
        % 		SPECIFYING SEGMENTATION IDS
        % 		
        % 		There are three ways that the list of segmentations to report 
        % 		on
        % 		can be specified:
        % 		1. User specfies with --id.
        % 		2. User supplies a color table but does not specify --id. All 
        % 		the segmentations in the color table are then reported on. If 
        % 		the user specficies a color table and --id, then the segids 
        % 		from --id are used and the color table is only used to 
        % 		determine the name of the segmentation for reporint 
        % 		purposes.
        % 		3. If the user does not specify either --id or a color table, 
        % 		then all the ids from the segmentation volume are used.
        % 		This list can be further reduced by specifying masks and 
        % 		--excludeid.
        % 		
        % 		MEASURES OF BRAIN VOLUME
        % 		
        % 		There will be three measures of brain volume in the output 
        % 		summary file:
        % 		1. BrainSegNotVent - sum of the volume of the structures 
        % 		identified in the aseg.mgz volume this will include cerebellum
        % 		but not ventricles, CSF and dura. Includes partial volume 
        % 		compensation with --pv. This is probably the number you want 
        % 		to report.
        % 		2. BrainMask - total volume of non-zero voxels in 
        % 		brainmask.mgz. This will include cerebellum, ventricles, and 
        % 		possibly dura. This is probably not what you want to 
        % 		report.
        % 		3. BrainSeg - sum of the volume of the structures identified 
        % 		in the aseg.mgz volume. This will  include cerebellum and 
        % 		ventricles but should exclude dura. This does not include 
        % 		partial volume compensation, so this number might be different
        % 		than the sum of the segmentation volumes.
        % 		4. IntraCranialVol (ICV) - estimate of the intracranial volume
        % 		based on the talairach transform. See 
        % 		surfer.nmr.mgh.harvard.edu/fswiki/eTIV for more details. This 
        % 		is the same measure as Estimated Total Intracranial Volume 
        % 		(eTIV).
        % 		
        % 		SUMMARY FILE FORMAT
        % 		
        % 		The summary file is an ascii file in which the segmentation 
        % 		statistics are reported. This file will have some 'header' 
        % 		information. Each header line begins with a '#'. There will be
        % 		a row for each segmentation reported. The number and meaning 
        % 		of the columns depends somewhat how the program was run. The 
        % 		indentity of each column is given in the header. The first col
        % 		is the row number. The second col is the segmentation id. The 
        % 		third col is the number of voxels in the segmentation. The 
        % 		fourth col is the volume of the segmentation in mm. If a color
        % 		table was specified, then the next column will be the 
        % 		segmentation name. If an input volume was specified, then the 
        % 		next five columns will be intensity min, max, range, average, 
        % 		and standard deviation measured across the voxels in the 
        % 		segmentation.

        annot % subject hemi parc
        % 		Create a segmentation from hemi.parc.annot. If parc is aparc 
        % 		or aparc.a2005s, then the segmentation numbers will match 
        % 		those in $FREESURFER_HOME/FreeSurferColorLUT.txt (and so 
        % 		aparc+aseg.mgz). The numbering can also be altered with 
        % 		--segbase. If an input is used, it must be a surface ovelay 
        % 		with the same dimension as the parcellation. This 
        % 		functionality makes mri_segstats partially redundant with mris
        % 		_anatomical_stats.

        slabel % subject hemi label
        % 		Create a segmentation from the given surface label. The points
        % 		in the label are given a value of 1; 0 for outside.

        label_thresh % threshold
        % 		Select only those label points that have a stat value greater 
        % 		than threshold

        sum % file
        % 		ASCII file in which summary statistics are saved. See SUMMARY 
        % 		FILE below for more information.

        %% OPTIONAL FLAGGED ARGUMENTS

        pv % pvvol
        % 		Use pvvol to compensate for partial voluming. This should 
        % 		result in more accurate volumes. Usually, this is only done 
        % 		when computing anatomical statistics. Usually, the mri/
        % 		norm.mgz volume is used. Not with --annot.

        i % invol
        % 		Input volume from which to compute more statistics, including 
        % 		min, max, range, average, and standard deviation as measured 
        % 		spatially across each segmentation. The input volume must be 
        % 		the same size and dimension as the segmentation volume.

        seg_erode % Nerodes
        % 		Erode segmentation boundaries by Nerodes.

        frame % frame
        % 		Report statistics of the input volume at the 0-based frame 
        % 		number. Frame is 0 by default.

        robust % percent
        % 		compute stats after excluding percent from high
        % 		     and low values (volume reported is still full volume).

        sqr
        % 		compute the square of the input prior to computing stats.

        sqrt
        % 		compute the square root of the input prior to computing stats.

        mul % val
        % 		multiply input by val

        snr
        % 		save mean/std as extra column in output table

        abs
        % 		compute absolute value of input before spatial average

        accumulate
        % 		save mean*nvoxels instead of mean

        ctab % ctabfile
        % 		FreeSurfer color table file. This is a file used by FreeSurfer
        % 		to specify how each segmentation index is mapped to a 
        % 		segmentation name and color. See $FREESURFER_HOME/
        % 		FreeSurferColorLUT.txt for example. The ctab can be used to 
        % 		specify the segmentations to report on or simply to supply 
        % 		human-readable names to segmentations chosen with --id. See 
        % 		SPECIFYING SEGMENTATION IDS below.

        ctab_default
        % 		Same as --ctab $FREESURFER_HOME/FreeSurferColorLUT.txt

        ctab_gca % gcafile
        % 		Get color table from the given GCA file. Eg, $FREESURFER_HOME/
        % 		average/RB_all_YYYY-MM-DD.gca This can be convenient when the 
        % 		seg file is that produced by mri_ca_label (ie, aseg.mgz) as it
        % 		will only report on those segmentations that were actually 
        % 		considered during mri_ca_label. Note that there can still be 
        % 		some labels do not have any voxels in the report.

        id % segid <segid2 ...>
        % 		Specify numeric segmentation ids. Multiple ids can be 
        % 		specified with multiple IDs after a single --id or with 
        % 		multiple --id invocations. SPECIFYING SEGMENTATION IDS.

        excludeid % segid
        % 		Exclude the given segmentation id(s) from report. This can be 
        % 		convenient for removing id=0.

        excl_ctxgmwm
        % 		Exclude cortical gray and white matter. These are assumed to 
        % 		be IDs 2, 3, 41, and 42. The volume structures are more 
        % 		accurately measured using surface-based methods (see mris_
        % 		volume).

        surf_wm_vol
        % 		Compute cortical matter volume based on the volume encompassed
        % 		by the
        % 		white surface. This is more accurate than from the aseg. The 
        % 		aseg values for these are still reported in the table, but 
        % 		there will be the following lines in the table:
        % 		 # surface-based-volume mm3 lh-cerebral-white-matter 
        % 		266579.428518
        % 		 # surface-based-volume mm3 rh-cerebral-white-matter 
        % 		265945.120671

        surf_ctx_vol
        % 		compute cortical volumes from surf

        empty
        % 		Report on segmentations listed in the color table even if they
        % 		are not found in the segmentation volume.

        ctab_out % ctaboutput
        % 		Create an output color table (like FreeSurferColor.txt) with 
        % 		just the segmentations reported in the output.

        %% 	MASKING OPTIONS

        mask % maskvol
        % 		Exlude voxels that are not in the mask. Voxels to be excluded 
        % 		are assigned a segid of 0. The mask volume may be binary or 
        % 		continuous.The masking criteria is set by the mask threshold, 
        % 		sign, frame, and invert parameters (see below). The mask 
        % 		volume must be the same size and dimension as the segmentation
        % 		volume. If no voxels meet the masking criteria, then mri_
        % 		segstats exits with an error.

        maskthresh % thresh
        % 		Exlude voxels that are below thresh (for pos sign), above 
        % 		-thresh (for neg sign), or between -thresh and +thresh (for 
        % 		abs sign). Default is 0.5.

        masksign % sign
        % 		Specify sign for masking threshold. Choices are abs, pos, and 
        % 		neg. Default is abs.

        maskframe % frame
        % 		Derive the mask volume from the 0-based frameth frame.

        maskinvert
        % 		After applying all the masking criteria, invert the mask.

        maskerode % nerode
        % 		erode mask

        %% 	BRAIN VOLUME OPTIONS

        brain_vol_from_seg
        % 		Get volume of brain as the sum of the volumes of the 
        % 		segmentations that are in the brain. Based on CMA/
        % 		FreeSurferColorLUT.txt. The number of voxels and brain volume 
        % 		are stored as values in the header of the summary file with 
        % 		tags nbrainsegvoxels and brainsegvolume.

        brainmask % brainmask
        % 		Load brain mask and compute the volume of the brain as the 
        % 		non-zero voxels in this volume. The number of voxels and brain
        % 		volume are stored as values in the header of the summary file 
        % 		with tags nbrainmaskvoxels and brainmaskvolume.

        subcortgray
        % 		compute volume of subcortical gray matter

        totalgray
        % 		compute volume of total gray matter

        etiv
        % 		compute intracranial volume from subject/mri/transforms/
        % 		talairach.xfm

        etiv_only
        % 		compute intracranial volume from subject/mri/transforms/
        % 		talairach.xfm and exit

        old_etiv_only
        % 		compute intracranial volume from subject/mri/transforms/
        % 		talairach_with_skull.lta and exit

        talxfm % fname
        % 		specify path to talairach.xfm file for etiv

        euler
        % 		Write out number of defect holes in orig.nofix based on the 
        % 		euler number. This is the orig file prior to topology fixing. 

        %% 	AVERAGE WAVEFORM OPTIONS

        avgwf % textfile
        % 		
        % 		For each segmentation, computes the average waveform across 
        % 		all the voxels in the segmentation (excluding voxels masked 
        % 		out). The results are saved in an ascii text file with number 
        % 		of rows equal to the number of frames and number of columns 
        % 		equal to the number of segmentations reported. The order of 
        % 		segmentations is the same order as in the summary file.

        sumwf % textfile
        % 		Same as --avgwf but computes the sum instead of average

        avgwfvol % mrivol
        % 		Same as --avgwf except that the resulting waveforms are stored
        % 		in a binary mri volume format (eg, analyze, nifti, mgh, etc) 
        % 		with number of columns equal to the number segmentations, 
        % 		number of rows = slices = 1, and the number of frames equal 
        % 		that of the input volume. This may be more convenient than 
        % 		saving as an ascii text file. The order of segmentations is 
        % 		the same order as in the summary file.

        sfavg % textfile
        % 		save mean across space and frame

        vox % C R S
        % 		replace seg with all 0s except at CRS

        version
        % 		print out version and exit
    end 

    methods %% SET
        function this = set.id(this, val)
            if (ischar(val));
                this.id = val; return; end
            if (isnumeric(val))
                if (1 == length(val))
                    this.id = num2str(val); return; end
                this.id = [num2str(val(1)) this.multipleIds(val(2:end))];
            end
        end
        function str  = multipleIds(~, vals)
            flag = ' --id ';
            str  = '';
            for v = 1:length(vals)
                str = [str flag num2str(vals(v))]; %#ok<AGROW>
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

