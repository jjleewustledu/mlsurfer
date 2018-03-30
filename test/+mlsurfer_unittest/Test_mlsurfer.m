classdef Test_mlsurfer < MyTestCase
	%% TEST_MLSURFER provides testing objects for convenience and modularity
    
 	%  See also:  package xunit%  Version $Revision: 2472 $ was created $Date: 2013-08-10 21:38:29 -0500 (Sat, 10 Aug 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-08-10 21:38:29 -0500 (Sat, 10 Aug 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/test/+mlsurfer_xunit/trunk/Test_mlsurfer.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Test_mlsurfer.m 2472 2013-08-11 02:38:29Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 
    
	properties (Dependent)
        maskCntxt
        mriPath
        subjectName
        subjectPath
        subjectsPath
        surfPath
    end
    
	methods %% GET
        function msk = get.maskCntxt(this)
            msk = mlfourd.ImagingContext.load( ...
                  fullfile(this.fslPath, 'bt1_default_mask.nii.gz'));
        end
        function pth = get.mriPath(this)
            pth = fullfile(this.subjectPath, 'mri', '');
            assert(lexist(pth, 'dir'));
        end
        function nam = get.subjectName(this) 
            [~,nam] = trimpath(this.subjectPath);
        end  
        function pth = get.subjectPath(this)
            pth = this.sessionPath;
        end 
        function pth = get.subjectsPath(this)
            pth = this.studyPath;
        end 
        function pth = get.surfPath(this)
            pth = fullfile(this.subjectPath, 'surf', '');
            assert(lexist(pth, 'dir'));
        end 
    end
    
    methods
        function fqfn = mriFullfilename(this, fn)
            fqfn = fullfile(this.mriPath, fn);
        end
        function fqfn = surfFullfilename(this, fn)
            fqfn = fullfile(this.surfPath, fn);
        end
    end
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

