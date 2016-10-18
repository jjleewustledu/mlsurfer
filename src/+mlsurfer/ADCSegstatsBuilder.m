classdef ADCSegstatsBuilder < mlsurfer.SurferBuilderPrototype
	%% ADCSEGSTATSBUILDER   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

    properties (Constant)
        ADC_FILEPREFIX = 'adc_default';  
        DWI_FILEPREFIX = 'dwi_default'; 
    end
    
	properties (Dependent)
        adc
        dwi
    end 

    methods %% GET/SET
        function ic   = get.adc(this)
            if (~isempty(this.adc_))
                ic = this.adc_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.ADC_FILEPREFIX)));
        end
        function this = set.adc(this, obj)
            this.adc_ = mlfourd.ImagingContext(obj);
        end
        function ic   = get.dwi(this)
            if (~isempty(this.dwi_))
                ic = this.dwi_; return; end
            ic = mlfourd.ImagingContext.load(fullfile(this.fslPath, filename(this.DWI_FILEPREFIX)));
        end
        function this = set.dwi(this, obj)
            this.dwi_ = mlfourd.ImagingContext(obj);
        end
    end
    
    methods (Static)
        function sessions = fsanatomicalStatsForStudy(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            sessions = {};
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('PerfusionSegstatsBuilder.fsanatomicalStatsForStudy is working in %s\n', dt.fqdns{d});
                    asb = mlsurfer.ADCSegstatsBuilder('SessionPath', dt.fqdns{d});
                    asb.alignDiffusion;
                    asb.fsanatomicalStats;
                    sessions = [sessions dt.fqdns{d}]; %#ok<AGROW>
                catch ME
                    fprintf('%s\n', ME.message);
                end
            end            
        end
    end
    
	methods  		 
        function           alignDiffusion(this)
            mrad = mlmr.MRAlignmentDirector.factory( ...
                    'product', this.product, 'referenceImage', this.referenceImage);
            this.product = mrad.alignDiffusion(this.dwi, this.adc, this.t2);
        end
        function           fsanatomicalStats(this)
            this.alignDiffusion;
            disp(this.fsanatomicalStatsAdc)
            disp(this.fsanatomicalStatsDwi)
            cd(this.sessionPath);
        end
        function           fsanatomicalStatsPrealigned(this)
            disp(this.fsanatomicalStatsAdc)
            disp(this.fsanatomicalStatsDwi)
            cd(this.sessionPath);
        end
        function statfns = fsanatomicalStatsAdc(this)
            import mlpatterns.* mlsurfer.*;
            if (~lexist(SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX), 'file'))
                this = this.bbregisterNative; 
            end  
            statfns = CellArrayList;
            this.product = mlfourd.ImagingContext( ...
                fullfile(this.fslPath, [this.adc.fileprefix '_on_' filename(this.t1.fileprefix)]));
            this.dat = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            [~,lhstat,rhstat] = this.surferRegisteredSegstats(this.product, ...
                                ':colormap=heat:heatscale=0,2,6:heatscaleoptions=truncate:opacity=0.5');
            statfns.add(lhstat);
            statfns.add(rhstat);
        end 
        function statfns = fsanatomicalStatsDwi(this)
            import mlpatterns.* mlsurfer.*;
            if (~lexist(SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX), 'file'))
                this = this.bbregisterNative; 
            end  
            statfns = CellArrayList;
            this.product = mlfourd.ImagingContext( ...
                fullfile(this.fslPath, [this.dwi.fileprefix '_meanvol_on_' filename(this.t1.fileprefix)]));
            this.dat = SurferFilesystem.datFilename(this.fslPath, SurferFilesystem.T1_FILEPREFIX);
            [~,lhstat,rhstat] = this.surferRegisteredSegstats(this.product, ...
                                ':colormap=heat:heatscale=0,2,6:heatscaleoptions=truncate:opacity=0.5');
            statfns.add(lhstat);
            statfns.add(rhstat);
        end 
        
 		function this = ADCSegstatsBuilder(varargin) 
 			%% ADCSEGSTATSBUILDER ctor
 			%  Usage:  this = ADCSegstatsBuilder([...]) 
            %                                     ^ cf. SurferBuilderPrototype
            
            this = this@mlsurfer.SurferBuilderPrototype(varargin{:});
            import mlsurfer.*;
            this.product = this.adc;
            this.referenceImage = fullfile(this.fslPath, filename(SurferFilesystem.T1_FILEPREFIX));
 		end 
    end 

    %% PRIVATE
    
    properties (Access = 'private')
        adc_
        dwi_
    end
    
    methods (Access = 'private')
        function prd = extractADC(~,prd)
            assert(isa(prd, 'mlfourd.ImagingContext'));
            imcmp = prd.composite;
            prd   = imcmp.get(2);
            prd   = mlfourd.ImagingContext.load(prd);
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

