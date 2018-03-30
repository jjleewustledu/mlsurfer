classdef SurferDicomConverter < mlfourd.AbstractDicomConverter
	%% SURFERDICOMCONVERTER is a concrete strategy for interfaces DicomConverter, AbstractConverter;
    %                          a facade for freesurfer commands
    %  Version $Revision: 2633 $ was created $Date: 2013-09-16 01:20:19 -0500 (Mon, 16 Sep 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-16 01:20:19 -0500 (Mon, 16 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferDicomConverter.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: SurferDicomConverter.m 2633 2013-09-16 06:20:19Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

    properties (Constant)
        % for construction of structInfo
        INFO_EXPRESSION = ...
'(?<index>\d+)\s+(?<seq_type>\w+)\s+(?<status>\w+)\s+(?<dim1>\d+)\s+(?<dim2>\d+)\s+(?<dim3>\d+)\s+(?<dim4>\d+)\s+(?<siemens>\S+)';
        SCAN_INFO       = 'scan.info';
    end
    
    properties
        unpackFolders = {'unpack'};
        orients2fix = struct([]);
                    % struct('img_type', { 'ase' 'local' 'asl' 'dwi' 'ep2d' 'gre' 't1' 't2' 'ir' }, ...
                    %     'orientation', { 'y'   'y'     'y'   'y'   'y'    'y'   'y'  'y'  'y' });
    end
  
    methods (Static)   
        function this       = convertSession(sessionPth, varargin)
            %% CONVERTSESSION 
            %  Usage:  SurferDicomConverter.convertSession(full_path_to_session[, ...
            %          option_name, option_value, ...])
            %          ^            ^ true/false
            %          UnpackDicom - from DICOM to Trio/unpack
            %          CopyUnpacked - from Trio/unpack to fsl folder
            %          OrientChangeToStandard - fslreorient2std
            %          OrientRepair - reorient manually per orients2fix
            %          LockFslFolder - write .surferconverter folder
            %          RefreshUnpackFolder - delete previously unpacked
            
            import mlsurfer.*;
            this = SurferDicomConverter.convertModalityPath( ...
                   firstExistingFile( ...
                      sessionPth, ...
                      SurferDicomConverter.modalityFolders), ...
                   varargin{:});
        end
        function lastobj    = convertSessions(patt, varargin)
            %% CONVERTSESSIONS 
            %  Usage:  SurferDicomConverter.convertSessions(string_pattern[, ...
            %          option_name, option_value, ...])
            %          ^            ^ true/false
            %          UnpackDicom - from DICOM to Trio/unpack
            %          CopyUnpacked - from Trio/unpack to fsl folder
            %          OrientChangeToStandard - fslreorient2std
            %          OrientRepair - reorient manually per orients2fix
            %          LockFslFolder - write .surferconverter folder
            %          RefreshUnpackFolder - delete previously unpacked
            
            dt = mlsystem.DirTool(patt);
            for s = 1:length(dt)
                fprintf('SurferDicomConverter will convert:  %s\n', dt.fqdns{s});
                lastobj = mlsurfer.SurferDicomConverter.convertSession(dt.fqdns{s}, varargin{:});
            end
            assert(~isempty(lastobj));
        end
        function this       = convertModalityPath(modalPth, varargin)
            %% CONVERTMODALITYPATH 
            %  Usage:  SurferDicomConverter.convertModalityPath(modal_path[, ...
            %          option_name, option_value, ...])
            %          ^            ^ true/false
            %          UnpackDicom - from DICOM to Trio/unpack
            %          CopyUnpacked - from Trio/unpack to fsl folder
            %          OrientChangeToStandard - fslreorient2std
            %          OrientRepair - reorient manually per orients2fix
            %          LockFslFolder - write .surferconverter folder
            %          RefreshUnpackFolder - delete previously unpacked
            
            p = inputParser;
            addRequired(p, 'modalPth', @(x) lexist(x,'dir'));
            addParamValue(p, 'UnpackDicom', true, @islogical);
            addParamValue(p, 'CopyUnpacked', true, @islogical);
            addParamValue(p, 'OrientChangeToStandard', true, @islogical);
            addParamValue(p, 'OrientRepair', true, @islogical);
            addParamValue(p, 'LockFslFolder', false, @islogical);
            addParamValue(p, 'RefreshUnpackFolder', true, @islogical);
            parse(p, modalPth, varargin{:});
            
            try
                this = mlsurfer.SurferDicomConverter.createFromModalityPath(modalPth);                
                if (this.islockedFslFolder('.surferconverter'))
                    this.archiveFslFolder; 
                    error('mlsurfer:DataDirectoryWasLocked', ...
                          'SurferDicomConverter.convertModalityPath');
                end
                if (p.Results.RefreshUnpackFolder)
                    this.removePreviouslyUnpacked; end
                if (p.Results.UnpackDicom)
                    this = this.unpackDicom; end
                if (p.Results.CopyUnpacked)
                    this.copyUnpacked(this.unpackPath, this.fslPath); end
                if (p.Results.OrientChangeToStandard)
                    this.orientChange2Standard(this.fslPath); end
                if (p.Results.OrientRepair)
                    this.orientRepair(this.fslPath, this.orients2fix); end
                if (p.Results.LockFslFolder)
                    this.lockFslFolder('.surferconverter'); end
            catch ME
                handwarning(ME);
            end       
        end  
        
        function this       = createFromSessionPath(sessionpth)
            %% CREATEFROMSESSIONPATH only instantiates the class at a modality-path
            %  obj = SurferDicomConverter.createFromSessionPath(session_path)

            import mlsurfer.*;
            this = SurferDicomConverter.createFromModalityPath( ...
                firstExistingFile(sessionpth, SurferDicomConverter.modalityFolders));
        end
        function this       = createFromModalityPath(mpth)
            %% CREATEFROMMODALITYPATH only instantiates the class at a modality-path
            %  obj = SurferDicomConverter.createFromModalityPaty(modality_path)
            
            this = mlsurfer.SurferDicomConverter(mpth);
        end
        function  cal       = unpacksDcmDir(dcmdir, targdir, unpackInfo)
            %% UNPACKDICOM is a facade for unpacksdcmdir -fsfast
            %  Usage:  cal = SurferDicomConverter.unpacksDcmDir(dcmdir, targdir, unpackInfo)
            %          ^ surfer stdout embedded in CellArrayList
            %                                        unpackInfo is a struct-array ^  
            %                                        fields:  index, seq_type, ext, name
            %                                        e.g.,    18,    mprage,   mgz, 001.mgz
            
            assert(~isstructEmpty(unpackInfo));
            cal = mlfourd.ImagingArrayList;
            for n = 1:length(unpackInfo) %#ok<*FORFLG>

                r_n = '';
                try
                    assert(isnumeric(unpackInfo(n).index   ) && ~isempty(unpackInfo(n).index));
                    assert(   ischar(unpackInfo(n).seq_type) && ~isempty(unpackInfo(n).seq_type));
                    assert(   ischar(unpackInfo(n).ext     ) && ~isempty(unpackInfo(n).ext));
                    assert(   ischar(unpackInfo(n).name    ) && ~isempty(unpackInfo(n).name));
                    niiList = sprintf(' -run %i %s %s %s ', ...
                              unpackInfo(n).index, unpackInfo(n).seq_type, unpackInfo(n).ext, unpackInfo(n).name);     
                    [~,r_n] = mlbash(['unpacksdcmdir -src ' dcmdir ' -targ ' targdir ' -fsfast ' niiList]);
                    cal.add(r_n);
                catch ME
                    handwarning(ME, r_n);
                end
            end
        end  
        function structInfo = infoFile2structInfo(fil)
            structInfo = mlsurfer.SurferDicomConverter.parseInfoCell( ...
                         mlio.TextIO.textfileToCell(fil));
        end 
        function [s,r]      = scanDicom(dcmdir, targdir)
            %% SCANDICOM is a facade for unpacksdcmdir -scanonly
            
            import mlfourd.* mlsurfer.*;
            infofile  = fullfile(targdir, SurferDicomConverter.SCAN_INFO);
            if (lexist(infofile, 'file'))
                s = 0; r = cell2str(mlio.TextIO.textfileToCell(fil));
                return
            end
            [s,r] = mlbash(['unpacksdcmdir -src ' dcmdir ' -targ ' targdir ' -scanonly ' infofile]);
        end 
    end % static methods
    
	methods
        function                copyUnpacked(this, unpackPth, fslPth)
            %% COPYUNPACKED into fsl working folder

            p = inputParser;
            addRequired(p, 'unpackPth', @(x) lexist(x,'dir'));
            addOptional(p, 'fslPth',  this.fslPath, @ischar);
            parse(p, unpackPth, fslPth);
            
            import mlsystem.*;
            unpacked = DirTool(p.Results.unpackPth);
            if (~lexist(p.Results.fslPth, 'dir'))
                mkdir(p.Results.fslPth);
            end
            for d = 1:length(unpacked.dns)
                try
                    fslName = this.namingRegistry_.fslName(unpacked.dns{d});
                    series  = DirTool(fullfile(p.Results.unpackPth, unpacked.dns{d}, ''));
                    for s = 1:length(series.dns)
                        seriesNum = DirTool(fullfile(p.Results.unpackPth, unpacked.dns{d}, series.dns{s}, '*.nii'));
                        for n = 1:length(seriesNum.fqfns)
                            copyfile(seriesNum.fqfns{n}, ...
                                     fullfile(p.Results.fslPth, [fslName '_' seriesNum.fns{n}]), 'f');
                        end
                    end
                catch ME
                    handerror(ME);
                end
            end
        end % copyUnpacked
        function structInfo   = dicomQuery(this, dcmPth, targPth)
 			%% DICOMQUERY
            %  Usage:  structInfo = obj.dicomQuery([dicom_path, target_path])
            %          ^ struct-array for session, one struct per series;
            %            fields:  index, seq_type, status, dim1, dim2, dim3, dim4, siemens
            
            import mlsurfer.*;
            if (exist('dcmPth',  'var'))
                this.dicomPath  = dcmPth;  end
            if (exist('targPth', 'var'))
                this.unpackPath = targPth; end            
            infofile = fullfile(this.unpackPath, this.SCAN_INFO);
            if (lexist(infofile, 'file'))
                structInfo = SurferDicomConverter.infoFile2structInfo(infofile);
                return
            end
            structInfo = this.dicoms2structInfo;
 		end % dicomQuery  
        function structInfo   = dicoms2structInfo(this)
            %% DICOM2STRUCTINFO
            
            import mlsurfer.*;
            [~,r]      = SurferDicomConverter.scanDicom(this.dicomPath, this.unpackPath); 
            structInfo = SurferDicomConverter.parseInfoString(r);
        end % dicoms2structInfo 
        function unpackInfo   = structInfo2unpackInfo(this, structInfo)
            %% STRUCTINFO2UNPACKINFO
            %  Usage:  unpackInfo = obj.structInfo2unpackInfo(structInfo)
            %                                      ^ cf. dicomQuery
            %          ^ struct-array for session, one struct per series
            %            fields:   index, seq_tuype, ext, name, dicom_path, target_path
            
            n       = 0;
            unpackInfo = struct([]);
            for s = 1:length(structInfo)
                n = n + 1;
                unpackInfo(n).index       = structInfo(s).index;
                unpackInfo(n).seq_type    = structInfo(s).seq_type;
                unpackInfo(n).ext         = 'nii';
                unpackInfo(n).name        = sprintf('%03u.%s', unpackInfo(n).index, unpackInfo(n).ext);
                unpackInfo(n).dicom_path  = this.dicomPath;
                unpackInfo(n).target_path = this.unpackPath;
            end
            
        end % structInfo2unpackInfo
        function [str, degen] = listUniqueInfo(this)
            import mlfourd.*;
             dc          = DicomSession.createFromPaths(this.dicomPath);
            [str, degen] = dc.listUniqueInfo('seq_type');
        end % listUniqueInfo
    end % methods
    
    %% PROTECTED
      
    methods (Access = 'protected')
 		function this = SurferDicomConverter(mrpth)
 			%% SURFERDICOMCONVERTER 
 			%  Usage:  cvert = SurferDicomConverter(MR_path)
			
            this = this@mlfourd.AbstractDicomConverter(mrpth);
 		end % ctor 
    end 
    
    %% PRIVATE    
    
    methods (Static, Access = 'private')
        
        %% Direct calls to Freesurfer commands        
        function  structInfo  = parseInfoString(info)
            %% PARSEINFOSTRING
            %  Usage:   structInfo = SurferDicomConverter.parseInfoString(info_string)
            %           ^ struct-array for scan session, one struct per scan series;
            %             fields:  index, seq_type, status, dim1, dim2, dim3, dim4, siemens
            %  Uses:  parseInfoCell
            
            EXPRESS    = 'Done scanning \w+\s+\w+\s+\d+\s+\d+\S\d+\S\d+\s+\w+\s+\d+\s+[-]+\s+';
            matchend   = regexp(info, EXPRESS, 'end');
            info       = info(matchend(end)+1:end); % choose last instance only
            matchstart = regexp(info, '\n');
            ca         = cell(1,length(matchstart));
            ca{1}      = info(1:matchstart(1));
            for m = 2:length(matchstart)
                ca{m}  = info(matchstart(m-1)+1:matchstart(m));
            end
            structInfo = mlsurfer.SurferDicomConverter.parseInfoCell(ca);
        end
        function  structInfo  = parseInfoCell(ca)
            %% PARSEINFOCELL
            %  Usage:   structInfo = SurferDicomConverter.parseInfoCell(cell_of_string_lines)
            %                                                    ^ one element per line of text generated by
            %                                                      unpacksdcmdir
            %           ^ struct-array for scan session, one struct per scan series;
            %             fields:  index, seq_type, status, dim1, dim2, dim3, dim4, siemens
            
            assert(~isempty(ca) && ~isempty(ca{1}), 'ca was empty');
            try
                for j = 1:length(ca)
                    [~, info]     = regexp(ca{j},  mlsurfer.SurferDicomConverter.INFO_EXPRESSION, 'tokens', 'names');
                    if (~isempty(info))
                        info.index    = str2double(info.index);
                        info.dim1     = str2double(info.dim1);
                        info.dim2     = str2double(info.dim2);
                        info.dim3     = str2double(info.dim3);
                        info.dim4     = str2double(info.dim4);
                        info.dims     = [info.dim1 info.dim2 info.dim3 info.dim4];
                        structInfo(j) = info; %#ok<AGROW>
                    end
                end
            catch ME
                handexcept(ME);
            end
        end
        function  structInfo  = parseInfoFile(fqfn)
            %% PARSEINFOFILE
            %  Usage:   structInfo = SurferDicomConverter.parseInfoFile(fqfn)
            %           ^ struct-array for scan session, one struct per scan series;
            %             fields:  index, seq_type, status, dim1, dim2, dim3, dim4, siemens
            %  Uses:   parseInfoCell

            structInfo = mlsurfer.SurferDicomConverter.parseInfoCell( ...
                         mlio.TextIO.textfileToCell(fqfn));
        end
    end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

