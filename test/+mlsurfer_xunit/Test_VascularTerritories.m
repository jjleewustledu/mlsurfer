classdef Test_VascularTerritories < MyTestCase 
	%% TEST_VASCULARTERRITORIES  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlsurfer.Test_VascularTerritories % in . or the matlab path 
	%          >> runtests mlsurfer.Test_VascularTerritories:test_nameoffunc 
	%          >> runtests(mlsurfer.Test_VascularTerritories, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
 		 vterr
 	end 

	methods 		 

 		function test_aca(this) 
 			aca    = this.vterr.territoryRoi('lh', 'aca');
            acaNii = aca.nifti;
            acaNii.fileprefix = 'Test_VascularTerritories_test_aca';
            acaNii.save;
            assertEqual(1,     double(acaNii.dipmax));
            assertEqual(0,     double(acaNii.dipmin));
            assertEqual(80290, double(acaNii.dipsum));
        end 
        function test_aca_min(this)            
 			aca    = this.vterr.territoryRoi('lh', 'aca_min');
            acaNii = aca.nifti;
            acaNii.fileprefix = 'Test_VascularTerritories_test_aca_min';
            acaNii.save;
            assertEqual(1,     double(acaNii.dipmax));
            assertEqual(0,     double(acaNii.dipmin));
            assertEqual(50232, double(acaNii.dipsum));
        end
        function test_aca_max(this)            
 			aca    = this.vterr.territoryRoi('lh', 'aca_max');
            acaNii = aca.nifti;
            acaNii.fileprefix = 'Test_VascularTerritories_test_aca_max';
            acaNii.save;
            assertEqual(1,      double(acaNii.dipmax));
            assertEqual(0,      double(acaNii.dipmin));
            assertEqual(104911, double(acaNii.dipsum));
        end
 		function test_mca(this) 
 			mca    = this.vterr.territoryRoi('lh', 'mca');
            mcaNii = mca.nifti;
            mcaNii.fileprefix = 'Test_VascularTerritories_test_mca';
            mcaNii.save;
            assertEqual(1,     double(mcaNii.dipmax));
            assertEqual(0,     double(mcaNii.dipmin));
            assertEqual(80290, double(mcaNii.dipsum));
        end 
        function test_mca_min(this)            
 			mca    = this.vterr.territoryRoi('lh', 'mca_min');
            mcaNii = mca.nifti;
            mcaNii.fileprefix = 'Test_VascularTerritories_test_mca_min';
            mcaNii.save;
            assertEqual(1,     double(mcaNii.dipmax));
            assertEqual(0,     double(mcaNii.dipmin));
            assertEqual(50232, double(mcaNii.dipsum));
        end
        function test_mca_max(this)            
 			mca    = this.vterr.territoryRoi('lh', 'mca_max');
            mcaNii = mca.nifti;
            mcaNii.fileprefix = 'Test_VascularTerritories_test_mca_max';
            mcaNii.save;
            assertEqual(1,      double(mcaNii.dipmax));
            assertEqual(0,      double(mcaNii.dipmin));
            assertEqual(104911, double(mcaNii.dipsum));
        end
 		function test_pca(this) 
 			pca    = this.vterr.territoryRoi('lh', 'pca');
            pcaNii = pca.nifti;
            pcaNii.fileprefix = 'Test_VascularTerritories_test_pca';
            pcaNii.save;
            assertEqual(1,     double(pcaNii.dipmax));
            assertEqual(0,     double(pcaNii.dipmin));
            assertEqual(80290, double(pcaNii.dipsum));
        end 
        function test_pca_min(this)            
 			pca    = this.vterr.territoryRoi('lh', 'pca_min');
            pcaNii = pca.nifti;
            pcaNii.fileprefix = 'Test_VascularTerritories_test_pca_min';
            pcaNii.save;
            assertEqual(1,     double(pcaNii.dipmax));
            assertEqual(0,     double(pcaNii.dipmin));
            assertEqual(50232, double(pcaNii.dipsum));
        end
        function test_pca_max(this)            
 			pca    = this.vterr.territoryRoi('lh', 'pca_max');
            pcaNii = pca.nifti;
            pcaNii.fileprefix = 'Test_VascularTerritories_test_pca_max';
            pcaNii.save;
            assertEqual(1,      double(pcaNii.dipmax));
            assertEqual(0,      double(pcaNii.dipmin));
            assertEqual(104911, double(pcaNii.dipsum));
        end
 		function this = Test_VascularTerritories(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            
            import mlsurfer.*;
            this.vterr = VascularTerritories( ...
                         SurferBuilderPrototype('sessionPath', this.sessionPath));
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

