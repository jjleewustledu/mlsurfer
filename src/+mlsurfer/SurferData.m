classdef SurferData 
	%% SURFERDATA contains and manages cortical thickness and surface data.
    %  It was written for rapid-prototyping of freesurfer analysis.  
    
	%  Version $Revision: 2370 $ was created $Date: 2013-03-05 06:42:34 -0600 (Tue, 05 Mar 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-03-05 06:42:34 -0600 (Tue, 05 Mar 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlsurfer/src/+mlsurfer/trunk/SurferData.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: SurferData.m 2370 2013-03-05 12:42:34Z jjlee $ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties (Constant)
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
        
        HEMIS      = {'lh' 'rh'};
        ATLASES    = {'.aparc.stats' '.aparc.a2009s.stats'};
        DESIKAN    = {'lateraloccipital'};
        DESTRIEUX  = {'G_front_inf-Opercular' 'G_precentral' 'G_postcentral' 'S_cingul-Marginalis' 'S_circular_insula_ant' ...
                      'S_circular_insula_inf'};
        DATA_START =  '# ColHeaders StructName NumVert SurfArea GrayVol ThickAvg ThickStd MeanCurv GausCurv FoldInd CurvInd';
        EXPRESSION = ['(?<segname>[\w\S]*)\s*' ...
                      '(?<numvert>\d*)\s*(?<surfarea>\d*)\s*(?<grayvol>\d*)\s*' ...
                      '(?<thickavg>\d+\.?\d*)\s*(?<thickstd>\d+\.?\d*)\s*(?<meancurv>\d+\.?\d*)\s*(?<gausscurv>\d+\.?\d*)\s*' ...
                      '(?<foldind>\d*)\s*(?<curvind>\d*)'];
                    % segname, numvert, surfarea, grayvol, thickavg, thickstd, meancurv, gausscurv, foldind, curvind
    end
    
    properties (SetAccess = 'protected') 
        pwd0
        subjid
    end

	methods (Static)
 		% N.B. (Static, Abstract, Access=', Hidden, Sealed) 
        
        function sd       = processAllJames(subjids)
            import mlsurfer.*;
            if (ischar(subjids)); [~,subjids] = dir2cell(subjids); end
            
            jamesfile = fullfile('.', 'allsubjects_forjames.csv');   
            jamfid    = fopen(jamesfile, 'a');
            for s = 1:length(subjids) 
                sd = SurferData.process4James(jamfid, subjids{s});
            end            
            fclose(jamfid);
        end % static processAllJames
        function sd       = process4James(jamfid, subjid)
            import mlsurfer.*;
            sd   = SurferData(pwd, subjid);
            cd(fullfile(subjid, 'stats', ''));
            
            fields = {'grayvol' 'thickavg'};
            pca = struct(fields{1}, [], fields{2}, []);
            pca = sd.averageOverSegnames(pca, fields, sd.DESIKAN);
            mca = struct(fields{1}, [], fields{2}, []);
            mca = sd.averageOverSegnames(mca, fields, sd.DESTRIEUX);
            
            try
                fprintf(jamfid, '%s,, %g, %g,, %g, %g,, %g, %g,, %g, %g\n', ...
                        subjid, ...
                        mca.grayvol(1), mca.thickavg(1), pca.grayvol(1), pca.thickavg(1), ...
                        mca.grayvol(2), mca.thickavg(2), pca.grayvol(2), pca.thickavg(2));
            catch ME
                handerror(ME);
            end
            cd(sd.pwd0);
        end % static process4James 
        function thickavg = processMcaThickAvg(subjsdir, subjid)            
            import mlsurfer.*;
            sd = SurferData(subjsdir, subjid);
            cd(fullfile(subjsdir, subjid, 'stats', ''));
            fields = {'grayvol' 'thickavg'};
            mca = struct(fields{1}, [], fields{2}, []);
            mca = sd.averageOverSegnames(mca, fields, sd.DESTRIEUX);
            thickavg = [mca.thickavg(1) mca.thickavg(2)];
        end % static proceesMcaThickAvg
        function sd       = processHemisphere(jamfid, subjid)
            import mlsurfer.*;
            disp('KLUDGE:  set hemispheres in SurferData.HEMIS');
            sd   = SurferData(pwd, subjid);
            cd(fullfile(subjid, 'stats', ''));
            
            fields = {'grayvol' 'thickavg'};
            pca = struct(fields{1}, [], fields{2}, []);
            pca = sd.averageOverSegnames(pca, fields, sd.DESIKAN);
            mca = struct(fields{1}, [], fields{2}, []);
            mca = sd.averageOverSegnames(mca, fields, sd.DESTRIEUX);
            
            try
                fprintf(jamfid, '%s,, %g, %g,, %g, %g\n', ...
                        subjid, ...
                        mca.grayvol(1), mca.thickavg(1), pca.grayvol(1), pca.thickavg(1));
            catch ME
                handerror(ME);
            end
            cd(sd.pwd0);
        end % static processHemisphere 
        function names    = collectData(contents)
            import mlsurfer.*;
            contents2 = {[]};
            for c = 1:length(contents)
                if (strfind(contents{c}, SurferData.DATA_START))
                    contents2 = cell(1,length(contents)-c);
                    for c2 = c+1:length(contents)
                        contents2{c2-c} = contents{c2};
                    end
                    break
                end
            end
            try
                names = regexpi(contents2, SurferData.EXPRESSION, 'names');
                for n = 1:length(names)
                    fields = fieldnames(names{n});
                    for f = 1:length(fields)
                        if (~strcmp(fields{f}, 'segname'))
                            names{n}.(fields{f}) = str2double(names{n}.(fields{f}));
                        end
                    end
                end                    
            catch ME2
                handexcept(ME2);
            end
        end % static collectData
 	end % static methods
    
    methods
        function roi = averageOverSegnames(this, roi, fields, strnames)
            for f = 1:length(fields)
                for p = 1:length(strnames)
                    roi.(fields{f})  = [roi.(fields{f})  this.(fields{f})(strnames{p})];
                end
                for h = 1:length(this.HEMIS)
                    roi.(fields{f})(h) = mean(roi.(fields{f})(h,:));
                end
            end
        end % averageOverSegnames
        function fns = atlasFqfns(this, hemis)
            fns = cell(1, length(this.ATLASES));
            for a = 1:length(this.ATLASES) %#ok<*FORFLG>
                fns{a} = fullfile(this.pwd0, this.subjid, 'stats', [hemis this.ATLASES{a}]);
                assert(2 == exist(fns{a}, 'file'), 'SurferData.atlasFqfns could not find %s', fns{a});
            end
        end % atlasFqfns
        function sn  = segname(this, structn)
            lhsn = this.lhSegnameMap(structn);
            rhsn = this.rhSegnameMap(structn);
              sn = {lhsn; rhsn};
        end
        function val = numvert(  this, structn)
            
            %% NUMVERT
            %  Usage:  [lhnv rhnv] = obj.numvert(segname)
            lhval = this.lhNumvertMap(structn);
            rhval = this.rhNumvertMap(structn);
              val = [lhval; rhval];
        end
        function val = surfarea( this, structn)
            lhval = this.lhSurfareaMap(structn);
            rhval = this.rhSurfareaMap(structn);
              val = [lhval; rhval];
        end
        function val = grayvol(  this, structn)
            lhval = this.lhGrayvolMap(structn);
            rhval = this.rhGrayvolMap(structn);
              val = [lhval; rhval];
        end
        function val = thickavg( this, structn)
            lhval = this.lhThickavgMap(structn);
            rhval = this.rhThickavgMap(structn);
              val = [lhval; rhval];
        end
        function val = thickstd( this, structn)
            lhval = this.lhThickstdMap(structn);
            rhval = this.rhThickstdMap(structn);
              val = [lhval; rhval];
        end
        function val = meancurv( this, structn)
            lhval = this.lhMeancurvMap(structn);
            rhval = this.rhMeancurvMap(structn);
              val = [lhval; rhval];
        end
        function val = gausscurv(this, structn)
            lhval = this.lhGausscurvMap(structn);
            rhval = this.rhGausscurvMap(structn);
              val = [lhval; rhval];
        end
        function val = foldind(  this, structn)
            lhval = this.lhFoldindMap(structn);
            rhval = this.rhFoldindMap(structn);
              val = [lhval; rhval];
        end
        function val = curvind(  this, structn)
            lhval = this.lhCurvindMap(structn);
            rhval = this.rhCurvindMap(structn);
              val = [lhval; rhval];
        end
    end
     
    %% PROTECTED
    
    properties (Access = 'protected')
        
        % containers.Maps keyed by segnames from atlases
        lhSegnameMap
        lhNumvertMap 
        lhSurfareaMap 
        lhGrayvolMap 
        lhThickavgMap 
        lhThickstdMap 
        lhMeancurvMap 
        lhGausscurvMap 
        lhFoldindMap 
        lhCurvindMap
        rhSegnameMap
        rhNumvertMap 
        rhSurfareaMap 
        rhGrayvolMap 
        rhThickavgMap 
        rhThickstdMap 
        rhMeancurvMap 
        rhGausscurvMap 
        rhFoldindMap 
        rhCurvindMap
    end % protected properties
    
    methods (Static, Access = 'protected') 
        function avgmap   = averageArrayMap(arrmap)
            avgmap  = containers.Map;
            arrkeys = arrmap.keys;
            for k = 1:length(arrkeys)
                avgmap(arrkeys{k}) = mean(cell2mat(arrmap(arrkeys{k})));
            end
        end % averageArrayMap
    end % protected static methods
    
	methods (Access = 'protected')

        function this = populateMaps(this, hemis, content)
            
            import mlsurfer.*;
            names = SurferData.collectData(content); 
            for n = 1:length(names)
                fields = fieldnames(names{n});
                for f = 1:length(fields)                       
                    this = this.appendToMap(hemis, fields{f}, names{n});
                end
            end
        end % protected populateMaps
        function this = appendToMap(this, hemis, field, name)
            this.(this.mapReference(hemis, field))(name.segname) = name.(field);
        end % protected appendToMap
        function ref  = mapReference(~, hemis, field)
            ref = [lower(hemis) upper(field(1)) lower(field(2:end)) 'Map'];
        end % protected mapReference
 		function this = SurferData(pwdtop, sid)
            
 			%% SURFERDATA (ctor) 
 			%  Usage:   processed_data = SurferData(specifiers)
            import mlsurfer.*;
			if (~exist('pwdtop', 'var')); pwdtop = pwd; end
            assert(1 == exist('sid',  'var')); 
            this.pwd0   = pwdtop;
            this.subjid = sid;
            
            this.lhSegnameMap   = containers.Map;
            this.lhNumvertMap   = containers.Map;
            this.lhSurfareaMap  = containers.Map;
            this.lhGrayvolMap   = containers.Map;
            this.lhThickavgMap  = containers.Map;
            this.lhThickstdMap  = containers.Map;
            this.lhMeancurvMap  = containers.Map;
            this.lhGausscurvMap = containers.Map;
            this.lhFoldindMap   = containers.Map;
            this.lhCurvindMap   = containers.Map;
            this.rhSegnameMap   = containers.Map;
            this.rhNumvertMap   = containers.Map;
            this.rhSurfareaMap  = containers.Map;
            this.rhGrayvolMap   = containers.Map;
            this.rhThickavgMap  = containers.Map;
            this.rhThickstdMap  = containers.Map;
            this.rhMeancurvMap  = containers.Map;
            this.rhGausscurvMap = containers.Map;
            this.rhFoldindMap   = containers.Map;
            this.rhCurvindMap   = containers.Map;
        
            for h = 1:length(this.HEMIS)
                fnames = this.atlasFqfns(this.HEMIS{h});
                for a = 1:length(fnames)
                    this = this.populateMaps(this.HEMIS{h}, ...
                                        readtext(fnames{a}));
                end
            end
 		end % SurferData (ctor) 
 	end % protected methods
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 
