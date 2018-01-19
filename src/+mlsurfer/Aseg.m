classdef Aseg < mlsurfer.AparcAsegNaming & mlrois.IRois
	%% ASEG 
    %  All public properties are region names. 

	%  $Revision$
 	%  was created 02_Mar_2017 13:50:25 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
        
        % $Id: ASegStatsLUT.txt,v 1.4 2014/10/01 21:11:38 greve Exp $
        
        Left_Cerebral_White_Matter           =   2
        Left_Cerebral_Cortex                 =   3
        Left_Cerebellum_White_Matter         =   7
        Left_Cerebellum_Cortex               =   8
        Left_Thalamus_Proper                 =  10
        Left_Caudate                         =  11
        Left_Putamen                         =  12
        Left_Pallidum                        =  13
        Brain_Stem                           =  16
        Left_Hippocampus                     =  17
        Left_Amygdala                        =  18
        Left_Accumbens_area                  =  26
        Left_VentralDC                       =  28
        Right_Cerebral_White_Matter          =  41
        Right_Cerebral_Cortex                =  42
        Right_Cerebellum_White_Matter        =  46
        Right_Cerebellum_Cortex              =  47
        Right_Thalamus_Proper                =  49
        Right_Caudate                        =  50
        Right_Putamen                        =  51
        Right_Pallidum                       =  52
        Right_Hippocampus                    =  53
        Right_Amygdala                       =  54
        Right_Accumbens_area                 =  58
        Right_VentralDC                      =  60
        Optic_Chiasm                         =  85
        CC_Posterior                         = 251
        CC_Mid_Posterior                     = 252
        CC_Central                           = 253
        CC_Mid_Anterior                      = 254
        CC_Anterior                          = 255
 	end

	methods 
		  
 		function this = Aseg(varargin)
 			%% ASEG
 			%  Usage:  this = Aseg()

 			this = this@mlsurfer.AparcAsegNaming(varargin{:});
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez_Morphy
 end

