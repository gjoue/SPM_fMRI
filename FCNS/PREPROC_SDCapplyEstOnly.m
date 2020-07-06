%%-------------------------------------------------------------------------
%%                   6. PREPROC_SDCapplyEstOnly
%%-------------------------------------------------------------------------
function jobs = PREPROC_SDCapplyEstOnly(sdirs)
    jobs = {};
    %% not optimal, but set the file to be corrected here
    %% had registered the gridC and reinfL within each task -> SDCed 
    %% but actually should've reg'd across tasks -- i.e. to mid of 1st gridC run
    %% so rereg'ed and now just need to apply SDC to the mean that is now in gridC/run1
    
    prefix_bfield = 'HySCOv2_';
    
    if exist(sdirs.se,'dir') 
        cfg.PREPROC.SDC.seq = 'SE';  % if SE blips exist, use this over GE
        dirBlip_p = sdirs.se_p{1};
        dirBlip_d = sdirs.se_d{1};
        
        src_ps  = spm_select('FPList', dirBlip_p, '^sPRISMA.*.nii');
        src_p   = src_ps(end,:);
        
        bfield  = spm_select( 'FPList', dirBlip_d, sprintf('^%ssPRISMA.*.nii',prefix_bfield) );
    else
        dirBlip_p = sdirs.ge_p{1};
        dirBlip_d = sdirs.ge_d{1};
        fn_p      = 'avg_blipGE1_p.nii';
        fn_d      = 'mavg_blipGE1_d.nii';
        src_p     = fullfile(dirBlip_p,fn_p);
        
        bfield     = fullfile(dirBlip_d,sprintf('%s%s',prefix_bfield,fn_d));
    end
    
    
    
    mean_xtask = spm_select('FPList', fullfile(sdirs.fcn,'gridC','run1'), '^meanuafPRISMA.*.nii');
    
    
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.source_up    = {src_p};
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.others_up    = {mean_xtask};
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.others_dw    = {''};
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.bfield       = {bfield};
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.perm_dim     = 2;
    jobs{1}.spm.tools.dti.prepro_choice.hysco_choice.hysco_write.dummy_3dor4d = 0;
end

