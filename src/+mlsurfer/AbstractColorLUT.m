classdef AbstractColorLUT < mlsurfer.ColorLUTInterface
	%% ABSTRACTCOLORLUT   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
    properties (Dependent)
        colorLUT % cell array of strings:   index label_name R G B A
    end
    
    methods %% GET
        function lut = get.colorLUT(this)
            assert(~isempty(this.colorLUT_));
            lut = this.colorLUT_;
        end
    end
    
	methods 
        function idx  = label2index(this, lbl)
            assert(~isempty(this.label2indexMap_));
            idx = this.label2indexMap_(lbl);
        end
        function lbl  = index2label(this, idx)
            assert(~isempty(this.index2labelMap_));
            lbl = this.index2labelMap_(idx);
        end
        function        disp(this)
            lut = this.colorLUT;
            for l = 1:length(lut)
                [idx,lbl,rgba] = this.parseLine(lut{l});
                fprintf('%i %s %s\n', idx, lbl, num2str(rgba));
            end            
        end
 		function this = AbstractColorLUT 
 			%% ABSTRACTCOLORLUT 
 			%  Usage:  this = AbstractColorLUT() 
            
 			this.lutFqFilename_ = ...
                fullfile(getenv('HOME'), 'MATLAB-Drive', 'mlsurfer', 'src', '+mlsurfer', 'aparc.a2009s.ColorLUT.txt');
            this.colorLUT_ = mlio.TextIO.textfileToCell(this.lutFqFilename_);
            this.colorLUT_ = this.cleanLUT(this.colorLUT_);
            [idxs,lbls]    = this.createKeys;
            this.index2labelMap_ = containers.Map(idxs, lbls);
            this.label2indexMap_ = containers.Map(lbls, idxs);
 		end 
 	end 

    %% PROTECTED
    
	properties (Access = 'protected')
        index2labelMap_
        label2indexMap_
        lutFqFilename_
        colorLUT_
    end 
    
    methods (Static, Access = 'protected')
        function cll = cleanLUT(cll0)
            cll = cell(size(cll0));
            c   = 0;
            for c0 = 1:length(cll0)
                if (~isempty(strtrim(cll0{c0})) && ~lstrfind(cll0{c0}, '#'))
                    c = c + 1;
                    cll{c} = cll0{c0};
                end
            end
            cll = cll(1:c);
        end
        function [idx,lbl,rgba] = parseLine(lutLine)
            rgxnames = regexp(lutLine, '(?<idx>\d+)\s+(?<lbl>\S+)\s+(?<r>\d+)\s+(?<g>\d+)\s+(?<b>\d+)\s+(?<a>\d+)', 'names');
            idx  = str2double(rgxnames.idx);
            lbl  = rgxnames.lbl;
            r    = rgxnames.r;
            g    = rgxnames.g;
            b    = rgxnames.b;
            a    = rgxnames.a;
            rgba = [str2double(r) str2double(g) str2double(b) str2double(a)]; 
        end
    end

    methods (Access = 'protected')
        function [idx,lbl] = createKeys(this)
            idx = cell(1, length(this.colorLUT));
            lbl = cell(1, length(this.colorLUT));
            for l = 1:length(this.colorLUT)
                [idx{l},lbl{l}] = this.parseLine(this.colorLUT{l});
            end
        end
    end
    
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

