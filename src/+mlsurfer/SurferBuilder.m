classdef SurferBuilder < mlsurfer.ISurferFilesystem
	%% SURFERBUILDER is the salient interface for freesurfer workflows.
    %  SurferBuilder is an abstract builder.  It is the parent to concrete builders that have freesurfer functionality.
    %  It is called by director classes such as SurferDirector.  Clients should primarily access director classes
    %  for construction of freesurfer-related product objects.  SurferBuilder is also an abstract prototype which is 
    %  parent to concrete prototypes such as SurferBuilderPrototype.  All prototypes may be cloned, facilitating
    %  adding/removing products or specifying new objects with varying structures dynamically configuring classes
    %  at run-time.  
    %  See also:  SurferDirector, SurferBuilderPrototype, mlpatterns.Builder, GoF
    
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
    
    methods %% Empty, to be subclassed by concrete builders
        function this = buildUnpacked(this)
        end   
        function this = buildCorticalThickness(this)
        end
        function this = bbregisterNative(this)
        end
        function this = ensureBetted(this)
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

