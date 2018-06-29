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
        statsSuffix = '_on_T1.stats'
 		t1Prefix    = 't1_default'
        t2Prefix    = 't2_default'
        
        sessionRegexp = '\S*(?<mmnum>mm\d+\-\d+)_(?<pnum>p\d+)\S+'
        sessionNamePattern = 'mm0*-0*'
    end
    
    properties (Dependent)
        subjectsDir
        testSubjectPath
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
        function        setEnvironment6
            [~,hn] = mlbash('hostname');
            switch hn
                case {'login01.cluster' 'login02.cluster'}
                    mlbash('module load freesurfer-6.0.0');
                    assertEqual('FREESURFER_HOME', '/export/freesurfer-6.0');
                case {'william' 'pascal' 'linux1' 'linux5' 'maulinux1'}
                    mlbash('export FREESURFER_HOME=/home/usr/jjlee/Local/freesurfer_2017oct20; source $FREESURFER_HOME/SetUpFreeSurfer.sh');
                    [~,v] = mlbash('recon-all --version');
                    assertNotEmpty(regexp(v, 'stable-pub-v6.0.0'));
                otherwise
                    error('mlsurfer:unsupportedSwitchcase', 'Surfer6Factor.setEnvironment');
            end
        end
    end  
    
    methods 
        
        %% GET
        
        function x = get.subjectsDir(~)
            x = getenv('SUBJECTS_DIR');
        end
        function x = get.testSubjectPath(~)
            x = fullfile(getenv('MLUNIT_TEST_PATH'), 'np755', 'mm01-020_p7377_2009feb5', '');
        end
    end   
    
    %% PRIVATE
    
	methods (Access = 'private')		  
 		function this = SurferRegistry(varargin)
 			this = this@mlpatterns.Singleton(varargin{:});
 		end
    end 
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

