function spikeMvR = join_spikesNmvmtParams(spikeR, realignTxt, cfg)
% join realignment parameters (from 6-col text file output by SPM)
% with spikes detected with Rik Henson's script and put into the R
% structure expected by SPM's spm_run_fmri_spec.m, as output by
% get_spikes2SPMFormat.m
%
% SPM multi_reg will only take file names (MATLAB mat of a structure with
% fields "R" and "names", or text file of a matrix), which means we would
% have to save the data here to a file and pass the filename. 
% Rather than doing that, as we have the spikes and realignment parameters
% already saved as separate files, we can pass to sess.regress -- 
% format required:
%     sess.regress(r).name
%     sess.regress(r).val
    mvmtParams     = [];
    mvmtLabs       = '';
    spikeMvR       = [];
    
    if cfg.GLM.use.realignParams
        mvmtParams = load(realignTxt);    
        mvmtLabs   = {'R.x' 'R.y' 'R.z' 'R.pit' 'R.rol' 'R.yaw'};
    end
    
    if isempty(spikeR)
        spikeMvR.R      = mvmtParams;
        spikeMvR.names  = mvmtLabs;
    else
        spikeMvR.R     = [spikeR.R mvmtParams];
        spikeMvR.names = [spikeR.names, mvmtLabs];
    end
end