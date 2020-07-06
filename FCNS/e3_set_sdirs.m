function sdirs = e3_set_sdirs(dirSubs,subjID) 
%    sdirs.subj = fullfile(cfg.dirs.sub,subjID);   
    sdirs.subj   = fullfile(dirSubs,subjID);
    
    sdirs.T1     = fullfile(sdirs.subj, 'anat', 'T1');   
    sdirs.TSE    = fullfile(sdirs.subj, 'anat', 'T2');        
    sdirs.fcn    = fullfile(sdirs.subj, 'func');

    sdirs.gridC  = fullfile(sdirs.fcn, 'gridC');
    sdirs.reinfL = fullfile(sdirs.fcn, 'reinfL');
    
    sdirs.LEV1   = fullfile(sdirs.subj, 'glm');
    
    %% old dirs:
    
        sdirs.ge   = fullfile(sdirs.subj, 'revBlipEPI', 'GRE');
        sdirs.se   = fullfile(sdirs.subj, 'revBlipEPI', 'SE');

end



        