classdef SurferFilesystem < mlsurfer.ISurferFilesystem 
	%% SURFERFILESYSTEM provides commonly needed filesystem data and services for the mlsurfer package.
    %  Property sessionRegexp and methods isaSessionpath, sessionPathParts screen for well-formed
    %  session names.  They require adjustments to the naming conventions of the active study.
    %  See also:  SurferBuilderPrototype

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 
    
    properties (Constant)        
        T1_FILEPREFIX  = 't1_default' % @deprecated
        T2_FILEPREFIX  = 't2_default'
    end
    
	properties (Dependent)
        fslPath
        labelPath
        mmnum
        mriPath
        perfPath
        pnum
        sessionId
        sessionPath
        sessionRegexp
        statsPath
        studyPath
        surfPath
        
        datSuffix
        statsSuffix
        t1Prefix
        t2Prefix
    end
    
    methods (Static)
        function fn = datFilename(varargin)
            ip = inputParser;
            addRequired(ip, 'path',   @(x) isempty(x) || lexist(x, 'dir'));
            addRequired(ip, 'prefix', @(x) ischar(x) && ~isempty(x));
            parse(ip, varargin{:});
            fn = fullfile(ip.Results.path, ...
                 sprintf('%s%s', ip.Results.prefix, mlsurfer.SurferRegistry.instance.datSuffix));
        end
        function fn = statsFilename(varargin)
            ip = inputParser;
            addRequired(ip, 'path',   @(x) isempty(x) || lexist(x, 'dir'));
            addRequired(ip, 'prefix', @(x) ischar(x) && ~isempty(x));
            parse(ip, varargin{:});
            fn = fullfile(ip.Results.path, ...
                 sprintf('%s%s', ip.Results.prefix, mlsurfer.SurferRegistry.instance.statsSuffix));
        end
    end
    
    methods 
        
        %% GET/SET        
        
        function pth  = get.fslPath(this)
            pth = fullfile(this.sessionPath, 'fsl', '');
        end
        function pth  = get.labelPath(this)
            pth = fullfile(this.sessionPath, 'label', '');
        end
        function m    = get.mmnum(this)
            m = this.sessionPathParts(this.sessionPath);
        end
        function pth  = get.mriPath(this)
            pth = fullfile(this.sessionPath, 'mri', '');
        end
        function pth  = get.perfPath(this)
            pth = fullfile(this.sessionPath, 'perfusion_4dfp', '');
        end
        function p    = get.pnum(this)
            [~,p] = this.sessionPathParts(this.sessionPath);
        end
        function id   = get.sessionId(this)
            [~,id] = fileparts(trimpath(this.sessionPath));
        end
        function this = set.sessionId(this, id)
            newpth  = fullfile( ...
                      fileparts(trimpath(this.sessionPath)), id, '');            
            assert(this.isaSessionPath(newpth));
        end
        function pth  = get.sessionPath(this)
            pth = this.sessionPath_;
        end
        function this = set.sessionPath(this, pth)
            assert(this.isaSessionPath(pth));
            this.sessionPath_ = pth;
        end
        function pth  = get.sessionRegexp(this)
            pth = this.registry_.sessionRegexp;
        end
        function pth  = get.statsPath(this)
            pth = fullfile(this.sessionPath, 'stats', '');
        end
        function pth  = get.studyPath(this)
            pth = fileparts(trimpath(this.sessionPath));
        end
        function pth  = get.surfPath(this)
            pth = fullfile(this.sessionPath, 'surf', '');
        end
        
        function x    = get.datSuffix(this)
            x = this.registry_.datSuffix;
        end
        function x    = get.statsSuffix(this)
            x = this.registry_.statsSuffix;
        end
        function x    = get.t1Prefix(this)
            x = this.registry_.t1Prefix;
        end
        function x    = get.t2Prefix(this)
            x = this.registry_.t2Prefix;
        end
        
        %%
        
        function tf     = isaSessionPath(this, pth)
            tf = true;
            assert(ischar(pth),        'SurferFilesystem.isaSessionPath.pth was not char');
            assert(~isempty(pth),      'SurferFilesystem.isaSessionPath.pth was empty');
            assert(lexist(pth, 'dir'), 'SurferFilesystem.isaSessionPath:  %s does not exist', pth);
%             try
%                 this.sessionPathParts(pth); % test if pth is well-formed
%             catch ME
%                 error('mlsurfer:filesystemErr', ...
%                       'SurferFilesystem.isaSessionPath could not recognize %s as a session path', pth);
%             end
        end
        function [mm,p] = sessionPathParts(this, pth)
            re = regexp(pth, this.sessionRegexp, 'names');
            mm = re.mmnum;
            p  = re.pnum;
        end
        function fqfn   = pialNative_fqfn(this, hemi)
            assert(strcmp('lh', hemi) || strcmp('rh', hemi));
            fqfn = fullfile(this.mriPath, [hemi 'PialNative']);
        end
        function fqfn   = segstats_fqfn(this, varargin)
            ip = inputParser;
            addOptional(ip, 'hemi',       '', @ischar);
            addOptional(ip, 'fileprefix', '', @ischar);
            parse(ip, varargin{:});            
            fqfn = fullfile(this.fslPath, [ip.Results.hemi '_' ip.Results.fileprefix this.statsSuffix]);
        end
        
 		function this   = SurferFilesystem(varargin) 
 			%% SURFERFILESYSTEM 
 			%  Usage:  this = SurferFilesystem(path_to_session) 

            this.registry_ = mlsurfer.SurferRegistry.instance;
            ip = inputParser;
            addOptional(ip, 'sessPth', pwd, @(x) this.isaSessionPath(x));
            parse(ip, varargin{:});
            assert(this.isaSessionPath(ip.Results.sessPth)); %% KLUDGE
            this.sessionPath_ = ip.Results.sessPth;
        end 
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        registry_
        sessionPath_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

