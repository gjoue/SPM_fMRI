function chkImgsSDCreg(sdirs,cfg,doWhat)

    switch doWhat
        case 'norm2mni'
            pref_pp = 'sw';
        case 'coreg'
            pref_pp = '';            
    end
    
    pref_func = 'u2uafP';
    
    T1templ     = fullfile(cfg.dirs.SPM,'canonical/avg152T1.nii');
    
    f_mu_grid   = spm_select('FPList',fullfile(sdirs.gridC,'run1'), '^meanuaf.*.nii' );
    f_umu_grid  = spm_select('FPList',fullfile(sdirs.gridC,'run1'), '^u2meanuaf.*.nii' );
    
    fs_ux_grid  = spm_select('FPList',fullfile(sdirs.gridC,'run6'),   sprintf('^%s%s.*.nii',pref_pp,pref_func) );    
    fs_ux_reinf  = spm_select('FPList',fullfile(sdirs.reinfL,'run1'), sprintf('^%s%s.*.nii',pref_pp,pref_func) );
    
    s_pT1         = spm_select('FPList',sdirs.T1, sprintf('^%smsPRISMA.*.nii',pref_pp) ); % bias-corrected
    s_T1         = spm_select('FPList',sdirs.T1, '^sPRISMA.*.nii'); 
    
    s_c1         = spm_select('FPList',sdirs.T1, sprintf('^%sc1sPRISMA.*.nii',pref_pp) ); % bias-corrected
    s_c2         = spm_select('FPList',sdirs.T1, sprintf('^%sc2sPRISMA.*.nii',pref_pp) ); % bias-corrected
   
    f_c1         = spm_select('FPList',fullfile(sdirs.gridC,'run1'), '^c1mu2meanuafPRISMA.*.nii' ); % bias-corrected
    f_c2         = spm_select('FPList',fullfile(sdirs.gridC,'run1'), '^c2mu2meanuafPRISMA.*.nii' ); % bias-corrected
    
    switch doWhat
        case 'norm2mni'
            spm_check_registration(... 
                T1templ, ...
                s_T1,...
                s_pT1, ...
                s_c1,...
                s_c2,...
                fs_ux_grid(end,:), ...
                fs_ux_reinf(end,:)...
            );
        case 'coreg'
            spm_check_registration(... 
                    s_T1, ...
                    f_mu_grid, ...
                    f_umu_grid, ...
                    fs_ux_grid(end,:), ... 
                    fs_ux_reinf(end,:)                );
    end
%        f_mu_grid, ...


    pause;
end