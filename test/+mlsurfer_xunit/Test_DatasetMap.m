classdef Test_DatasetMap < MyTestCase 
	%% TEST_DATASETMAP  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlsurfer.Test_DatasetMap % in . or the matlab path 
	%          >> runtests mlsurfer.Test_DatasetMap:test_nameoffunc 
	%          >> runtests(mlsurfer.Test_DatasetMap, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
 	end 

	methods 
 		 

 		function test_asMap(this) 
 			import mlsurfer.*; 
            map  = DatasetMap.asMap('thickness', 'SessionPath', this.sessionPath, 'Territory', 'all');
            assertEqual(2.292, map(11101));
            assertEqual(2.811, map(12175));
 		end 
 		function this = Test_DatasetMap(varargin) 
 			this = this@MyTestCase(varargin{:}); 
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

