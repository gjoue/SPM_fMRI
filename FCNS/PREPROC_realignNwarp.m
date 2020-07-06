%%-------------------------------------------------------------------------
%%                   3.  REALIGN n WARP
%%-----------------------------------------------------------------
%%
%% realign&unwarp tries to estimate the cross-terms between motion 
%% and (B0 field inhomogeneity induced) geometrical distortion in 
%% the EPI images. You can enter a field map as a zeroth-order 
%% estimate into the algorithm, i.e. the field inhomogeneities in 
%% the absence of motion. If motion amplitudes and most importantly 
%% the angle relative to the z-axis (magnet axis) are small, then 
%% this method will not be able to estimate cross-terms because 
%% they are very small anyways.

%% Jesper Andersson:
%% Unwarp is an attempt to properly model *one* of the causes of 
%% residual (after bog-standard realignment) movement related 
%% variance. Because of the quite restricted model it will 
%% potentially remove variance originating from this source 
%% (distortion-by-movement interaction) while leaving "true" 
%% activations intact, regardless of how correlated to the movement 
%% they are.
%% The problem with unwarp is precisely that it addresses only 
%% *one* of the sources of residual movement related variance. 
%% There are other sources as well, such as
%%     i) Dropout-by-movement interaction
%%     ii) Spin-history effects
%%     iii) Movement within acquisiton of a volume.
%% and these are still there after you have applied Unwarp. 
%% Hence, it is not terribly surprising you still see 
%% movement-related effects. Ideally we will some day have a method 
%% that models all these effects simultaneously, but today there is 
%% no such creatute. Unwarp addresses one point, and I believe there 
%% are work being done by the fMRIB group to address iii (though I 
%% don't know if they have yet released anything).
%%  As a rule of thumb;
%% if you plan to include motion parameters in your stats model 
%% anyway, there isn't much point in applying Unwarp before (not 
%% much harm either, apart from execution time).
%% If we look at the three alternatives 
%%    i. Realignment only, 
%%    ii. Realignment & Unwarp, 
%%    iii. Realignment & Inclusion of MP 
%% they rank in terms of specificity
%% 1. Realignment & Inclusion of MP, 2. Realignment & Unwarp, 3.
%% Realignment only
%% and in terms of sensitivity
%% 1. Tie between Realignment & Unwarp and Realignment only, 
%% 2. Realignment & Inclusion of MP
%%-----------------------------------------------------------------
%% INPUTS: 
%%   slice-time corrected EPIs (af*.nii)
%% OUTPUTS:
%%   1. rp*.txt         motion parameters
%%   2. u*__.nii        realigned EPIs
%%   3. meanu*_.nii     mean of EPIs
%%   4. *_uw.mat
% function jobs = PREPROC_realignNwarp(dirTask)
%     jobs = [];
%     filesAllRuns = [];
%     cd(dirTask)
%     runs = get_subfolders('.');
% 
%     for rr = 1:length(runs)
%         run = runs{rr};
% 
%         fprintf('%s, %s\n', dirTask, run);
%         dirRun = fullfile(dirTask,run);
%             
%         img = spm_select('FPList',dirRun,'^af.*nii$'); % take ST-corrected
%         jobs{1}.spm.spatial.realignunwarp.data(rr).scans = cellstr(img);
%         jobs{1}.spm.spatial.realignunwarp.data(rr).pmscan = '';
%     end  
%     
%     %%
%     
%     jobs{1}.spm.spatial.realignunwarp.eoptions.quality    = 0.9;
%     jobs{1}.spm.spatial.realignunwarp.eoptions.sep        = 4;
%     jobs{1}.spm.spatial.realignunwarp.eoptions.fwhm       = 5;
%     jobs{1}.spm.spatial.realignunwarp.eoptions.rtm        = 0;
%     jobs{1}.spm.spatial.realignunwarp.eoptions.einterp    = 2;
%     jobs{1}.spm.spatial.realignunwarp.eoptions.ewrap      = [0 0 0];
%     jobs{1}.spm.spatial.realignunwarp.eoptions.weight     = '';
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.basfcn   = [12 12];
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.lambda   = 100000;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.jm       = 0;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.fot      = [4 5];
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.sot      = [];
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm   = 4;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.rem      = 1;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.noi      = 5;
%     jobs{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
%     jobs{1}.spm.spatial.realignunwarp.uwroptions.uwwhich  = [2 1];
%     jobs{1}.spm.spatial.realignunwarp.uwroptions.rinterp  = 4;
%     jobs{1}.spm.spatial.realignunwarp.uwroptions.wrap     = [0 0 0];
%     jobs{1}.spm.spatial.realignunwarp.uwroptions.mask     = 1;
%     jobs{1}.spm.spatial.realignunwarp.uwroptions.prefix   = 'u';
% end
function jobs = PREPROC_realignNwarp(allTasks,sdirs)
    jobs = [];
    filesAllRuns = [];
    ir = 0;
    
    for tt = 1:length(allTasks)
        task    = allTasks{tt};
        dirTask = sdirs.(task);
        runs = get_subfolders(dirTask);
    
        for rr = 1:length(runs)
            run = runs{rr};
            ir  = ir + 1; 
            fprintf('%s, %s\n', dirTask, run);
            dirRun = fullfile(dirTask,run);
            cd(dirRun);
            system('gunzip af*.nii.gz');
            img = spm_select('FPList',dirRun,'^af.*nii$'); % take ST-corrected
            jobs{1}.spm.spatial.realignunwarp.data(ir).scans = cellstr(img);
            jobs{1}.spm.spatial.realignunwarp.data(ir).pmscan = '';
        end  
    end
    %%
    
    jobs{1}.spm.spatial.realignunwarp.eoptions.quality    = 0.9;
    jobs{1}.spm.spatial.realignunwarp.eoptions.sep        = 4;
    jobs{1}.spm.spatial.realignunwarp.eoptions.fwhm       = 5;
    jobs{1}.spm.spatial.realignunwarp.eoptions.rtm        = 0;
    jobs{1}.spm.spatial.realignunwarp.eoptions.einterp    = 2;
    jobs{1}.spm.spatial.realignunwarp.eoptions.ewrap      = [0 0 0];
    jobs{1}.spm.spatial.realignunwarp.eoptions.weight     = '';
    jobs{1}.spm.spatial.realignunwarp.uweoptions.basfcn   = [12 12];
    jobs{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.lambda   = 100000;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.jm       = 0;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.fot      = [4 5];
    jobs{1}.spm.spatial.realignunwarp.uweoptions.sot      = [];
    jobs{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm   = 4;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.rem      = 1;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.noi      = 5;
    jobs{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    jobs{1}.spm.spatial.realignunwarp.uwroptions.uwwhich  = [2 1];
    jobs{1}.spm.spatial.realignunwarp.uwroptions.rinterp  = 4;
    jobs{1}.spm.spatial.realignunwarp.uwroptions.wrap     = [0 0 0];
    jobs{1}.spm.spatial.realignunwarp.uwroptions.mask     = 1;
    jobs{1}.spm.spatial.realignunwarp.uwroptions.prefix   = 'u';
end

