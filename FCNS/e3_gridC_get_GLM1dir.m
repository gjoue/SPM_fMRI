function [GLM1dir, GLM1reportdir] = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg)
    GLM1reportdir = fullfile(cfg.dirs.gridC.res, GCcfg.modelname , sprintf('fold%1d',GCcfg.GLM.xFoldSymmetry), subjID);
    GLM1dir       = fullfile(GLM1reportdir, GCcfg.dirname.GLM1);
end