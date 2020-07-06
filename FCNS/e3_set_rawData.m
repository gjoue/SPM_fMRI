    %function GCcfg = e3_set_rawData(do,cfg,GCcfg,subjID)
    function GCcfg = e3_set_rawData(cfg, GCcfg, subjID)
        sdirs = e3_set_sdirs(cfg.dirs.sub,subjID); 
 
        runs  = get_subfolders(sdirs.gridC);
        nruns = length(runs);
        
        %ons_ev = cell(nruns,1);
        %ons_ph = cell(nruns,1);
        if GCcfg.GLM.nativeSpace
            GCcfg.GLM.mask = spm_select('FPList',sdirs.T1, GCcfg.GLM.mask);
        end     
                
        for run = 1:nruns
            dirRun = fullfile(sdirs.gridC, sprintf('run%d', run));
            cd(dirRun);
            
            if GCcfg.GLM.nativeSpace
                EPIprefix = 'su2ua';    % take realigned + ST-corrected + SDC'ed
            else
                EPIprefix = '^swu2ua';  % ....+ warped to group template
            end

            switch GCcfg.EPIres
                case 'T1'
                    EPIsuffix = cfg.files.EPI_T1res;
                case 'orig'
                    EPIsuffix = '';
            end

            
            EPIs = spm_select('FPList',dirRun,sprintf('^%sfPR.*%s.nii$',EPIprefix,EPIsuffix)); 

            GCcfg.rawData.run(run).functionalScans           = cellstr(EPIs);
            
            %% spikes in signal as nuisance regressors
            
            %% realignment parameters as nuisance regressors
            GCcfg.rawData.run(run).additionalRegressors_file      = spm_select('FPList',dirRun,'^rp_.*txt$');
            GCcfg.rawData.run(run).additionalRegressors_spikeFile = spm_select('FPList',dirRun,'spikes.mat'); 

            
            GCcfg.rawData.run(run).eventTable_file = fullfile(GCcfg.dirs.gridC.onsets, sprintf('e3_gridC.%s.events%s.run%d.txt', subjID, GCcfg.suffix.spdThr, run));
      
        end
end