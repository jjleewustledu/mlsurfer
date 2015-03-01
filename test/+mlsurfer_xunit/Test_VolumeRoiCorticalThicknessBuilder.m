classdef Test_VolumeRoiCorticalThicknessBuilder < mlsurfer_xunit.Test_mlsurfer 
	%% TEST_VOLUMEROICORTICALTHICKNESSBUILDER  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlsurfer.Test_VolumeRoiCorticalThicknessBuilder % in . or the matlab path 
	%          >> runtests mlsurfer.Test_VolumeRoiCorticalThicknessBuilder:test_nameoffunc 
	%          >> runtests(mlsurfer.Test_VolumeRoiCorticalThicknessBuilder, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

    properties (Constant)
        SHOW_VIEWS_ON_NATIVE_ANATOMY = true;
        
        %                         1         2         3         4         5         6         7         8         9
        %                123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
        SEGSTATS_TEXT = '1   1    116460   116460.0  Seg0001     2.4713     0.9693     0.0000     5.0000     5.0000';
        AVERAGED_TEXT = '1   1    116460   116460.0  Seg0001     2.4713     0.9693     0.0000     5.0000     5.0000';
    end
    
    properties (Dependent)
        brain
        brainOnRawavg
        aseg
        asegOnRawavg
        rawavg
    end
    
    methods %% SET/GET
        function f = get.brain(this)
            f = fullfile(this.mriPath, 'brain.mgz');
        end
        function f = get.brainOnRawavg(this)
            f = fullfile(this.mriPath, 'brain_on_rawavg.mgz');
        end
        function f = get.aseg(this)
            f = fullfile(this.mriPath, 'aparc.a2009s+aseg.mgz');
        end
        function f = get.asegOnRawavg(this)
            f = fullfile(this.fslPath, 'aparc_a2009s+aseg_on_rawavg.nii.gz');
        end
        function f = get.rawavg(this)
            f = fullfile(this.mriPath, 'rawavg.mgz');
        end
    end
    
	methods 
        function test_buildPET(this)            
            cd(this.fslPath);
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder( ...
                   'sessionPath', this.sessionPath);
            vrctb.buildPET;
            import mlpet.*;
            assert(lexist('t1_default_to_fsanatomical.dat', 'file'));
            assert(lexist(['lh_' O15Builder.HO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'], 'file'));
            assert(lexist(['rh_' O15Builder.HO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats'], 'file'));
        end
        function test_buildThickness(this)
            cd(this.fslPath);
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder( ...
                   'sessionPath', this.sessionPath);
            vrctb.buildThickness;
            assert(lexist('lh_aparc_a2009s_thickness.table', 'file'));
            assert(lexist('rh_aparc_a2009s_thickness.table', 'file'));
        end
        function test_buildADC(this)
            cd(this.fslPath);
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder( ...
                   'sessionPath', this.sessionPath);
            vrctb.buildADC;
            assert(lexist('dwi_default_meanvol_to_fsanatomical.dat', 'file'));
            assert(lexist('lh_adc_default_fsanatomical.stats', 'file'));
            assert(lexist('rh_adc_default_fsanatomical.stats', 'file'));
        end
        function test_buildOnNativeAnatomy(this)
            import mlsurfer.*;
            vrctb = VolumeRoiCorticalThicknessBuilder( ...
                'sessionPath',    this.sessionPath);
            vrctb.buildImageOnNativeAnatomy(       this.brain);
            vrctb.buildSegmentationOnNativeAnatomy(this.aseg);
            assertTrue(lexist(this.brainOnRawavg, 'file'));
            
            if (this.SHOW_VIEWS_ON_NATIVE_ANATOMY)
                vrctb.buildViewsOnNativeAnatomy(this.rawavg, this.aseg); end
        end
        
        function test_buildSegstats(this)
            import mlfourd.*;
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder( ...
                'sessionPath', this.sessionPath, ...
                'product',     this.bt1Cntxt, ...
                'roi',         this.t1MaskCntxt, ...
                'structural',  this.t1Cntxt, ...
                'mask',        this.t1MaskCntxt);  
            txt = vrctb.buildSegstats('lh'); 
            assertEqual(this.SEGSTATS_TEXT, txt(end-91:end-2));
        end
        function test_buildAveragedSegstats(this)
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder( ...
                'sessionPath', this.sessionPath, ...
                'product',     this.t1Cntxt, ...
                'roi',         this.t1MaskCntxt, ...
                'structural',  this.t1Cntxt, ...
                'mask',        this.t1MaskCntxt);  
            txt = vrctb.buildAveragedSegstats('lh');  
            assertEqual(this.AVERAGED_TEXT, txt(end-91:end-2));
        end
        
 		function this = Test_VolumeRoiCorticalThicknessBuilder(varargin) 
 			this = this@mlsurfer_xunit.Test_mlsurfer(varargin{:});
        end 
        function setUp(this)
            if (lexist(this.brainOnRawavg))
                delete(this.brainOnRawavg); end
            if (lexist(this.asegOnRawavg))
                delete(this.asegOnRawavg); end
            cd(this.sessionPath);
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

