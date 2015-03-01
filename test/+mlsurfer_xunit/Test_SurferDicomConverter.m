classdef Test_SurferDicomConverter < mlsurfer_xunit.Test_mlsurfer
	%% TEST_SURFERDICOMCONVERTER 
	%  Usage:  >> runtests tests_dir  
 	%          >> runtests Test_SurferDicomConverter % in . or the matlab path 
 	%          >> runtests Test_SurferDicomConverter:test_nameoffunc 
 	%          >> runtests(Test_SurferDicomConverter, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit	%  Version $Revision: 2648 $ was created $Date: 2013-09-21 17:59:17 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-21 17:59:17 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/test/+mlsurfer_xunit/trunk/Test_SurferDicomConverter.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: Test_SurferDicomConverter.m 2648 2013-09-21 22:59:17Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties (Constant)
        dirs      = { 'AXSET1' 'DIFFEPIiPaT2' 'ShortTOF' 'TRAMPRAGEWHOLEHD' 'TRANFLAIR' 'TRANSEPIPERFUSION' 'TRANTSET2' ...
                      'gre_field_mapping_update' 'localizer' };
        seq       = { '005' '007' '013' '002' '003' '009' '004' '006' '001' };
        entropies = {  0.0806976970085683253941510884033 ...
                       0.338734033776017517958223379537 ...
                       0.077364515595112856582993288157 ...
                       0.304083672612800781642761194234 ...
                       0.134782239953495003303984844933 ...
                       0.0661787436811674817382922242359 ...
                       0.063789395426281564338566454353 ...
                       0.272639207578217579452939389739 ...
                       0.236764193255463328835475067535  };
        orients2fix = struct('img_type', { 'ase' 'local' }, 'orientation', { 'y' 'y' });
 	end 

	properties (Dependent)
        files
    end 
    
	methods
        function fils = get.files(this)
            fils = {};
            for d = 1:length(this.dirs) %#ok<FORFLG>
                dt = mlsystem.DirTool( ...
                         fullfile(this.mrPath, 'unpack', this.dirs{d}, this.seq{d}, '*.nii')); 
                fils = [ fils dt.fqfns ]; %#ok<AGROW>
            end
        end
        
        function test_orientRepair(this)
            %import mlsurfer.* mlsurfer_xunit.*;
            %SurferDicomConverter.orientRepair(this.fslPath, this.orients2fix);
            %Test_SurferDicomConverter.assertEntropies(this.entropies, this.files); 
        end        
 		function test_convertSession(this)
            mlsurfer.SurferDicomConverter.convertSession(this.sessionPath);
            for d = 1:length(this.dirs) 
                assertTrue(lexist(filename( ...
                    fullfile(this.mrPath, 'unpack', this.dirs{d},  this.seq{d}, this.seq{d}), '.nii'), 'file')); 
            end
        end
        function test_ctor(this)
        end

        function setUp(this)
            this.setUp@mlsurfer_xunit.Test_mlsurfer;
            this.preferredSession = 1;
            if (~lexist(this.fslPath,'dir'))
                mkdir(this.fslPath); end
            cd(this.fslPath);
        end
 		function this = Test_SurferDicomConverter(varargin) 
 			this = this@mlsurfer_xunit.Test_mlsurfer(varargin{:}); 
 		end % Test_SurferDicomConverter (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

