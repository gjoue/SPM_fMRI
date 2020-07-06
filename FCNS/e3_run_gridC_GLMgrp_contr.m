function e3_run_gridC_GLMgrp_contr(do,cfg)
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    
    GCcfg               = e3_cfg_GridCAT_gen(cfg); % common to both GLM1 and GLM2
    GCcfg               = e3_cfg_GridCAT_GLM2(cfg,GCcfg); 

    gwd = fullfile(cfg.dirs.gridC.res, GCcfg.modelname, sprintf('fold%1d',GCcfg.GLM.xFoldSymmetry), 'GRP', 'GLM');
    if GCcfg.GLM.TNS7T_pm || GCcfg.GLM.TNS7T_align
        gwd = fullfile(gwd,GCcfg.dirname.GLMgrp7T);
    end
    
    
    nconXsubj = 6;
    nsub      = do.nSs;

    %% 6 con files per subject corresp to the aligned>misaligned 
    %% contrasts for each run
    ntests = length(GCcfg.GLMgrp.regrPatt);
    i = 0;
    for tt = 1:ntests
        spmmatfile = fullfile(gwd,GCcfg.GLMgrp.test{tt},'SPM.mat');
        matlabbatch{tt}.spm.stats.con.spmmat = {spmmatfile};
                
        switch GCcfg.GLMgrp.test{tt}
            case '1stt'
                if GCcfg.GLM.TNS7T_xRun
                    for c=1:nconXsubj
                        vec = [zeros(1,c-1) 1 zeros(1,nconXsubj-c) ones(1,nsub)/nsub];
                        matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('Run%d_%s',c, GCcfg.GLMgrp.grpconnm{tt});
                        matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = vec;
                        matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                    end
                    c = c+1;
                    vec = [ones(1,nconXsubj)/nconXsubj ones(1,nsub)/nsub];
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grpconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                    
                    c = c+1;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.rgrpconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = -vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                else
                    c = 1;
                    vec = 1;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grpconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                end
            case 'waov'
                    c = 1;
                    vec = GCcfg.GLMgrp.grpconvec{tt};
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grpconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                    
                    c = c+1;;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grprconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = -vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
            case 'flex'
                %    FACTOR x GROUP (F-E2 = 1, F-PBO = 2, M-E2 = 3, M-PBO =
                %    4)
                    c = 1;
                    vec = GCcfg.GLMgrp.grpconvec{tt};
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grpconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
                    
                    c = c+1;;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.name    = sprintf('RunAll_%s', GCcfg.GLMgrp.grprconnm{tt});
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.convec  = -vec;
                    matlabbatch{tt}.spm.stats.con.consess{c}.tcon.sessrep = 'none';

        end
        
        if cfg.grid.GLM1_replaceContr
            matlabbatch{tt}.spm.stats.con.delete = 1;
        else
            matlabbatch{tt}.spm.stats.con.delete = 0;
        end
    end
        


    spm_jobman('run',matlabbatch);

end