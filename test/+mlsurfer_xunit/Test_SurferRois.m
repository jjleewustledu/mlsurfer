classdef Test_SurferRois < MyTestCase
	%% TEST_SURFERROIS 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlsurfer.Test_SurferRois % in . or the matlab path
	%          >> runtests mlsurfer.Test_SurferRois:test_nameoffunc
	%          >> runtests(mlsurfer.Test_SurferRois, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision: 2472 $
 	%  was created $Date: 2013-08-10 21:38:29 -0500 (Sat, 10 Aug 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-08-10 21:38:29 -0500 (Sat, 10 Aug 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/test/+mlsurfer_xunit/trunk/Test_SurferRois.m $, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id: Test_SurferRois.m 2472 2013-08-11 02:38:29Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

    properties (Constant)
        INDICES = ...
       [ 2           4           5           7           8          10          11          12          13          14          15 ...
        16          17          18          24          26          28          30          31          41          43          44 ...
        46          47          49          50          51          52          53          54          58          60          62 ...
        63          72          77          80          85         251         252         253         254         255       11100 ...
     11101       11102       11103       11104       11105       11106       11107       11108       11109       11110       11111 ...
     11112       11113       11114       11115       11116       11117       11118       11119       11120       11121       11122 ...
     11123       11124       11125       11126       11127       11128       11129       11130       11131       11132       11133 ... 
     11134       11135       11136       11137       11138       11139       11140       11141       11143       11144       11145 ... 
     11146       11147       11148       11149       11150       11151       11152       11153       11154       11155       11156 ...
     11157       11158       11159       11160       11161       11162       11163       11164       11165       11166       11167 ...
     11168       11169       11170       11171       11172       11173       11174       11175       12100       12101       12102 ...
     12103       12104       12105       12106       12107       12108       12109       12110       12111       12112       12113 ...
     12114       12115       12116       12117       12118       12119       12120       12121       12122       12123       12124 ...
     12125       12126       12127       12128       12129       12130       12131       12132       12133       12134       12135 ...
     12136       12137       12138       12139       12140       12141       12143       12144       12145       12146       12147 ...
     12148       12149       12150       12151       12152       12153       12154       12155       12156       12157       12158 ...
     12159       12160       12161       12162       12163       12164       12165       12166       12167       12168       12169 ...
     12170       12171       12172       12173       12174       12175 ];
 
        SAMPLE = [ 2 4 5 7 12172 12173 12174 12175 ];
    end
    
	properties
        E_parcellatedImage      = 1.191408514451744;
        E_parcellatedIndices    = 0;
        E_parcellatedMapping    = 0.310158404761463;
        E_parcellatedThickness  = 0;
        E_registerAparcOnRawavg = 0.445491038973575;
        surferRois        
    end
    
    properties (Dependent)
        ho_on_t1
        mriPath
        surfPath
    end
    
    methods %% setters/getters
        function fqfn = get.ho_on_t1(this)
            fqfn = fullfile( ...
                   fileparts(this.ho_fqfn), [this.ho_fp '_on_' this.t1_fp '.nii.gz']);
        end
        function pth  = get.mriPath(this)
            pth = fullfile(this.sessionPath, 'mri', '');
        end
        function pth  = get.surfPath(this)
            pth = fullfile(this.sessionPath, 'surf', '');
        end
    end
    
	methods 
        function test_parcellateIndices(this) 
            pIdx = this.surferRois.parcellateIndices;
            this.assertEntropies(this.E_parcellatedIndices, pIdx.fqfilename);
        end
        function test_parcellateThickness(this) 
            [pThick, this.surferRois] = this.surferRois.parcellateThickness;
            this.assertEntropies(this.E_parcellatedThickness, pThick.fqfilename);
        end
 		function test_parcellateImage(this)
 			import mlsurfer.*; 
            this.surferRois           = this.prepareAparcIndicesAndRois(this.surferRois);
            [pImage, this.surferRois] = this.surferRois.parcellateImage(this.ho_on_t1);
            this.assertEntropies(this.E_parcellatedImage, pImage.fqfilename);
        end
        function test_parcellateMapping(this)
            testmap = containers.Map( ...
                [   2   4   5   7   8  10  11  12  13  14  15  16  17  18 ], ...
                [ 101 102 103 104 105 106 107 108 109 110 111 112 113 114 ]);
            ic = this.surferRois.parcellateMapping(testmap, 'parcellateMappingTest');
            this.assertEntropies(this.E_parcellatedMapping, ic.fqfilename);
            delete(ic.fqfilename);
        end
        function test_aparcIndexedRoiChoices(this)
            this.surferRois            = this.prepareAparcIndicesAndRois(this.surferRois);
            assertEqual(single(6680209), this.surferRois.aparcIndexedRoiChoice(0).dipsum);
            assertEqual(single(0),       this.surferRois.aparcIndexedRoiChoice(1).dipsum);
            assertEqual(single(183349),  this.surferRois.aparcIndexedRoiChoice(2).dipsum);
            assertEqual(single(0),       this.surferRois.aparcIndexedRoiChoice(3).dipsum);
            assertEqual(single(0),       this.surferRois.aparcIndexedRoiChoice(12172).dipsum);
            assertEqual(single(0),       this.surferRois.aparcIndexedRoiChoice(12173).dipsum);            
        end
        function test_aparcIndicesAndRois(this)
            import mlrois.*;
            this.surferRois = this.prepareAparcIndicesAndRois(this.surferRois);
            [indices,rois]  = this.surferRois.aparcIndicesAndRois;
            assertVectorsAlmostEqual(this.INDICES, indices);
            rois = imcast(rois, 'mlfourd.ImagingComponent');
            for card = 1:length(indices)/10
                assertEqual([this.surferRois.separatedRoiFileprefix num2str(this.INDICES(card))], ...
                             rois{card}.fileprefix);
            end
        end
        function test_registerAparcOnRawavg(this) % indirectly tests mgz2nifti
            targ  = fullfile(this.fslPath, [this.surferRois.DestrieuxNoDot '_on_rawavg.nii.gz']);
            targ2 = fullfile(this.mriPath, [this.surferRois.Destrieux '_on_rawavg.mgz']);
            targ3 = fullfile(this.mriPath, [this.surferRois.Destrieux '.mgz']);
            if (lexist(targ));  delete(targ);  end
            if (lexist(targ2)); delete(targ2); end
            assert(lexist(targ3, 'file'));
            
            this.surferRois.registerAparcOnRawavg;
            this.assertEntropies(this.E_registerAparcOnRawavg, targ);
        end
        function rois = prepareAparcIndicesAndRois(this, rois)
            [~,~,rois]        = rois.aparcIndicesAndRois;
            rois.aparcIndices = this.SAMPLE;
        end
        
 		function this = Test_SurferRois(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            cd(this.sessionPath);
            this.surferRois              = mlsurfer.SurferRois.createFromSessionPath(this.sessionPath);
            this.surferRois.studyPath    = fullfile(getenv('MLUNIT_TEST_PATH'), 'np755', '');
            this.surferRois.sessionId    = 'mm01-020_p7377_2009feb5';
            assert(isunix);
            setenv('SUBJECTS_DIR', this.surferRois.sessionPath);
        end % ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

