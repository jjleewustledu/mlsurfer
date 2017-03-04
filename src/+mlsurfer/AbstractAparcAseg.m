classdef AbstractAparcAseg 
	%% ABSTRACTAPARCASEG defers all public properties to subclasses for naming parcellations & segmentations.

	%  $Revision$
 	%  was created 02-Mar-2017 13:49:24 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	methods 
		  
 		function this = AbstractAparcAseg(varargin)
 			%% ABSTRACTAPARCASEG
 			%  @param aparcAseg is an mlfourd.ImagingContext containing parcellation & segmentation numbers.

            ip = inputParser;
            addRequired(ip, 'aparcAseg', @(x) isa(x, 'mlfourd.ImagingContext'));
            parse(ip, varargin{:});
            
            this.aparcAseg_ = ip.Results.aparcAseg;
        end
        
        function m = regionMask(this, varargin)
            % @param reg is a string or numeric.
            % @param exclude is an mlfourd.ImagingContext.
            
            ip = inputParser;
            addRequired(ip, 'reg', @(x) ischar(x) || isnumeric(x));
            addParameter(ip, 'exclude', [], @(x) isempty(x) || isa(x, 'mlfourd.ImagingContext'));
            addParameter(ip, 'fileprefix', '', @ischar);
            parse(ip, varargin{:});
            reg = ip.Results.reg;
            
            if (ischar(reg))
                m = this.setFileprefix( ...
                    this.excludeFromMask( ...
                    this.regionNamedMask(reg), ip.Results.exclude), ip.Results.fileprefix);
                return
            end
            if (isnumeric(reg))
                m = this.setFileprefix( ...
                    this.excludeFromMask( ...
                    this.regionNumberedMask(reg), ip.Results.exclude), ip.Results.fileprefix);
                return
            end
            error('mlsurfer:unsupportedParamTypeclass', 'class(AbstractAparcAseg.regionMask.reg)->%s', class(reg));
        end
        function n = regionNames(this)
            % @returns row cell of strings
            
            n = properties(this)'; 
        end
        function n = regionNumbers(this)
             % @returns row vector
             
            p = properties(this);
            n = cell2mat(cellfun(@(x) this.(x), p, 'UniformOutput', false))'; 
        end
    end 
    
    %% PROTECTED
    
    properties (Access = protected)
        aparcAseg_
    end
    
    methods (Access = protected)
        function m = regionNamedMask(this, nam)
            % Usage:   m = regionNamedMask('network7');
            %          m = regionNamedMask('thalamus');
            %          m = regionNamedMask('Left');
            % @param nam is a region name or part of a region name; case is ignored
            
            nams = this.regionNames;
            foundLogical = cellfun(@(x) ~isempty(x), strfind(lower(nams), lower(nam)));
            nums = this.regionNumbers;            
            m = this.regionNumberedMask(nums(foundLogical));
            m.fileprefix = [this.aparcAseg_.fileprefix '_' nam];
        end
        function m = regionNumberedMask(this, nums)
            % Usage:   m = regionNumberedMask([2 41]);
            % @param nums are region numbers
            
            aa = this.aparcAseg_.numericalNiftid;
            m  = aa.false;
            suff = '';
            for n = 1:length(nums)
                m = m | (aa == nums(n));
                suff = [suff '_' num2str(n)]; %#ok<AGROW>
            end
            m = m.binarized;
            m = mlfourd.ImagingContext(m);            
            m.fileprefix = [this.aparcAseg_.fileprefix suff];
        end
        function m = excludeFromMask(~, m, excl)
            if (isempty(excl))
                return
            end
            m = m.numericalNiftid;
            excl = excl.numericalNiftid;
            m = m & ~excl;
            m = m.binarized;
            m = mlfourd.ImagingContext(m);
            m.fileprefix = [this.aparcAseg_.fileprefix '_excl' upper(excl.fileprefix(1)) excl.fileprefix(2:end)];
        end
        function ic = setFileprefix(~, ic, fp)
            if (isempty(fp))
                return
            end
            ic.fileprefix = fp;
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

