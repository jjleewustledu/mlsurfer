classdef AbstractSurferFactory 
	%% ABSTRACTSURFERFACTORY declares an interface for operations that create AbstractSurferProduct objects.
    %  Clients should use only interfaces declaried by AbstractSurferFactory and AbstractSurferProduct classes.
    %  Clients create*; factories make*.

	%  $Revision$
 	%  was created 27-Nov-2017 16:10:53 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		
 	end

	methods (Abstract)
        sp   = makeGroupAnalysis(this, varargin)
        this = makeReconAll(this, varargin)
        sp   = makeSegstats(this, varargin)
        sp   = makeSurfaceAnalysis(this, varargin)
        sp   = makeVolumeAnalysis(this, varargin)
     end
		
    methods
 		function this = AbstractSurferFactory(varargin)
 			%% ABSTRACTSURFERFACTORY
 			%  Usage:  this = AbstractSurferFactory()

 			this.setEnvironment;
 		end
    end 
    
    %% PROTECTED
    
    methods (Abstract, Access = protected)
        setEnvironment(this)
    end
    
    methods (Access = protected)        
        function this = prepareSurferOrig(this, origSrc)
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

