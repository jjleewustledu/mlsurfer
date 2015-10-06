classdef SurferBuilder 
	%% SURFERBUILDER is the interface for freesurfer workflows.
    %  Classes are organized by the builder design patterns.   
    %  SurferBuilder is an abstract Prototype; its subclasses folloow the prototpye design pattern.
    %  See also:  mlpatterns.Builder, mlfsl.SurferDirector
    
    %  Version $Revision: 2538 $ was created $Date: 2013-08-18 18:06:43 -0500 (Sun, 18 Aug 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-08-18 18:06:43 -0500 (Sun, 18 Aug 2013) $ and checked into svn repository
    %  $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: SurferBuilder.m 2538 2013-08-18 23:06:43Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 
    
	properties (Abstract)
        dat
        fslPath
        mask
        mriPath
        product
        referenceImage
        segstats
        sessionId
        sessionPath
        structural
        studyPath
        surfPath
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

