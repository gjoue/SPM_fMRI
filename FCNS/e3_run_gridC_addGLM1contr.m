function e3_run_gridC_addGLM1contr(do,cfg)
    fprintf('ADDING sanity check contrasts to GLM1 for ...\n');
    
    GCcfg = e3_cfg_GridCAT_gen(cfg); 
                
    if do.TESTING    
        for ss = 1: length(do.Ss)            
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);
            fprintf('..... subject %d [%s] ......\n',subj, datetime('now'));

            e3_GridCat_GLM1_addCheckContr(subjID, GCcfg, cfg);

        end
    else
        parfor ss = 1: length(do.Ss)
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);
            fprintf('..... subject %d [%s] ......\n',subj, datetime('now'));

            e3_GridCat_GLM1_addCheckContr(subjID, GCcfg, cfg);

        end
    end
end