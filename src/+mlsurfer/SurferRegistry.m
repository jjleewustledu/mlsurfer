classdef SurferRegistry < mlpatterns.Singleton
	%% SURFERREGISTRY  

	%  $Revision$
 	%  was created 08-Oct-2015 11:26:16
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlsurfer/src/+mlsurfer.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	

	properties
        datSuffix   = '_to_fsanatomical.dat'
        statsSuffix = '_on_fsanatomical.stats'
 		t1Prefix    = 't1_default'
        t2Prefix    = 't2_default'
        
        sessionRegexp = '\S*(?<mmnum>mm\d+\-\d+)_(?<pnum>p\d+)\S+'
        sessionNamePattern = 'mm0*-0*'
    end
    
    properties (Dependent)
        subjectsDir
        testSubjectPath
    end
    
    methods %% GET
        function x = get.subjectsDir(~)
            x = getenv('SUBJECTS_DIR');
        end
        function x = get.testSubjectPath(~)
            x = fullfile(getenv('MLUNIT_TEST_PATH'), 'np755', 'mm01-020_p7377_2009feb5', '');
        end
    end
    
    methods (Static) 
        function this = instance(qualifier)
            %% INSTANCE uses string qualifiers to implement registry behavior that
            %  requires access to the persistent uniqueInstance
            persistent uniqueInstance
            
            if (exist('qualifier','var') && ischar(qualifier))
                if (strcmp(qualifier, 'initialize'))
                    uniqueInstance = [];
                end
            end
            
            if (isempty(uniqueInstance))
                this = mlsurfer.SurferRegistry();
                uniqueInstance = this;
            else
                this = uniqueInstance;
            end
        end
    end     
    
	methods (Access = 'private')		  
 		function this = SurferRegistry(varargin)
 			this = this@mlpatterns.Singleton(varargin{:});
 		end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

