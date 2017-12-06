classdef Test_Parcellations < matlab.unittest.TestCase 
	%% TEST_PARCELLATIONS  

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Parcellations)
 	%          >> result  = run(mlsurfer_unittest.Test_Parcellations, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 

	properties 
 		testObj 
        colorLUTFilename = '/Volumes/SeagateBP4/cvl/np755/JJLColorLUTshort_20151002.txt'; % look on Passport drives
        sessionPath = '/Volumes/SeagateBP4/cvl/np755/mm01-020_p7377_2009feb5' 
        cerebLabelNames = { ...
            'Cerebellum-White-Matter' 'Cerebellum-Cortex'};
        ctxLabelNames = { ...
            'G_and_S_transv_frontopol' 'G_and_S_subcentral' 'G_cingul-Post-ventral' ...
            'G_and_S_frontomargin' 'G_front_inf-Orbital' 'G_and_S_occipital_inf'}; 
        %% from territories aca_min, mca_min, pca_min, aca, mca, pca
    end 
    
    properties (Dependent)
        fslPath
    end
    
    methods %% GET
        function p = get.fslPath(this)
            p = fullfile(this.sessionPath, 'fsl', '');
        end
    end

    methods 
        function ln = aCerebLabelName(this, hemi, idx)
            ln = [hemi '-' this.cerebLabelNames{idx}];
        end
        function ln = aCtxLabelName(this, hemi, idx)
            ln = ['ctx_' hemi this.ctxLabelNames{idx}];
        end
    end
    
	methods (Test)   
        
        %% SEGNAMEDSTATS METHODS
        
        function test_segnamedStatsMap_PET_volume(this)
            map = this.testObj.segnamedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'volume');
            this.assertEqual(map('ctx_lh_G_and_S_transv_frontopol').volume_mm3, 1784);
        end
        function test_segnamedStatsMap_PET_std(this)
            map = this.testObj.segnamedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'std');
            kys = map.keys;
            this.assertEqual(kys{1}, 'ctx_lh_G_and_S_cingul-Ant');
            this.assertEqual(map('ctx_lh_G_and_S_transv_frontopol').stddev, 0.3169);
        end
        function test_segnamedStatsMap_PET_mean(this)
            map = this.testObj.segnamedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca');
            kys = map.keys;
            this.assertEqual(kys{1}, 'ctx_lh_G_and_S_cingul-Ant');
            this.assertEqual(map('ctx_lh_G_and_S_transv_frontopol').mean, 3.4944);
        end
        function test_segnamedStatsMap(this)
            map = this.testObj.segnamedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'all');
            kys = map.keys;
            this.assertEqual(kys{1}, 'ctx_lh_G_Ins_lg_and_S_cent_ins');
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').segid,      11117);
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').volume_mm3, 902);
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').mean,       5.9257);
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').stddev,     0.2321);
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').min,        5.121);
            this.assertEqual(    map('ctx_lh_G_Ins_lg_and_S_cent_ins').max,        6.3632);
        end 
        
        %% SEGIDENTIFIEDSTATS METHODS
        
        function test_segidentifiedStatsMap_PET_volume(this)
            map = this.testObj.segidentifiedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'volume');
            this.assertEqual(map(11105), 1784);
        end
        function test_segidentifiedStatsMap_PET_std(this)
            map = this.testObj.segidentifiedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'std');
            kys = map.keys;
            this.assertEqual(kys{1},     11101);
            this.assertEqual(map(11105), 0.3169);        
        end
        function test_segidentifiedStatsMap_PET_mean(this)
            map = this.testObj.segidentifiedStatsMap( ...
                  'lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca');
            kys = map.keys;
            this.assertEqual(kys{1},     11101);
            this.assertEqual(map(11105), 3.4944);  
        end        
        function test_segidentifiedStatsMap_cvs(this)
            map = this.testObj.segidentifiedStatsMap('lh', 'cvs', 'aca');
            kys = map.keys;
            this.assertEqual(kys{1},     11101);
            this.assertEqual(map(11105), 2.539);
        end
        function test_segidentifiedStatsMap_thicknessstd(this)
            map = this.testObj.segidentifiedStatsMap('lh', 'thicknessstd', 'aca', 'std');
            kys = map.keys;
            this.assertEqual(kys{1},     11101);
            this.assertEqual(map(11105), 0.812);  
        end   
        function test_segidentifiedStatsMap_thickness(this)
            map = this.testObj.segidentifiedStatsMap('lh', 'thickness', 'aca');
            kys = map.keys;
            this.assertEqual(kys{1},     11101);
            this.assertEqual(map(11105), 2.619);
        end    
        
        %% UTILITY METHODS
        
 		function test_isInTerritory(this)
            this.assertTrue( this.testObj.isInTerritory('Left-Cerebellum-White-Matter', 'cereb'));
            this.assertTrue( this.testObj.isInTerritory('ctx_lh_G_and_S_subcentral',    'mca_min'));
            this.assertFalse(this.testObj.isInTerritory('ctx_lh_G_and_S_subcentral',    'cereb'));
            this.assertFalse(this.testObj.isInTerritory('Left-Cerebellum-White-Matter', 'mca_min'));
        end  
        function test_statsFilename(this)
            import mlpet.* mlsurfer.*;
            this.assertEqual( ...
                this.testObj.statsFilename('lh', PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX), ...
                fullfile(this.fslPath,    ['lh_' PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX '_on_' SurferFilesystem.T1_FILEPREFIX '_normByDose_on_fsanatomical.stats']));
        end
        function test_ctor(this)
            this.assertTrue(isa(this.testObj, 'mlsurfer.Parcellations'));
        end
 	end 

 	methods (TestClassSetup) 
 		function setupParcellations(this) 
            import mlsurfer.*;
            this.testObj = Parcellations( ...
                PETSegstatsBuilder('SessionPath', this.sessionPath));
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

