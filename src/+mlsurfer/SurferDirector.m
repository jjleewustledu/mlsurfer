classdef SurferDirector < mlsurfer.SurferDirectorComponent
	%% SURFERDIRECTOR constructs an object using the SurferBuilder interface.  
    %  It participates in a builder design pattern for Freesurfer.
    
	%  $Revision: 2613 $ 
    %  $Date: 2013-09-07 19:15:52 -0500 (Sat, 07 Sep 2013) $
    %  $Author: jjlee $,  
 	%  $LastChangedDate: 2013-09-07 19:15:52 -0500 (Sat, 07 Sep 2013) $ 
    %  $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferDirector.m $ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id: SurferDirector.m 2613 2013-09-08 00:15:52Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties (Dependent)
        builder
        product
        referenceImage
        dat
    end
    
	methods (Static) 
        
        %% LEGACY
        
        function this = createFromMrPath(pth)
            import mlsurfer.*;
            this = SurferDirector.createFromBuilder( ...
                   SurferBuilder.createFromMrPath(pth));
        end
        function this = createFromBuilder(bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            this = mlsurfer.SurferDirector('SurferBuilder', bldr);
        end        
        function this = createBasicReconstruction(modalPth, indices, dcmdir)
            %% CREATEBASICRECONSTRUCTION follows
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/BasicReconstruction
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/FsFastUnpackData
            %  Usage:  this = SurferDirector.createBasicReconstruction(fully_qualified_modal_path, indices_for_3danatomy)
            
            import mlsurfer.*;
            assert(lexist(modalPth, 'dir'));
            assert(~isempty(indices));
            assert(lexist(dcmdir, 'dir'));
            
            this = SurferDirector( ...
                       SurferBuilder( ...
                           SurferDicomConverter.createFromModalityPath(modalPth)));
            this.builder.indices3DAnat = indices;
            this.builder.unpack3DAnatMgz(dcmdir);
        end      
        function        fixUnpacks(studyPth)
            import mlsystem.* mlsurfer.*;
            sessDt = DirTool(fullfile(studyPth, 'mm0*', ''));
            for s = 1:length(sessDt.fqdns)
                mrPth = SurferDirector.mrPathIn(sessDt.fqdns{s});
                anatDt = DirTool(fullfile(mrPth, 'unpack', '3danat', '*'));
                indices = str2double(anatDt.dns);
                %fprintf('%s, %s\n', mrPth, num2str(indices));
                mlbash(sprintf('mv %s %s', fullfile(mrPth, 'unpack', '3danat', ''), fullfile(mrPth, 'unpack', '3danatBak', '')));
                try
                    SurferDirector.createBasicReconstruction(mrPth, indices);
                catch ME
                    handwarning(ME);
                end
            end
        end
        function pth  = mrPathIn(sessionPth)
            fldrs = mlfourd.AbstractDicomConverter.modalityFolders;
            for f = 1:length(fldrs)
                pth = fullfile(sessionPth, fldrs{f}, '');
                if (lexist(pth)); return; end
            end
        end
    end 
    
    methods 
        
        %% SET/GET
        
        function this = set.builder(this, bldr)
            assert(isa(bldr, 'mlsurfer.SurferBuilder'));
            this.builder_ = bldr;
        end
        function bldr = get.builder(this)
            bldr = this.builder_;
        end
        function this = set.product(this, img)
            this.builder_.product = img;
        end
        function img  = get.product(this)
            img = this.builder_.product;
        end
        function this = set.referenceImage(this, img)
            this.builder_.referenceImage = img;
        end
        function img  = get.referenceImage(this)
            img = this.builder_.referenceImage;
        end
        function this = set.dat(this, d)
            this.builder_.dat = d;
        end
        function d    = get.dat(this)
            d = this.builder_.dat;
        end
        
        %%
        
        function      this  = reconAll(this, varargin)
            %% RECONALL 
            %  See also:
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/BasicReconstruction
            %  http://surfer.nmr.mgh.harvard.edu/fswiki/FsFastUnpackData
            %  Usage:  SurferDirector.reconAll(fully_qualified_modality_path)           
            
            this.builder_ = this.builder_.reconAll(varargin{:});
        end 
        function [prd,this] = estimateRoi(this)
        end
        function [prd,this] = estimateSegstats(this)
            this.builder = this.builder.estimateSegstats(varargin{:});
            prd = this.builder.product;
        end

        function this = SurferDirector(varargin)
 			%% SURFERDIRECTOR 
            %  Usage:   obj = SurferDirector('SurferBuilder', a_surfer_builder)

            ip = inputParser;
            ip.KeepUnmatched = true;
            addOptional(ip, 'bldr', mlfsurfer.SurferBuilderPrototype, @(x) isa(x, 'mlsurfer.SurferBuilder'));
            parse(ip, varargin{:});
            this.builder_ = ip.Results.bldr;
        end
    end
    
    properties (Access = 'private')
        builder_
    end   

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

