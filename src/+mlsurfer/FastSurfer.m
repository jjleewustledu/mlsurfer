classdef FastSurfer
    %% https://deep-mi.org/research/fastsurfer/#:~:text=FastSurfer%20%2D%20a%20fast%20and%20accurate,of%20structural%20human%20brain%20MRIs.
    %  
    %  Created 02-Nov-2022 01:40:11 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlsurfer/src/+mlsurfer.
    %  Developed on Matlab 9.13.0.2080170 (R2022b) Update 1 for MACI64.  Copyright 2022 John J. Lee.
    
    properties
        sif_filename
    end

    properties (Dependent)
        data_path
        license_fqfn
        license_path
        output_filename
        output_fqfn
        output_path
        subject
        t1w
    end

    methods

        %% GET
        
        function g = get.data_path(this)
            g = this.t1w.filepath;
        end
        function g = get.license_fqfn(this)
            g = glob(fullfile(this.license_path, 'license*.txt'));
            assert(~isempty(g))
            g = g{1};
        end
        function g = get.license_path(this)
            g = this.license_path_;
        end
        function g = get.output_filename(this)
            g = this.output_filename_;
        end
        function g = get.output_fqfn(this)
            g = fullfile(this.output_path, this.output_filename);
        end
        function g = get.output_path(this)
            g = myfileparts(this.data_path);
        end
        function g = get.subject(this)
            fp = this.t1w.fileprefix;
            re = regexp(fp, '(?<sub>sub-\S+)_ses-\S+', 'names');
            g = re.sub;
        end
        function g = get.t1w(this)
            g = this.t1w_;
        end

        %%

        function this = FastSurfer(t1w, opts)
            %% FASTSURFER 
            %  Args:
            %     t1w : understood by mlfourd.ImagingContext2
            %     opts.license_path {mustBeFolder} = pwd : adjusted by ensure_license_path()
            %     opts.output_filename {mustBeTextScalar} = 'aparc.DKTatlas+aseg.deep.nii.gz'
            %     opts.use_gpu logical = true

            arguments
                t1w {mustBeFile}
                opts.license_path {mustBeFolder} = ''
                opts.output_filename {mustBeTextScalar} = 'aparc.DKTatlas+aseg.deep.nii.gz'
                opts.use_gpu logical = true
            end            

            this.t1w_ = mlfourd.ImagingContext2(t1w);
            this.license_path_ = this.ensure_license_path(opts.license_path);
            this.output_filename_ = opts.output_filename;
            if opts.use_gpu
                this.sif_filename = 'fastsurfer-gpu.sif';
            else
                this.sif_filename = 'fastsurfer-cpu.sif';
            end
        end

        function [s,r] = singularity_exec(this, opts)
            %% FastSurfer Singularity Image Usage
            %  See also https://github.com/Deep-MI/FastSurfer/tree/stable/Singularity
            %
            % After building the Singularity image, you need to register at the FreeSurfer website 
            % (https://surfer.nmr.mgh.harvard.edu/registration.html) to acquire a valid license (for free) - just as 
            % when using Docker. This license needs to be passed to the script via the --fs_license flag.
            % 
            % To run FastSurfer on a given subject using the Singularity image with GPU access, execute the following 
            % command:
            % 
            % singularity exec --nv -B /home/user/my_mri_data:/data \
            %                       -B /home/user/my_fastsurfer_analysis:/output \
            %                       -B /home/user/my_fs_license_dir:/fs \
            %                        /home/user/fastsurfer-gpu.sif \
            %                        /fastsurfer/run_fastsurfer.sh \
            %                       --fs_license /fs/license.txt \
            %                       --t1 /data/subject2/orig.mgz \
            %                       --sid subject2 --sd /output \
            %                       --parallel
            %
            % The --nv flag is used to access GPU resources. This should be excluded if you intend to use the CPU version of FastSurfer
            % The -B commands mount your data, output, and directory with the FreeSurfer license file into the Singularity container. Inside the container these are visible under the name following the colon (in this case /data, /output, and /fs).
            % The fs_license points to your FreeSurfer license which needs to be available on your computer in the my_fs_license_dir that was mapped above.
            % Note, that the paths following --fs_license, --t1, and --sd are inside the container, not global paths on your system, so they should point to the places where you mapped these paths above with the -B arguments.
            % A directory with the name as specified in --sid (here subject2) will be created in the output directory. So in this example output will be written to /home/user/my_fastsurfer_analysis/subject2/ . Make sure the output directory is empty, to avoid overwriting existing files.
            % You can run the Singularity equivalent of CPU-Docker by building a Singularity image from the CPU-Docker image and excluding the --nv argument in your Singularity exec command.            
            %
            % Args:
            %    this mlsurfer.FastSurfer
            %    opts.output_fqfn {mustBeTextScalar} = this.output_fqfn
            
            arguments
                this mlsurfer.FastSurfer
                opts.output_fqfn {mustBeTextScalar} = this.output_fqfn
            end
            if isfile(opts.output_fqfn)
                return
            end

            sif = fullfile(getenv('SINGULARITY_HOME'), this.sif_filename);
            cmd = sprintf(strcat('singularity exec ', ...
                '-B %s:/data ', ...
                '-B %s:/output ', ...
                '-B %s:/fs ', ...
                '%s /fastsurfer/run_fastsurfer.sh ', ...
                '--fs_license %s --t1 %s --sid %s --sd /output --parallel'), ...
                this.data_path, ...
                this.output_path, ...
                this.license_path, ...
                sif, ...
                this.license_fqfn, this.t1w.fqfn, this.subject);
            [s,r] = mlbash(cmd);

            jsonrecode(opts.output_fqfn, struct(stackstr(2)), opts.output_fqfn);
        end
    end

    methods (Static)
        function pth = ensure_license_path(pth)
            try
                glic = glob(fullfile(pth, 'license*.txt'));
                assert(~isempty(glic))
            catch
                try
                    pth = getenv('FREESURFER_HOME');
                    glic = glob(fullfile(pth, 'license*.txt'));
                    assert(~isempty(glic))
                catch
                    pth = fullfile(getenv('HOME'), '.local', 'freesurfer');
                    glic = glob(fullfile(pth, 'license*.txt'));
                    assert(~isempty(glic))
                end
            end
        end
        function propcluster_tiny()
            c = parcluster;
            c.AdditionalProperties.EmailAddress = '';
            c.AdditionalProperties.EnableDebug = 1;
            c.AdditionalProperties.GpusPerNode = 2;
            c.AdditionalProperties.MemUsage = '10000'; % in MB; deepmrseg requires 10 GB
            c.AdditionalProperties.Node = '';
            %c.AdditionalProperties.Partition = 'test';
            c.AdditionalProperties.WallTime = '4:00:00'; % 24 h
            c.saveProfile
            disp(c.AdditionalProperties)
        end
        function propcluster()
            c = parcluster;
            c.AdditionalProperties.EmailAddress = '';
            c.AdditionalProperties.EnableDebug = 1;
            c.AdditionalProperties.GpusPerNode = 2;
            c.AdditionalProperties.MemUsage = '10000'; % in MB; deepmrseg requires 10 GB
            c.AdditionalProperties.Node = '';
            c.AdditionalProperties.Partition = '';
            c.AdditionalProperties.WallTime = '24:00:00'; % 24 h
            c.saveProfile
            disp(c.AdditionalProperties)
        end
        function [j,c] = parcluster_tiny()
            %% #PARCLUSTER
            %  See also https://sites.wustl.edu/chpc/resources/software/matlab_parallel_server/
            %  --------------------------------------------------------------
            
            c = parcluster;
            disp(c.AdditionalProperties)

            globbing_file = fullfile(getenv('SINGULARITY_HOME'), 'ADNI', 'bids', 'derivatives', 'globbed.mat');
            if ~isfile(globbing_file)
                j = c.batch(@mladni.FDG.batch_globbed, 1, {}, ...
                    'CurrentFolder', '.', 'AutoAddClientPath', false);
                return
            end            
            ld = load(globbing_file);
            globbed = ld.globbed{1};
            globbed = globbed(1:3);
            j = c.batch(@mladni.FDG.batch_renorm_balanced, 1, {'globbed', globbed}, 'Pool', 3, ...
                    'CurrentFolder', '.', 'AutoAddClientPath', false);      
        end
        function [j,c] = parcluster()
            %% #PARCLUSTER
            %  See also https://sites.wustl.edu/chpc/resources/software/matlab_parallel_server/
            %  --------------------------------------------------------------
            %  Use for call_resolved(), batch_revisit_pve1()
            
            c = parcluster;
            disp(c.AdditionalProperties)
            
            globbing_file = fullfile(getenv('SINGULARITY_HOME'), 'ADNI', 'bids', 'derivatives', 'globbed.mat');
            if ~isfile(globbing_file)
                j = c.batch(@mladni.FDG.batch_globbed, 1, {}, ...
                    'CurrentFolder', '.', 'AutoAddClientPath', false);
                return
            end            
            ld = load(globbing_file);
            for ji = 1:length(ld.globbed)
                j{ji} = c.batch(@mladni.FDG.batch_renorm_balanced, 1, {'globbed', ld.globbed{ji}}, 'Pool', 31, ...
                    'CurrentFolder', '.', 'AutoAddClientPath', false);  %#ok<AGROW>
            end
        end
    end

    %% PRIVATE

    properties (Access = private)
        license_path_
        output_filename_
        t1w_
    end

    methods (Access = private)
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
