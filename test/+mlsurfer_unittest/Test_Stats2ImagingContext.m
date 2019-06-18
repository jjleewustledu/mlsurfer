classdef Test_Stats2ImagingContext < matlab.unittest.TestCase
	%% TEST_STATS2IMAGINGCONTEXT 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Stats2ImagingContext)
 	%          >> result  = run(mlsurfer_unittest.Test_Stats2ImagingContext, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 22-Oct-2017 19:03:59 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		registry
        subjectsDir = '/Volumes/SeagateBP4/cvl/np755'
        sessionPath = '/Volumes/SeagateBP4/cvl/np755/mm03-001_p7229_2008apr28' 
        % excluded:
        % mm01-009_p7660_2010jun22 mm01-021_p7413_2009apr24 mm01-022_p7653_2010jun15 mm01-028_p7542_2009dec17 
        % mm01-030_p7604_2010apr2 mm01-037_p7671_2010jul19 mm01-038_p7684_2010aug18 mm01-043_p7740_2010nov22
        % demonstrate with:  28, 43
        % demonstrate inclusions by rand selection:
        % mm01-006_p7260_2008jun9 mm01-034_p7630_2010may5 mm02-001_p7146_2008jan4 mm03-001_p7229_2008apr28
        T1
        territory = 'all'
 		testObj
        sessions = { ...
            'mm01-001_p7663_2010jun23' ...
            'mm01-005_p7270_2008jun18' ...
            'mm01-006_p7260_2008jun9'  ...
            'mm01-007_p7686_2010aug20' ...
            'mm01-011_p7795_2011mar8'  ...
            'mm01-012_p7414_2009apr27' ...
            'mm01-018_p7507_2009oct21' ...
            'mm01-019_p7510_2009oct26' ...
            'mm01-020_p7377_2009feb5'  ...
            'mm01-025_p7470_2009aug10' ...
            'mm01-031_p7610_2010apr7'  ...
            'mm01-032_p7624_2010apr28' ...
            'mm01-033_p7629_2010may5'  ...
            'mm01-034_p7630_2010may5'  ...
            'mm01-039_p7716_2010oct21' ...
            'mm01-041_p7719_2010oct21' ...
            'mm01-044_p7773_2011jan28' ...
            'mm01-046_p7819_2011apr19' ...
            'mm01-048_p7880_2011aug10' ...
            'mm02-001_p7146_2008jan4'  ...
            'mm03-001_p7229_2008apr28' ...
            'mm06-005_p7766_2011jan14' }
 	end

	methods (Test)
        function test_thicknessViz(this)
        end
        function test_oefRatioImagingContextRand(this)
            s = floor(length(this.sessions)*rand) + 1;
            this.testObj = mlsurfer.Stats2ImagingContext( ...
                'sessionPath', fullfile(this.subjectsDir, this.sessions{s}, ''), ...
                'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                'territory', this.territory);
            oefStruct = this.testObj.oefIndex;
            oef = oefStruct.imagingContext;
            this.verifyEqual(oef.filename, 'oefIndex_737353fwhh_on_T1.nii.gz');
            oef.view(fullfile(this.subjectsDir, this.sessions{s}, 'mri', 'orig.mgz'));
            oef.save;
        end
        function test_oefRatioImagingContext(this)
            oefStruct = this.testObj.oefIndex;
            oef = oefStruct.imagingContext;
            this.verifyClass(oef, 'mlfourd.ImagingContext');
            this.verifyEqual(oef.fqfilename, fullfile(this.sessionPath, 'fsl', 'oefIndex_737353fwhh_on_T1.nii.gz'));
            %oef = oef.blurred(mlsiemens.ECATRegistry.instance.petPointSpread);
            oef.view(this.T1);
            oef.save;
        end
		function test_ooImagingContext(this)
            pic = this.testObj.paramImagingContext('oo_sumt_737353fwhh');
            this.verifyClass(pic, 'mlfourd.ImagingContext');
            pic.view(this.T1);
        end
		function test_hoImagingContext(this)
            pic = this.testObj.paramImagingContext('ho_sumt_737353fwhh');
            this.verifyClass(pic, 'mlfourd.ImagingContext');
            pic.view(this.T1);
        end
		function test_oohoCerebDouble(this)
            this.verifyEqual(this.testObj.oohoCerebDouble, 0.47998745489851, 'relTol', 1e-12);
        end
	end

 	methods (TestClassSetup)
		function setupStats2ImagingContext(this)
 			import mlsurfer.*;
            setenv('SUBJECTS_DIR', fileparts(this.sessionPath));
 			this.testObj_ = Stats2ImagingContext( ...
                'sessionPath', this.sessionPath, ...
                'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                'territory', this.territory);
            this.T1 = mlfourd.ImagingContext(fullfile(this.sessionPath, 'mri', 'orig.mgz'));
 		end
	end

 	methods (TestMethodSetup)
		function setupStats2ImagingContextTest(this)
 			this.testObj = this.testObj_;
 			this.addTeardown(@this.cleanFiles);
 		end
	end

	properties (Access = private)
 		testObj_
 	end

	methods (Access = private)
		function cleanFiles(this)
 		end
	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

