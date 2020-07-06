function e3_GridCAT_GLM1(subjID, GCcfg,cfg)

    GCcfg = e3_cfg_GridCAT_GLM1(GCcfg);

    
    for ff=GCcfg.GLM.rotatefolds
        % x-fold symmetry value that the model is testing for
        GCcfg.GLM.xFoldSymmetry       = ff;

        % Specify data directory for this GLM
        % The directory will be created if it does not exist
        GCcfg.GLM.dataDir = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg);

        % Specify GLM1 using the current configuration (cfg)
        specifyGLM(GCcfg);

        % Estimate GLM1 using the current configuration (cfg)
        estimateGLM(GCcfg);
    end
end