classdef SubjectId
	%% SUBJECTID ...
	%  $Revision: 2613 $
 	%  was created $Date: 2013-09-07 19:15:52 -0500 (Sat, 07 Sep 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-07 19:15:52 -0500 (Sat, 07 Sep 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SubjectId.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: SubjectId.m 2613 2013-09-08 00:15:52Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties (Dependent)
        subjectsDir % Freesurfer SUBJECTS_DIR env variable
        subjectId   % identifier for freesurfer runs
    end

    methods (Static)
        function si = createFromPattern(patt)
            dt = mlsystem.DirTool(patt);
            assert(~isempty(dt.fqdns));
            si = mlsurfer.SubjectId.createFromSubjectsDir(dt.fqdns{1});
        end
        function si = createFromSubjectsDir(sdir)
            si = mlsurfer.SubjectId(sdir);
        end
        function si = createFromSubjectsDirAndId(sdir, id)
            si = mlsurfer.SubjectId(sdir, id);
        end
        function id = subjectsDir2Id(sdir)
            [~,id]   = fileparts(sdir);
            delimits = strfind(id, '_');
            if (length(delimits) > 1)
                id = id(1:delimits(2)-1);
            end
        end
    end
    
    methods %% set/get
        function d = get.subjectsDir(this)
            assert(lexist(this.subjectsDir_, 'dir'));
            d = this.subjectsDir_;
        end
        function id = get.subjectId(this)
            if (isempty(this.subjectId_))
                this.subjectId_ = this.subjectsDir2Id(this.subjectsDir);
            end
            id = this.subjectId_;
        end
    end
    
	methods (Access = 'protected')
 		function this = SubjectId(sdir, varargin) 
 			%% SUBJECTID 
 			%  Usage:  obj = SubjectId(subjects_dir[, subject_id]) 
            assert(lexist(sdir, 'dir'));
            this.subjectsDir_ = sdir;
            if (nargin > 1)
                assert(ischar(varargin{1}));
                this.subjectId_ = varargin{1};
            end
            
 		end %  ctor 
    end 
    
    properties (Access = 'private')
        subjectsDir_
        subjectId_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

