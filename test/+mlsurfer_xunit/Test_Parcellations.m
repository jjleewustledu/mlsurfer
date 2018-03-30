classdef Test_Parcellations < MyTestCase 
	%% TEST_PARCELLATIONS  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlsurfer.Test_Parcellations % in . or the matlab path 
	%          >> runtests mlsurfer.Test_Parcellations:test_nameoffunc 
	%          >> runtests(mlsurfer.Test_Parcellations, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 

	properties 
 		 parc
 	end 

	methods
        function test_segidentifiedStatsMap_thickness(this)
            map = this.parc.segidentifiedStatsMap('lh', 'thickness', 'aca');
            kys = map.keys;
            assertEqual(11101, kys{1});
            assertEqual(2.619, map(11105));            
            map = this.parc.segidentifiedStatsMap('rh', 'thickness', 'pca_max');
            kys = map.keys;
            assertEqual(12174, kys{15});
            assertEqual(2.811, map(12173));            
            map = this.parc.segidentifiedStatsMap('rh', 'thickness', 'sinus');
            kys = map.keys;
            assertEqual(12103, kys{1});
            assertEqual(2.307, map(12111));
        end    
        function test_segidentifiedStatsMap_thicknessstd(this)
            map = this.parc.segidentifiedStatsMap('lh', 'thicknessstd', 'aca', 'std');
            kys = map.keys;
            assertEqual(11101, kys{1});
            assertEqual(0.812, map(11105));        
            map = this.parc.segidentifiedStatsMap('rh', 'thicknessstd', 'pca_max', 'std');
            kys = map.keys;
            assertEqual(12174, kys{15});
            assertEqual(0.764, map(12173));
            map = this.parc.segidentifiedStatsMap('rh', 'thicknessstd', 'sinus', 'std');
            kys = map.keys;
            assertEqual(12103, kys{1});
            assertEqual(0.627, map(12111));
        end     
        function test_segidentifiedStatsMap_cvs(this)
            map = this.parc.segidentifiedStatsMap('lh', 'cvs', 'aca');
            kys = map.keys;
            assertEqual(11101, kys{1});
            assertEqual(2.539, map(11105));            
            map = this.parc.segidentifiedStatsMap('rh', 'cvs', 'pca_max');
            kys = map.keys;
            assertEqual(12174, kys{15});
            assertEqual(2.252, map(12173));            
            map = this.parc.segidentifiedStatsMap('rh', 'cvs', 'sinus');
            kys = map.keys;
            assertEqual(12103, kys{1});
            assertEqual(2.056, map(12111));
        end
        function test_segnamedStatsMap(this)
            map = this.parc.segnamedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'all');
            kys = map.keys;
            assertEqual('ctx_lh_G_Ins_lg_and_S_cent_ins', kys{1});
            assertEqual(11117,     map('ctx_lh_G_Ins_lg_and_S_cent_ins').segid);
            assertEqual(902,       map('ctx_lh_G_Ins_lg_and_S_cent_ins').volume_mm3);
            assertEqual(1171.5851, map('ctx_lh_G_Ins_lg_and_S_cent_ins').mean);
            assertEqual(45.8830,   map('ctx_lh_G_Ins_lg_and_S_cent_ins').stddev);
            assertEqual(1012.4753, map('ctx_lh_G_Ins_lg_and_S_cent_ins').min);
            assertEqual(1258.0894, map('ctx_lh_G_Ins_lg_and_S_cent_ins').max);
        end 
        function test_segnamedStatsMap_PET_volume(this)
            map = this.parc.segnamedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'volume');
            assertEqual(1784,   map('ctx_lh_G_and_S_transv_frontopol').volume_mm3);
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max', 'volume');
            assertEqual(1587,   map('ctx_rh_S_temporal_inf').volume_mm3);
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus', 'volume');
            assertEqual(2874,   map('ctx_rh_G_cuneus').volume_mm3);
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb', 'volume');
            assertEqual(11413,  map('Right-Cerebellum-White-Matter').volume_mm3);
        end
        function test_segnamedStatsMap_PET_mean(this)
            map = this.parc.segnamedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca');
            kys = map.keys;
            assertEqual('ctx_lh_G_and_S_cingul-Ant', kys{1});
            assertEqual(690.8799,                    map('ctx_lh_G_and_S_transv_frontopol').mean);            
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max');
            kys = map.keys;
            assertEqual('ctx_rh_S_temporal_sup', kys{15});
            assertEqual(742.0371,                map('ctx_rh_S_temporal_inf').mean);            
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus');
            kys = map.keys;
            assertEqual('ctx_rh_G_and_S_paracentral', kys{1});
            assertEqual(1329.1438,                    map('ctx_rh_G_cuneus').mean);            
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb');
            kys = map.keys;
            assertEqual('Right-Cerebellum-White-Matter', kys{1});
            assertEqual(0.3947,                          map('Right-Cerebellum-White-Matter').mean);
        end
        function test_segnamedStatsMap_PET_std(this)
            map = this.parc.segnamedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'std');
            kys = map.keys;
            assertEqual('ctx_lh_G_and_S_cingul-Ant', kys{1});
            assertEqual(62.6465,                     map('ctx_lh_G_and_S_transv_frontopol').stddev);        
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max', 'std');
            kys = map.keys;
            assertEqual('ctx_rh_S_temporal_sup', kys{15});
            assertEqual(136.2936,                map('ctx_rh_S_temporal_inf').stddev);
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus', 'std');
            kys = map.keys;
            assertEqual('ctx_rh_G_and_S_paracentral', kys{1});
            assertEqual(127.2861,                     map('ctx_rh_G_cuneus').stddev);
            map = this.parc.segnamedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb', 'std');
            kys = map.keys;
            assertEqual('Right-Cerebellum-White-Matter', kys{1});
            assertEqual(0.0419,                          map('Right-Cerebellum-White-Matter').stddev);
        end
        function test_segidentifiedStatsMap_PET_volume(this)
            map = this.parc.segidentifiedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'volume');
            assertEqual(1784,  map(11105));
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max', 'volume');
            assertEqual(1587,  map(12173));
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus', 'volume');
            assertEqual(2874,  map(12111));
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb', 'volume');
            assertEqual(11413, map(46));
        end
        function test_segidentifiedStatsMap_PET_mean(this)
            map = this.parc.segidentifiedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca');
            kys = map.keys;
            assertEqual(11101,    kys{1});
            assertEqual(690.8799, map(11105));            
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max');
            kys = map.keys;
            assertEqual(12174,    kys{15});
            assertEqual(742.0371, map(12173));            
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus');
            kys = map.keys;
            assertEqual(12103,     kys{1});
            assertEqual(1329.1438, map(12111));            
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb');
            kys = map.keys;
            assertEqual(46,     kys{1});
            assertEqual(0.3947, map(46));
        end
        function test_segidentifiedStatsMap_PET_std(this)
            map = this.parc.segidentifiedStatsMap('lh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'aca', 'std');
            kys = map.keys;
            assertEqual(11101,   kys{1});
            assertEqual(62.6465, map(11105));        
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX, 'pca_max', 'std');
            kys = map.keys;
            assertEqual(12174,    kys{15});
            assertEqual(136.2936, map(12173));
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX, 'sinus', 'std');
            kys = map.keys;
            assertEqual(12103,    kys{1});
            assertEqual(127.2861, map(12111));
            map = this.parc.segidentifiedStatsMap('rh', mlsurfer.PETSegstatsBuilder.OEFNQ_FILEPREFIX, 'cereb', 'std');
            kys = map.keys;
            assertEqual(46,     kys{1});
            assertEqual(0.0419, map(46));
        end
        function test_statsFilename(this)
            import mlpet.* mlsurfer.*;
            assertEqual( ...
                fullfile(this.fslPath, ['lh_' PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX '_on_t1_default_on_fsanatomical.stats']), ...
                this.parc.statsFilename('lh', PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX));
        end
 		function test_isInTerritory(this)
            assertTrue( this.parc.isInTerritory('Left-Cerebellum-White-Matter', 'cereb'));
            assertFalse(this.parc.isInTerritory('ctx_lh_S_temporal_transverse', 'cereb'));
            assertTrue( this.parc.isInTerritory('ctx_rh_G_cuneus',              'sinus'));
            assertFalse(this.parc.isInTerritory('Left-Cerebellum-White-Matter', 'sinus'));
            assertTrue( this.parc.isInTerritory('ctx_lh_G_and_S_subcentral',    'mca_min'));
            assertFalse(this.parc.isInTerritory('ctx_rh_S_collat_transv_ant',   'mca_min'));
        end  
        function test_segidentifiedSegnameMap(this)
            theMap = this.parc.segidentifiedSegnameMap;
            
            assertEqual('Left-Cerebellum-White-Matter', theMap(7).segname);
            assertEqual([220 248 164 0], theMap(7).RGBA);
            assertEqual('cereb', theMap(7).territory);
            
            assertEqual('Right-Cerebellum-White-Matter', theMap(46).segname);
            assertEqual([220 248 164 0], theMap(46).RGBA);
            assertEqual('cereb', theMap(46).territory);
            
            assertEqual('ctx_lh_G_and_S_frontomargin', theMap(11101).segname);
            assertEqual([23 220 60 0], theMap(11101).RGBA);
            assertEqual('aca', theMap(11101).territory);
            
            assertEqual('ctx_lh_S_temporal_transverse', theMap(11175).segname);
            assertEqual([221 60 60 0], theMap(11175).RGBA);
            assertEqual('mca_min', theMap(11175).territory);
            
            assertEqual('ctx_rh_G_and_S_frontomargin', theMap(12101).segname);
            assertEqual([23 220 60 0], theMap(12101).RGBA);
            assertEqual('aca', theMap(12101).territory);
            
            assertEqual('ctx_rh_S_temporal_transverse', theMap(12175).segname);
            assertEqual([221 60 60 0], theMap(12175).RGBA);
            assertEqual('mca_min', theMap(12175).territory);
            
        end
        function test_ctor(this)
            assertTrue(isa(this.parc, 'mlsurfer.Parcellations'));
        end
        
 		function this = Test_Parcellations(varargin)
 			this = this@MyTestCase(varargin{:}); 
            
            import mlsurfer.*;
            this.parc = Parcellations( ...
                PETSegstatsBuilder('SessionPath', this.sessionPath));
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

