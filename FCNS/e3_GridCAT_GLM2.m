function e3_GridCAT_GLM2(subjID,GCcfg,cfg)

    GCcfg = e3_cfg_GridCAT_GLM2(cfg,GCcfg); 
    
    for ff=GCcfg.GLM.rotatefolds
        % x-fold symmetry value that the model is testing for
        GCcfg.GLM.xFoldSymmetry   = ff;
        GCcfg                     = e3_set_rawData(cfg, GCcfg, subjID);  
        GCcfg.GLM.GLM1_resultsDir = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg); 
                    
        if GCcfg.GLM.TNS7T
            GCcfg.GLM.GLM2.roi = ''; % whole brain analysis
            [GCcfg, errCode]   = e3_gridC_set_GridCat_maskNspace(subjID,GCcfg,cfg,'');
            GCcfg              = e3_set_rawData(cfg, GCcfg, subjID); 
            GCcfg.GLM.dataDir  = e3_gridC_get_GLM2dir(subjID, cfg, GCcfg); 
            
            ncons = numel(dir(fullfile(GCcfg.GLM.dataDir,'con*')));
            if  ~cfg.grid.GLM1_replaceContr && ncons > 1  %% already added contrasts, so skip
                warning('GLM2 already estimated for %s, fold %d, ROI %s -- skipping...',subjID, ff, GCcfg.GLM.GLM2.roi);
                continue
            end

            % Specify GLM2 using the current configuration (GCcfg)
            specifyGLM(GCcfg);

            % Estimate GLM2 using the current configuration (GCcfg)
            estimateGLM(GCcfg);       
        else
            for mm=1:length(GCcfg.GLM.GLM2.doMasks)
                themask      = GCcfg.GLM.GLM2.doMasks{mm};
                GCcfg.GLM.GLM2.roi = GCcfg.GLM.GLM2.roiLabels{mm};

                [GCcfg, errCode] = e3_gridC_set_GridCat_maskNspace(subjID,GCcfg,cfg,themask);
                
                if errCode % if errCode=1 then continue
                    % GLM2 tests the estimated grid orientations that were estimated in GLM1.
                    % Specify here, where the GLM1 output is stored (i.e., the GLM1 data directory)
                    % both  cfg.GLM.GLM1_resultsDir and cfg.GLM.dataDir are
                    % needed by GridCat's specifyGLM() > generateMultiCondFile()
                    GCcfg.GLM.dataDir         = e3_gridC_get_GLM2dir(subjID, cfg, GCcfg); 

                    ncons = numel(dir(fullfile(GCcfg.GLM.dataDir,'con*')));
                    if ~cfg.grid.GLM1_replaceContr && ncons > 1 %% already added contrasts, so skip
                        warning('GLM2 already estimated for %s, fold %d, ROI %s -- skipping...',subjID, ff, GCcfg.GLM.GLM2.roi);
                        continue
                    end

                    % Specify GLM2 using the current configuration (GCcfg)
                    specifyGLM(GCcfg);

                    % Estimate GLM2 using the current configuration (GCcfg)
                    estimateGLM(GCcfg);
                end
            end
        end
    end
end