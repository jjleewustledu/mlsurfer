classdef Test_SurferBuilder < mlsurfer_xunit.Test_mlsurfer
	%% Test_SurferBuilder 
    %  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_SurferBuilder % in . or the matlab path 
 	%          >> runtests Test_SurferBuilder:test_nameoffunc 
 	%          >> runtests(Test_SurferBuilder, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit%  Version $Revision: 2301 $ was created $Date: 2012-12-09 19:54:52 -0600 (Sun, 09 Dec 2012) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2012-12-09 19:54:52 -0600 (Sun, 09 Dec 2012) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/test/+mlsurfer_xunit/trunk/Test_SurferBuilder.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Test_SurferBuilder.m 2301 2012-12-10 01:54:52Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		expectedPath = '/usr/bin:/bin:/usr/sbin:/sbin';
        surferBuilder
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 
        
 		function test_surferBash(this) 
 			%% TEST_SURFERBASH
 			%  Usage:   
 			import mlsurfer.*; 
            ifile = this.t1_fqfn;
            ofile = fullfile(this.fslPath, 'test_surferBash.mgz');
            this.surferBuilder.surferBash( ...
                 sprintf('mri_convert -it %s -ot %s %s %s', 'nii', 'mgz', ifile, ofile));
            assertTrue(lexist(ofile, 'file'));
        end 
        function test_env(this)
            assertEqual(this.expectedPath, getenv('PATH'));
        end
        
 		function this = Test_SurferBuilder(varargin) 
 			this = this@mlsurfer_xunit.Test_mlsurfer(varargin{:}); 
            this.surferBuilder = mlsurfer.SurferBuilder.createFromMrPath(this.mrPath);
            this.surferBuilder.sessionPath = this.subjectPath;
 		end % Test_SurferBuilder (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

