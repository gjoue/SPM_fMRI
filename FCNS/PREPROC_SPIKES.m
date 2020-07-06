%%-------------------------------------------------------------------------
%%                   5.  tag SIGNAL SPIKES
%%-----------------------------------------------------------------
%% INPUTS: slice-time corrected + realigned functional images uaf*.nii
%% OUTPUTS: 
%%    * spikes_subXX_task_runX_thrXX.mat file with outliers marked per slice

function PREPROC_SPIKES(subjID,task,dirTask,spikeThresh)
    cd(dirTask)
    runs = get_subfolders('.');

    for rr = 1:length(runs)
        run = runs{rr};

        fprintf('%s, %s\n', dirTask, run);
        dirRun = fullfile(dirTask,run);
        cd(dirRun);
        
        img = spm_select('FPList',dirRun,'^uaf.*nii$'); % take ST-corrected
        
        fprintf('**--------- 1. Checking outliers with spm5spike for subj %s, task %s. run %d ---------**\n\n',subjID,task,rr);
    
        [aout,aout_scanfiles,adout,adout_scanfiles] = spm5spike(img,spikeThresh,1,1);
        eval(sprintf('print -djpeg -f1 spikes_%s_%s_%s_thr%d.jpg',subjID,task,run,spikeThresh)) 
        eval(sprintf('save spikes_%s_%s_%s_thr%d adout adout_scanfiles aout aout_scanfiles',subjID,task,run,spikeThresh)) 
    end 
end
