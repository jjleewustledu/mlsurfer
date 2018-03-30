classdef Mri_surf2surfOptions < mlsurfer.SurferOptions 
	%% MRI_SURF2SURFOPTIONS   
    %  USAGE: mri_surf2surf 
    %  $Id: mri_surf2surf.c,v 1.90.2.1 2011/11/17 21:35:11 greve Exp $
    
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
        srcsubject            %   source subject
        sval                  %   path of file with input values 
        sval_xyz % surfname     : use xyz of surfname as input 
        projfrac % surfname 0.5 : use projected xyz of surfname as input 
        projabs  % surfname 0.5 : use projected xyz of surfname as input 
        sval_tal_xyz % surfname : use tal xyz of surfname as input 
        sval_area % surfname    : use vertex area of surfname as input 
        sval_annot % annotfile  : map annotation 
        sval_nxyz % surfname    : use surface normals of surfname as input 
        sfmt                  %   source format
        
        reg % register.dat <volgeom> : apply register.dat to sval-xyz
        reg_inv % register.dat <volgeom> : apply inv(register.dat) to sval-xyz
        
        srcicoorder        %   when srcsubject=ico and src is .w
        trgsubject         %   target subject
        trgicoorder        %   when trgsubject=ico
        tval               %   path of file in which to store output values
        tval_xyz           % : save as surface with source xyz 
        tfmt               %   target format
        trgdist % distfile   : save distance from source to target vtx
        s % subject          : use subject as src and target
        hemi    % hemisphere : (lh or rh) for both source and targ
        srchemi % hemisphere : (lh or rh) for source
        trghemi % hemisphere : (lh or rh) for target
        dual_hemi          % : assume source ?h.?h.surfreg file name
        surfreg            %   source and targ surface registration (sphere.reg)  
        srcsurfreg         %   source surface registration (sphere.reg)  
        trgsurfreg         %   target surface registration (sphere.reg)  
        mapmethod          %   nnfr or nnf
        frame              %   save only nth frame (with --trg_type paint)
        fwhm_src % fwhmsrc   : smooth the source to fwhmsrc
        fwhm_trg % fwhmtrg   : smooth the target to fwhmtrg
        nsmooth_in % N       : smooth the input
        nsmooth_out % N      : smooth the output
        cortex             % : use ?h.cortex.label as a smoothing mask
        no_cortex          % : do NOT use ?h.cortex.label as a smoothing mask (default)
        label_src % label    : source smoothing mask
        label_trg % label    : target smoothing mask
        reshape            %   reshape output to multiple 'slices'
        reshape_factor % Nfactor : reshape to Nfactor 'slices'
        split              % : output each frame separately
        synth              % : replace input with WGN
        ones               % : replace input with 1s
        normvar            % : rescale so that stddev=1 (good with --synth)
        seed % seed          : seed for synth (default is auto)
        reg_diff % reg2      : subtract reg2 from --reg (primarily for testing)
        rms % rms.dat        : save rms of reg1-reg2 (primarily for testing)
        rms_mask % mask      : only compute rms in mask (primarily for testing)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

