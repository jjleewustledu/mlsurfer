classdef Surfer6Factory < mlsurfer.AbstractSurferFactory
	%% SURFER6FACTORY  

	%  $Revision$
 	%  was created 27-Nov-2017 15:57:24 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		
 	end

	methods 
        
        function prd  = makeGroupAnalysis(this, varargin)
            prd = [];
        end
        function this = makeReconAll(this, varargin)
            this = this.prepareSurfer6Filesystem;
        end
        function prd  = makeSegstats(this, varargin)
            prd = [];
        end
        function prd  = makeSurfaceAnalysis(this, varargin)
            prd = [];
        end
        function prd  = makeVolumeAnalysis(this, varargin)
            prd = [];
        end
		  
 		function this = Surfer6Factory(varargin)
 			%% SURFER6FACTORY
 			%  Usage:  this = Surfer6Factory()

 			this = this@mlsurfer.AbstractSurferFactory(varargin{:});
 		end
    end 
    
    %% PROTECTED
    
    methods (Access = protected)
        function setEnvironment(~)
            mlsurfer.SurferRegistry.setEnvironment6;
        end
    end
    
    %% PRIVATE
    
    methods (Access = private)
        function this = prepareSurfer6Filesystem(this, varargin)
            if (this.lexistSurfer5)
                this = this.prepareSurfer6FilesystemFrom5(varargin{:});
                return
            end
            if (this.lexistT1_4dfp)
                this = this.prepareSurferFilesystemFromT1_4dfp(varargin{:});
                return
            end
            if (this.lexistT1Dicom)
                this = this.prepareSurferFilesystemFromT1_dcm(varargin{:});
                return
            end
            error('mlsurfer:unsupportedFilesystemState', ...
                'Surfer6Factory.prepareSurfer6Filesystem');
        end
        function this = prepareSurfer6FilesystemFrom5(this, varargin)
            s5f = mlsurfer.Surfer5Factory(varargin{:});
            this = this.prepareSurferOrig(s5f.orig);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

