function e3_run_gridC_GLM1(do,cfg)
    
    if do.TESTING    
        for ss = 1: length(do.Ss)
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);
            fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));

            GCcfg = e3_cfg_GridCAT_gen(cfg);
            %GCcfg = e3_set_rawData(do, cfg, GCcfg, subjID);      
            GCcfg = e3_set_rawData(cfg, GCcfg, subjID);      
            
            e3_GridCAT_GLM1(subjID, GCcfg, cfg);

        end
    else
        parfor ss = 1: length(do.Ss)
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);
            fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));

            GCcfg = e3_cfg_GridCAT_gen(cfg);
            GCcfg = e3_set_rawData(cfg, GCcfg, subjID);      

            e3_GridCAT_GLM1(subjID, GCcfg, cfg);
        end
    end
end