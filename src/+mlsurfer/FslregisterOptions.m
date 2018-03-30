classdef FslregisterOptions < mlsurfer.SurferOptions 
	%% FSLREGISTEROPTIONS   
    %  USAGE: fslregister -s subjid --mov volid --reg register.dat

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 

        %% Required Arguments
        
        s % subjid
        mov % volid  : input/movable volume
        reg % register.dat

        %% Optional Arguments

        fslmat % fsl.mat     : output registration matrix in fsl format
        initfslmat % matfile : supply initial fsl matrix file (implies --noinitxfm)
        noinitxfm %          : do not initialize based on header goemetry
        niters % niters      : iterate niter times (default is 1)

        dof  % dof       : FLIRT DOF (default is 6)
        bins % bins      : FLIRT bins (default is 256)
        cost % cost      : FLIRT cost (default is corratio)
        maxangle % angle : FLIRT max search angle (default is 90)
        no_new_schedule 

        no_allow_swap  % : do not allow swap dim of positive determinant input volumes
        no_trans       % : do not do a translation-only registration prior to full 

        betmov    %   : perform brain extration on mov
        betfvalue % f : f value for bet, 0.1 default (passed with -f to bet)
        betfunc   %   : betfunc on mov instead of simply bet
        betref    %   : brain extration on ref (usually not needed)

        frame % frameno         : reg to frameno (default 0=1st)
        mid_frame  %            : use middle frame
        fsvol % volid           : use FreeSurfer volid (default brainmask)
        template_out % template : save template (good with --frame)

        out % outvol : have flirt reslice mov to targ
        verbose % N  : flirt verbosity level
        tmp % tmpdir : use tmpdir (implies --nocleanup)
        nocleanup  % : do not delete temporary files
        nolog %      : do produce a log file
        version %    : print version and exit
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

