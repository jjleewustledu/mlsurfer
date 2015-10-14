classdef Test_SurferData < matlab.unittest.TestCase
	%% TEST_SURFERDATA 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_SurferData)
 	%          >> result  = run(mlsurfer_unittest.Test_SurferData, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 07-Oct-2015 13:06:41
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	
    properties (Constant)
        CEREBELLAR_STATS_FILENAME = '/Volumes/SeagateBP4/cvl/np755/cerebellar_oefnq_statistics_2015oct12.mat'
        TERRITORY = 'all_aca_mca'
        N_PARC = 100
    end
    
	properties 
 		testObj 
        subjectsDir 
        sessionPth 
        session = 'mm01-020_p7377_2009feb5'
        hemisphere
        brain
        cohort
 	end 

	methods (Test) 
 		function test_thicknessOfOneBrain(this) 
 			import mlsurfer.*; 
            sdata = SurferData;            
            thickCortex = sdata.brain('Path', this.sessionPth, ...
                                      'Parameter', 'thickness', ...
                                      'Territory', this.TERRITORY);
            thickPca    = sdata.brain('Path', this.sessionPth, ...
                                      'Parameter', 'thickness', ...
                                      'Territory', 'pca');
            this.assertEqual(size(thickCortex), [this.N_PARC 1]);
            this.assertEqual(thickCortex(1),    2.292);
            this.assertEqual(thickPca(1),       2.241);
            
            thickRatio = thickCortex/mean(thickPca);
            this.assertEqual(thickRatio(1),    0.9123598487361506, 'RelTol', 1e-8);
            this.assertEqual(mean(thickRatio), 1.0948437603662173, 'RelTol', 1e-8);
            this.assertEqual(std(thickRatio),  0.1782223921317486, 'RelTol', 1e-8);
 		end 
 		function test_oefratioOfOneBrain(this) 
 			import mlsurfer.*; 
            sdata = SurferData;            
            oefCortex = sdata.brain('Path', this.sessionPth, ...
                                    'Parameter', 'oefnq_default_161616fwhh', ...
                                    'Territory', this.TERRITORY);
            oefCereb  = sdata.brain('Path', this.sessionPth, ...
                                    'Parameter', 'oefnq_default_161616fwhh', ...
                                    'Territory', 'cereb');
            oefPca    = sdata.brain('Path', this.sessionPth, ...
                                    'Parameter', 'oefnq_default_161616fwhh', ...
                                    'Territory', 'pca');
            this.assertEqual(size(oefCortex), [this.N_PARC 1]);
            this.assertEqual(oefCortex(1),    0.4209);
            this.assertEqual(oefCereb(1),     0.3761);
            this.assertEqual(oefPca(1),       0.5495);
            
            this.assertEqual(mean(oefCortex), 0.3970550000000001, 'RelTol', 1e-8);
            this.assertEqual(std( oefCortex), 0.0392374959172803, 'RelTol', 1e-8);            
            this.assertEqual(mean(oefCereb),  0.3850000000000000, 'RelTol', 1e-8);
            this.assertEqual(std( oefCereb),  0.0125865007051205, 'RelTol', 1e-8);
            this.assertEqual(mean(oefPca),    0.4167250000000000, 'RelTol', 1e-8);
            this.assertEqual(std( oefPca),    0.0554873526521839, 'RelTol', 1e-8);
            
            oefratio = oefCortex/mean(oefCereb);
            this.assertEqual(oefratio(1),    1.0932467532467531, 'RelTol', 1e-8);
            this.assertEqual(mean(oefratio), 1.0313116883116884, 'RelTol', 1e-8);
            this.assertEqual(std(oefratio),  0.1019155738111176, 'RelTol', 1e-8);
            
            oefratio = oefCortex/mean(oefPca);
            this.assertEqual(oefratio(1),    1.0100185973963645, 'RelTol', 1e-8);
            this.assertEqual(mean(oefratio), 0.9527986081948521, 'RelTol', 1e-8);
            this.assertEqual(std(oefratio),  0.0941568082483179, 'RelTol', 1e-8);
        end 
        function test_thicknessAll(this)
 			import mlsurfer.*; 
            sdata = SurferData;            
            thick = sdata.cohort('Path', this.subjectsDir, ...
                                 'Parameter', 'thickness', ...
                                 'Territory', this.TERRITORY);
            this.assertEqual(size(thick),     [1           30]);
            this.assertEqual(size(thick{10}), [this.N_PARC 1]);
            this.assertEqual(thick{10}(1),    2.292);
            save('Test_SurferData.test_thicknessAll.mat');
        end
        function test_thicknessIndexAll(this)
 			import mlsurfer.*; 
            sdata = SurferData;            
            thickIdx = sdata.cohortIndex('Path', this.subjectsDir, ...
                                         'Parameter', 'thickness', ...
                                         'Territory', this.TERRITORY);
            this.assertEqual(size(thickIdx),     [1           30]);
            this.assertEqual(size(thickIdx{10}), [this.N_PARC 1]);
            this.assertEqual(thickIdx{10}(1),    -0.058004767515138, 'RelTol', 1e-8);
            save('Test_SurferData.test_thicknessIndexAll.mat');
        end
        function test_oefratioAll(this)
 			import mlsurfer.*; 
            sdata = SurferData;            
            [oefCortex,idsCortex,sessCortex] = sdata.cohort('Path', this.subjectsDir, ...
                                               'Parameter', 'oefnq_default_161616fwhh', ...
                                               'Territory', this.TERRITORY);
            [oefCereb,idsCereb,sessCereb] = sdata.cohortCerebOefnq('Path', this.subjectsDir);
            this.assertEqual(size(oefCortex{10}), [this.N_PARC 1]);
            this.assertEqual(oefCortex{10}(1),    0.4252);
            this.assertEqual(oefCereb{10},        0.425338775365096, 'RelTol', 1e-8);
            
            oefCortexVec = reshape(cell2mat(oefCortex), [30*this.N_PARC 1]);
            oefCerebVec  = reshape(cell2mat(oefCereb),  [30             1]);
            this.assertEqual(mean(oefCortexVec), 0.394494766666667, 'RelTol', 1e-8);
            this.assertEqual(std( oefCortexVec), 0.035856680127727, 'RelTol', 1e-8);            
            this.assertEqual(mean(oefCerebVec),  0.400997392892845, 'RelTol', 1e-8);
            this.assertEqual(std( oefCerebVec),  0.033470109983070, 'RelTol', 1e-8);
            
            for b = 1:30
                oefratio{b} = oefCortex{b}/oefCereb{b};
            end
            this.assertEqual(oefratio{10}(1),    0.9996737298051963, 'RelTol', 1e-8);
            this.assertEqual(mean(oefratio{10}), 0.9355342683216226, 'RelTol', 1e-8);
            this.assertEqual(std(oefratio{10}),  0.0937228859870616, 'RelTol', 1e-8);            
            save('Test_SurferData.test_oefratioAll.mat');
        end
 	end 

 	methods (TestClassSetup) 
 		function setupSurferData(this) 
            import mlsurfer.*;
 			this.testObj = SurferData; 
            this.subjectsDir = SurferRegistry.instance.subjectsDir;
            this.sessionPth  = fullfile(  this.subjectsDir, this.session, '');
            %this.hemisphere  = Hemisphere(this.sessionPth, 'lh', 'thickness');
            %this.brain       = Brain(     this.sessionPth,       'thickness');
            %this.cohort      = Cohort(    this.sessionPth,       'thickness');
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

