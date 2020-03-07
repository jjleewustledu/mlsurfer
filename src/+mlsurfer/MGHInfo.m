classdef MGHInfo < mlfourd.AbstractNIfTIInfo
	%% MGHINFO  

	%  $Revision$
 	%  was created 24-Jul-2018 11:31:16 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.4.0.813654 (R2018a) for MACI64.  Copyright 2018 John Joowon Lee.
    
    properties (Constant) 
        FILETYPE      = 'MGZ'
        FILETYPE_EXT  = '.mgz'
        MGH_EXT       = '.mgz';
        SUPPORTED_EXT = {'.mgh' '.mgz' '.nii' '.nii.gz' '.ge' '.gelx' '.lx' '.ximg' '.IMA' '.dcm' '.afni' '.bshort' '.bfloat' '.sdt'} 
        % '.img' is SPM format to mri_convert
    end
    
	methods 		  
        function fqfn = fqfileprefix_mgz(this)
            fqfn = [this.fqfileprefix this.MGH_EXT];
        end
        
 		function this = MGHInfo(varargin)
 			%% MGHINFO calls mri_convert, then mlniftitools.load_untouch_header_only
 			%  @param filename is required.

 			this = this@mlfourd.AbstractNIfTIInfo(varargin{:});
            
            if (~lexist(this.fqfilename))
                return
            end
            
            import mlfourd.*;
            mlbash(sprintf('mri_convert %s %s', this.fqfilename, [this.fqfileprefix this.defaultFilesuffix])); 
            this.filesuffix = this.defaultFilesuffix; % hereafter, behave exactly as NIfTIInfo
            
            [this.hdr_,this.ext_,this.filetype_,this.machine_] = this.load_untouch_header_only;
            this.hdr_ = this.adjustHdr(this.hdr_);        
            this.raw_ = this.initialRaw;
            this.anaraw_ = this.initialAnaraw;           
 		end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

