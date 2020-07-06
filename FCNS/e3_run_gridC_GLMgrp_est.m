function e3_run_gridC_GLMgrp_est(do,cfg)

    GCcfg = e3_cfg_GridCAT_gen(cfg); % common to both GLM1 and GLM2
    GCcfg               = e3_cfg_GridCAT_GLM2(cfg,GCcfg); 
    GCcfg.GLM.GLM2.roi  = ''; % whole brain analysis

    gwd = fullfile(cfg.dirs.gridC.res, GCcfg.modelname, sprintf('fold%1d',GCcfg.GLM.xFoldSymmetry), 'GRP', 'GLM');
    
    if GCcfg.GLM.TNS7T_pm || GCcfg.GLM.TNS7T_align
        gwd = fullfile(gwd,GCcfg.dirname.GLMgrp7T);
    end
    
    try
        cd(gwd);
    catch
        mkdir(gwd);
    end
     
    [vec_sex, vec_grp, map_sex, map_grp] = e3_get_grp_sex(do.Ss, cfg.files.subjdata);
%     keys(map_sex)   =  {'F'}    {'M'}
%     values(map_sex) =  {[1]}    {[2]}
%     keys(map_grp)   =  {'E2'}    {'PBO'}
%     values(map_grp) =  {[1]}    {[2]}
    
    vec_sexXgrp = (vec_sex - 1)*2 + vec_grp;
%     F      0
%     M      2
%     PBO 2  E2  1
%     
%     F-PBO = 2, F-E2 = 1
%     M-PBO = 4, M-E2 = 3
    
    ntests = length(GCcfg.GLMgrp.regrPatt);
    
    nSs    = length(do.Ss);
    
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    
    for tt = 1:ntests
        confiles = {};

        %% grab all the confiles over Ss for each test
        for ss = 1:nSs
            subj   = do.Ss(ss);
            subjID = sprintf('sub%03d',subj);

            GCcfg               = e3_gridC_set_GridCat_maskNspace(subjID,GCcfg,cfg,'');
            [GCcfg.GLM.GLM2dir, ~, GCcfg.GLM.folddir] = e3_gridC_get_GLM2dir(subjID, cfg, GCcfg);

            sSPM = load(fullfile(GCcfg.GLM.GLM2dir,'SPM.mat'));

            ncons = size(GCcfg.GLMgrp.patt{tt},1);
            if ncons > 1 % if more than one separate cons to grab
                for pp = 1:length(GCcfg.GLMgrp.patt{tt})

                    conIdx = find(~cellfun('isempty', regexp({sSPM.SPM.xCon(:).name},GCcfg.GLMgrp.patt{tt}{pp})));

                    for f=conIdx %% the confile indices
                        if f < 10
                            confiles = [confiles sprintf('%s/con_000%d.nii,1',GCcfg.GLM.GLM2dir,f)];
                        else
                            confiles = [confiles sprintf('%s/con_00%d.nii,1', GCcfg.GLM.GLM2dir,f)];
                        end
                    end
                end
            else
                conIdx = find(~cellfun('isempty', regexp({sSPM.SPM.xCon(:).name},GCcfg.GLMgrp.patt{tt})));
                for f=conIdx %% the confile indices
                    if f < 10
                        confiles = [confiles sprintf('%s/con_000%d.nii,1',GCcfg.GLM.GLM2dir,f)];
                    else
                        confiles = [confiles sprintf('%s/con_00%d.nii,1', GCcfg.GLM.GLM2dir,f)];
                    end
                end
            end     
        end

        matlabbatch{tt}.spm.stats.factorial_design.dir = {fullfile(gwd,GCcfg.GLMgrp.test{tt})};
        
        switch GCcfg.GLMgrp.test{tt}
            case '1stt'
                matlabbatch{tt}.spm.stats.factorial_design.des.t1.scans = confiles';
                matlabbatch{tt}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{tt}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{tt}.spm.stats.factorial_design.masking.tm.tm_none = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.im = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.em = {''};
                matlabbatch{tt}.spm.stats.factorial_design.globalc.g_omit = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.glonorm = 1;
            case 'waov'
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.fsubject.conds = repmat( 1:length(GCcfg.GLMgrp.regrNm{tt}), 1, length(do.Ss) );
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.fsubject.scans = confiles'; %% if not vertical concat then will order incorrectly by confile rather than sub
                
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.dept = 1;
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.variance = 1;
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.anovaw.ancova = 0;
                matlabbatch{tt}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{tt}.spm.stats.factorial_design.masking.tm.tm_none = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.im = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.em = {''};
                matlabbatch{tt}.spm.stats.factorial_design.globalc.g_omit = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.glonorm = 1;
            case 'flex'
                
                matlabbatch{tt}.spm.stats.factorial_design.dir = fullfile(matlabbatch{tt}.spm.stats.factorial_design.dir, GCcfg.GLMgrp.factor{tt});
                % https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1106&L=SPM&D=0&P=444921
                % https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=spm;3b32df36.1510
%                 flexI =  [ones(nSs*ncons,1) ...                       % internal repl fac
%                     reshape(repmat(do.Ss,ncons,1),1,nSs*ncons)' ...    % subject
%                     repmat(1:ncons,1,nSs)' ...                         % aligned factor        
%                     reshape(repmat(vec_grp',ncons,1),1,nSs*ncons)' ... % grp
%                     reshape(repmat(vec_sex',ncons,1),1,nSs*ncons)'];   % sex
%                 
%                 flexI =  [ones(nSs*ncons,1) ...                       % internal repl fac
%                     reshape(repmat(do.Ss,ncons,1),1,nSs*ncons)' ...    % subject
%                     repmat(1:ncons,1,nSs)' ...                         % aligned factor        
%                     reshape(repmat(vec_grp',ncons,1),1,nSs*ncons)' ... % grp
%                     ];   
                
                flexI =  [ones(nSs*ncons,1) ...                       % internal repl fac
                    reshape(repmat(do.Ss,ncons,1),1,nSs*ncons)' ...    % subject
                    repmat(1:ncons,1,nSs)' ...                         % aligned factor        
                    reshape(repmat(vec_sexXgrp',ncons,1),1,nSs*ncons)' ... % collapse sex and grp in one factor
                    ];   
                
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1; % "subject" variance should be set to equal (0)
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(2).name = GCcfg.GLMgrp.factor{tt};
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(3).name = 'sexXgroup';
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(3).dept = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(3).variance = 1;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;
%                 matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(4).name = 'sex';
%                 matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(4).dept = 0;
%                 matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(4).variance = 1;
%                 matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(4).gmsca = 0;
%                 matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fac(4).ancova = 0;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans = confiles';
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.fsuball.specall.imatrix = flexI;
                matlabbatch{tt}.spm.stats.factorial_design.des.fblock.maininters{1}.inter.fnums = [2 3];
                matlabbatch{tt}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{tt}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{tt}.spm.stats.factorial_design.masking.tm.tm_none = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.im = 1;
                matlabbatch{tt}.spm.stats.factorial_design.masking.em = {''};
                matlabbatch{tt}.spm.stats.factorial_design.globalc.g_omit = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
                matlabbatch{tt}.spm.stats.factorial_design.globalm.glonorm = 1;

        end 
    end

  
        
    for tt = 1:ntests       
        matlabbatch{ntests+tt}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{tt}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{ntests+tt}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{ntests+tt}.spm.stats.fmri_est.method.Classical = 1;
    end



    spm_jobman('run',matlabbatch);
end
