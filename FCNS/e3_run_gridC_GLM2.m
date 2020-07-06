function e3_run_gridC_GLM2(do,cfg)

    if do.TESTING
        for ss = 1: length(do.Ss)
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);
            
            fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));
           
            GCcfg = e3_cfg_GridCAT_gen(cfg); % common to both GLM1 and GLM2
 
            e3_GridCAT_GLM2(subjID, GCcfg, cfg);
        end
    else
        subjlist = do.Ss; % to avoid parfor broadcast var warning
        parfor ss = 1: length(subjlist)
            subj   = subjlist(ss);
            subjID = sprintf('sub%03d',subj);
            fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));
            
            GCcfg = e3_cfg_GridCAT_gen(cfg); % common to both GLM1 and GLM2
 
            e3_GridCAT_GLM2(subjID, GCcfg, cfg);
        end
    end
end