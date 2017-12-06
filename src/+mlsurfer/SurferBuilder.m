classdef SurferBuilder < mlsurfer.ISurferFilesystem
	%% SURFERBUILDER specifies an abstract interface foir creating parts of a product object.
    %  SurferBuilder is the principle abstraction for a builder design pattern; it is the parent to 
    %  concrete builders implementing freesurfer functionality.  Clients should primarily access 
    %  SurferDirector objects after binding SurferBuilder objects; the SurferDirector objects
    %  guide construction of products with optimal use of construction algorithms.
    %  See also:  SurferDirector, mlpatterns.Builder,  GoF
    
    %  Version $Revision: 2538 $ was created $Date: 2013-08-18 18:06:43 -0500 (Sun, 18 Aug 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-08-18 18:06:43 -0500 (Sun, 18 Aug 2013) $ and checked into svn repository
    %  $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: SurferBuilder.m 2538 2013-08-18 23:06:43Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 
    
	properties (Abstract)
        dat
        mask
        product
        referenceImage
        segstats
        structural
    end
    
    methods (Abstract)
        obj = clone(this)
    end    
    
    methods 
        
        %% Empty, to be subclassed by concrete builders
        
        function this = buildCorticalThickness(this)
        end
        function this = bbregisterNative(this)
        end
        function this = ensureBetted(this)
        end
        function this = reconAll(this)
        end
        function this = surferRegisteredSegstats(this)
        end
        function stats = fsanatomicalStats(this)  %#ok<MANU>
            stats = [];
        end
    end
    
    %% PROTECTED
    
    methods (Access = 'protected')
        function this = SurferBuilder()            
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

