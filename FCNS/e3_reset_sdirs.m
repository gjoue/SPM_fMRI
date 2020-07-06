function sdirs = e3_reset_sdirs(sdirs,dirGE) 
    sdirs.ge      = fullfile(sdirs.subj, 'blips', dirGE);
    sdirs.se      = fullfile(sdirs.subj, 'blips', 'SE');
    
    sdirs.ge_p{1} = fullfile(sdirs.ge, 'blipGE1_p');
    sdirs.ge_d{1} = fullfile(sdirs.ge, 'blipGE1_d');
    sdirs.ge_p{2} = fullfile(sdirs.ge, 'blipGE2_p');
    sdirs.ge_d{2} = fullfile(sdirs.ge, 'blipGE2_d');
    
    sdirs.se_p{1} = fullfile(sdirs.se, 'blipSE1_p');
    sdirs.se_d{1} = fullfile(sdirs.se, 'blipSE1_d');
    sdirs.se_p{2} = fullfile(sdirs.se, 'blipSE2_p');
    sdirs.se_d{2} = fullfile(sdirs.se, 'blipSE2_d');
end