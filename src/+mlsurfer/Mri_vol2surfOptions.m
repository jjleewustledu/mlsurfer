classdef Mri_vol2surfOptions < mlsurfer.SurferOptions 
	%% MRI_VOL2SURFOPTIONS  
    %  $Id: mri_vol2surf.c,v 1.63 2011/03/05 01:11:14 jonp Exp $

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties  		 
        mov            %   input volume path (or --src)
        ref            %   preference volume name (default=orig.mgz
        reg            %   source registration  
        regheader      %   subject
        mni152reg      % : $FREESURFER_HOME/average/mni152.register.dat
        rot   % Ax Ay Az : rotation angles (deg) to apply to reg matrix
        trans % Tx Ty Tz : translation (mm) to apply to reg matrix
        float2int      %   float-to-int conversion method (<round>, tkregister )
        fixtkreg       % : make make registration matrix round-compatible
        fwhm      % fwhm : smooth input volume (mm)
        surf_fwhm % fwhm : smooth output surface (mm)

        trgsubject % target subject (if different than reg)
        hemi       % hemisphere (lh or rh) 
        surf       % target surface (white) 
        srcsubject % source subject (override that in reg)

    %% Options for use with --trgsubject
        surfreg    % surface registration (sphere.reg)  
        icoorder   % order of icosahedron when trgsubject=ico

    %% Options for projecting along the surface normal:
        projfrac     % frac            : (0->1)fractional projection along normal 
        projfrac_avg % min max del     : average along normal
        projfrac_max % min max del     : max along normal
        projdist     % mmdist          : distance projection along normal 
        projdist_avg % min max del     : average along normal
        projopt      % <fraction stem> : use optimal linear estimation and previously
                     %                   computed volume fractions (see mri_compute_volume_fractions)
        projdist_max % min max del     : max along normal
        mask % label                   : mask the output with the given label file (usually cortex)
        cortex                       % : use hemi.cortex.label from trgsubject

    %% Options for output
        o             %    output path
        out_type      %    output format
        frame % nth     :  save only 0-based nth frame 
        rf % R          : integer reshaping factor, save as R 'slices'
        srchit        %   volume to store the number of hits at each vox 
        srchit_type   %   source hit volume format 
        nvox % nvoxfile : write number of voxels intersecting surface

    %% Other Options
        reshape        % : so dims fit in nifti or analyze
        noreshape      % : do not save output as multiple 'slices'; do not reshape (default)
        scale % scale    : multiply all intensities by scale.
        v % vertex no    : debug mapping of vertex.
        srcsynth  % seed : synthesize source volume
        seedfile % fname : save synth seed to fname
        sd             %   SUBJECTS_DIR 
        version        %   print out version and exit
        interp         %   interpolation method (<nearest> or trilinear)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

