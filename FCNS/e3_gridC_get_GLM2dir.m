function [GLM2dir, GLM2reportdir, GLMfolddir] = e3_gridC_get_GLM2dir(subjID, cfg, GCcfg)
    GLMfolddir     = fullfile(cfg.dirs.gridC.res, GCcfg.modelname, sprintf('fold%1d',GCcfg.GLM.xFoldSymmetry));
    GLM2reportdir  = fullfile(GLMfolddir, subjID);
    
    if GCcfg.GLM.TNS7T_pm || GCcfg.GLM.TNS7T_align
        GLM2dir        = fullfile(GLM2reportdir, GCcfg.dirname.GLM2, GCcfg.GLM.GLM2.roi);
    else
        GLM2dir        = fullfile(GLM2reportdir, GCcfg.dirname.GLM2, GCcfg.GLM.GLM2_gridRegressorMethod, GCcfg.GLM.GLM2.roi);
    end
end