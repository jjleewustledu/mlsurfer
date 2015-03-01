classdef Aparcstats2tableOptions < mlsurfer.SurferOptions 
	%% APARCSTATS2TABLEOPTIONS accumulates options for aparcstats2table which:
    
    % converts a cortical stats file created by recon-all and or
    % mris_anatomical_stats (eg, ?h.aparc.stats) into a table in which
    % each line is a subject and each column is a parcellation. By
    % default, the values are the area of the parcellation in mm2. The
    % first row is a list of the parcellation names. The first column is
    % the subject name. If the measure is thickness then the last column
    % is the mean cortical thickness.
    % 
    % The subjects list can be specified on either of two ways:
    %   1. Specify each subject after a -s flag 
    % 
    %             -s subject1 -s subject2 ... --hemi lh
    %   
    %   2. Specify all subjects after --subjects flag. --subjects does not have
    %      to be the last argument. Eg:
    % 
    %             --subjects subject1 subject2 ... --hemi lh
    % 
    % By default, it looks for the ?h.aparc.stats file based on the
    % Killiany/Desikan parcellation atlas. This can be changed with
    % '--parc parcellation' where parcellation is the parcellation to
    % use. An alternative is aparc.a2009s which was developed by
    % Christophe Destrieux. If this file is not found, it will exit
    % with an error unless --skip in which case it skips this subject
    % and moves on to the next.
    % 
    % By default, the area (mm2) of each parcellation is reported. This can
    % be changed with '--meas measure', where measure can be area, volume
    % (ie, volume of gray matter), thickness, thicknessstd, or meancurv.
    % thicknessstd is the standard dev of thickness across space.
    % 
    % Example:
    %  aparcstats2table --hemi lh --subjects 004 008 --parc aparc.a2009s 
    %     --meas meancurv -t lh.a2009s.meancurv.txt
    % 
    % lh.a2009s.meancurv.txt will have 3 rows: (1) 'header' with the name
    % of each structure, (2) mean curvature for each structure for subject
    % 
    % The --common-parcs flag writes only the ROIs which are common to all 
    % the subjects. Default behavior is it puts 0.0 in the measure of an ROI
    % which is not present in a subject. 
    % 
    % The --parcs-from-file <file> outputs only the parcs specified in the file
    % The order of the parcs in the file is maintained. Specify one parcellation
    % per line.
    % 
    % The --report-rois flag, for each subject, gives what ROIs that are present
    % in atleast one other subject is absent in current subject and also gives 
    % what ROIs are unique to the current subject.
    % 
    % The --transpose flag writes the transpose of the table. 
    % This might be a useful way to see the table when the number of subjects is
    % relatively less than the number of ROIs.
    % 
    % The --delimiter option controls what character comes between the measures
    % in the table. Valid options are 'tab' ( default), 'space', 'comma' and
    % 'semicolon'.
    % 
    % The --skip option skips if it can't find a .stats file. Default behavior is
    % exit the program.
    % 
    % The --parcid-only flag writes only the ROIs name in the 1st row 1st column
    % of the table. Default is hemi_ROI_measure

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	%% 

	properties 
        version %             show program's version number and exit
        subjects %            (REQUIRED) subject1 <subject2 subject3..>
        subjectsfile % =SUBJECTSFILE
        %                     name of the file which has the list of subjects ( one
        %                     subject per line)
        qdec % =QDEC          name of the qdec table which has the column of
        %                     subjects ids (fsid)
        qdec_long % =QDECLONG name of the longitudinal qdec table which has the
        %                     column of tp ids (fsid) and subject templates (fsid-base)
        hemi % =HEMI          (REQUIRED) lh or rh
        tablefile % =OUTPUTFILE
        %                     (REQUIRED) output table file
        parc % =PARC          parcellation.. default is aparc ( alt aparc.a2009s)
        measure % =MEAS
        %                     measure: default is area ( alt volume, thickness,
        %                     thicknessstd, meancurv, gauscurv, foldind, curvind)
        delimiter % =DELIMITER
        %                     delimiter between measures in the table. default is
        %                     tab (alt comma, space, semicolon )
        skip %                if a subject does not have input, skip it
        parcid_only %         do not pre/append hemi/meas to parcellation name
        common_parcs %        output only the common parcellations of all the subjects given
        parcs_from_file % =PARCSFILE
        %                     filename: output parcellations specified in the file
        report_rois %         print ROIs information for each subject
        transpose %           transpose the table ( default is subjects in rows and ROIs in cols)
        debug %               increase verbosity
    end 
    
	methods 
        function s = updateOptionsString(this, s, fldname, val)
            if (islogical(val))
                val = ' '; end
            if (isnumeric(val))
                val = num2str(val); end
            if (lstrfind(this.needsEq, fldname))                
                s = sprintf('%s --%s=%s', s, this.underscores2dashes(fldname), char(val));
                return
            end
            s = sprintf('%s --%s %s', s, this.underscores2dashes(fldname), char(val));
        end
    end 
    
    properties (Access = 'private')
        needsEq = { '' }
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

