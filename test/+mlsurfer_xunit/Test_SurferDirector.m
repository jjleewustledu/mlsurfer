classdef Test_SurferDirector < mlsurfer_xunit.Test_mlsurfer 
	%% TEST_SURFERDIRECTOR 
	%  Usage:  >> runtests tests_dir  
 	%          >> runtests mlsurfer.Test_SurferDirector % in . or the matlab path 
 	%          >> runtests mlsurfer.Test_SurferDirector:test_nameoffunc 
 	%          >> runtests(mlsurfer.Test_SurferDirector, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit	
    %  Version $Revision: 2614 $ was created $Date: 2013-09-07 19:16:03 -0500 (Sat, 07 Sep 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-07 19:16:03 -0500 (Sat, 07 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/test/+mlsurfer_xunit/trunk/Test_SurferDirector.m $ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id: Test_SurferDirector.m 2614 2013-09-08 00:16:03Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties (Constant)
        E_SEGSTATS = '';
    end
    
	methods
        function test_estimateRoi(this)
        end
        function test_estimateSegstats(this)
            assertEqual(this.E_SEGSTATS, this.sd_.estimateSegstats);
        end        
 		function test_reconAll(this)
            this.sd_.reconAll(this.sd_.builder);
            this.assertPopulated(this.sd_.subjectPath);  
            this.assertPopulated(this.sd_.mriPath);       
            this.assertPopulated(this.sd_.surfPath);
        end
        function test_ctor(this)
            assert(isa(this.sd_, 'mlsurfer.SurferDirector'));
        end
        
        function this = Test_SurferDirector(varargin)
 			this = this@mlsurfer_xunit.Test_mlsurfer(varargin{:}); 
            this.sd_ = mlsurfer.SurferDirector( ...
                       mlsurfer.VolumeRoiCorticalThicknessBuilder('sessionPath', this.sessionPath));
 		end 
    end 

    %% PRIVATE
    
    properties (Access = 'private')
        sd_
    end
    
    methods (Static, Access = 'private')
        function assertPopulated(pth)            
            dt = mlsystem.DirTool(pth);
            assert(~isempty(dt.dns));  
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

