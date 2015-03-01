classdef SurferDirectorDecorator < mlsurfer.SurferDirectorComponent
	%% SURFERDIRECTORDECORATOR   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties (Dependent)
        surferBuilder
        product
        referenceImage
        dat
    end 

    methods %% SET/GET
        function this = set.surferBuilder(this, bldr)
            this.component_.surferBuilder = bldr;
        end
        function bldr = get.surferBuilder(this)
            bldr = this.component_.surferBuilder;
        end
        function this = set.product(this, bldr)
            this.component_.product = bldr;
        end
        function bldr = get.product(this)
            bldr = this.component_.product;
        end
        function this = set.referenceImage(this, bldr)
            this.component_.referenceImage = bldr;
        end
        function bldr = get.referenceImage(this)
            bldr = this.component_.referenceImage;
        end
        function this = set.dat(this, bldr)
            this.component_.dat = bldr;
        end
        function bldr = get.dat(this)
            bldr = this.component_.dat;
        end
    end
    
	methods
        function prd  = reconAll(this, varargin)
            %% RECONALL follows
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/BasicReconstruction
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/FsFastUnpackData
            %  Usage:  SurferDirector.reconAll(fully_qualified_modality_path)           
            
            prd = this.component_.reconAll(varargin{:});
        end 
        function prd  = estimateRoi(this)
            prd = this.component_.estimateRoi;
        end
        function prd  = estimateSegstats(this)
            prd = this.component_.estimateSegstats;
        end	
        
 		function this = SurferDirectorDecorator(varargin)
            p = inputParser;
            addOptional(p, 'cmp', mlsurfer.SurferDirector, @(x) isa(x, 'mlsurfer.SurferDirectorComponent'));
            parse(p, varargin{:});
            this.component_ = p.Results.cmp; 
 		end 
    end 
    
    properties (Access = 'protected')
        component_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

