classdef Test_FastSurfer < matlab.unittest.TestCase
    %% line1
    %  line2
    %  
    %  Created 02-Nov-2022 01:40:11 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/test/+mlsurfer_unittest.
    %  Developed on Matlab 9.13.0.2080170 (R2022b) Update 1 for MACI64.  Copyright 2022 John J. Lee.
    
    properties
        testObj
    end
    
    methods (Test)
        function test_afun(this)
            import mlsurfer.*
            this.assumeEqual(1,1);
            this.verifyEqual(1,1);
            this.assertEqual(1,1);
        end
    end
    
    methods (TestClassSetup)
        function setupFastSurfer(this)
            import mlsurfer.*
            this.testObj_ = FastSurfer();
        end
    end
    
    methods (TestMethodSetup)
        function setupFastSurferTest(this)
            this.testObj = this.testObj_;
            this.addTeardown(@this.cleanTestMethod)
        end
    end
    
    properties (Access = private)
        testObj_
    end
    
    methods (Access = private)
        function cleanTestMethod(this)
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
