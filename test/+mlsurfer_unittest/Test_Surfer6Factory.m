classdef Test_Surfer6Factory < matlab.unittest.TestCase
	%% TEST_SURFER6FACTORY 

	%  Usage:  >> results = run(mlsurfer_unittest.Test_Surfer6Factory)
 	%          >> result  = run(mlsurfer_unittest.Test_Surfer6Factory, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 27-Nov-2017 15:57:24 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/test/+mlsurfer_unittest.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
 		registry
        sessd
        sessp = '/data/nil-bluearc/raichle/PPGdata/jjlee2/HYGLY28'
 		testObj
        vol
 	end

	methods (Test)
		function test_reconAll(this)
 			import mlsurfer.*;
            this.testObj.makeReconAll;
 		end
	end

 	methods (TestClassSetup)
		function setupSurfer6Factory(this)
 			import mlsurfer.*;
            this.sessd = mlraichle.SessionData('studyData', mlraichle.StudyData, 'sessionPath', this.sessp);
 			this.testObj_ = Surfer6Factory('sessionData', this.sessd);
 		end
	end

 	methods (TestMethodSetup)
		function setupSurfer6FactoryTest(this)
 			this.testObj = this.testObj_;
            this.vol = mlsurfer.Surfer6Volume(this.testObj);
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

