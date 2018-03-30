classdef AbstractSurferProduct 
	%% ABSTRACTSURFERPRODUCT declares an interface for a type of product object.  
    %  Clients should use only interfaces declaried by AbstractSurferFactory and AbstractSurferProduct classes.

	%  $Revision$
 	%  was created 27-Nov-2017 16:12:14 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)
 		segmentation
        annotation
    end
    
    methods (Abstract)
        this = prepareProduct(this, varargin)
    end

	methods 
        
        function this = reconAll(this)
            this.factory_ = this.factory_.makeReconAll;
        end
		  
 		function this = AbstractSurferProduct(varargin)
            ip = inputParser;
            addRequired(ip, 'factory', @(x) isa(x, 'mlsurfer.AbstractSurferFactory'));
            parse(ip, varargin{:});

 			this.factory_ = ip.Results.factory;
 		end
    end 
    
    % PROTECTED
    
    properties (Access = protected)
        factory_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

