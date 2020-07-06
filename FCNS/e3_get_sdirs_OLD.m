%%-------------------------------------------------------------------------
%%                     set subj folders prior to organizing/dup'ing for diff approaches
%%-------------------------------------------------------------------------
function sdirs = e3_get_sdirs(basedir,subjID)
    sdirs.subj  = fullfile(basedir,subjID);
    
    sdirs.fcn   = fullfile(sdirs.subj,'func');
    sdirs.FLASH = fullfile(sdirs.subj,'FLASH');
    sdirs.FM    = fullfile(sdirs.subj,'FM');
    sdirs.T1    = fullfile(sdirs.subj, 'T1');
    
    % check how many GE blip series there are
    sdirs.GE    = fullfile(sdirs.subj,'GE');
    sdirs.GEp   = fullfile(sdirs.GE, 'blipGE1_p');
    sdirs.GEd   = fullfile(sdirs.GE, 'blipGE1_d');
    
    sdirs.SE    = fullfile(sdirs.subj,'SE');
    sdirs.SEp   = fullfile(sdirs.SE, 'blip_p');
    sdirs.SEd   = fullfile(sdirs.SE, 'blip_d');
    
    sdirs.gridC  = fullfile(sdirs.fcn,'gridC');
    sdirs.reinfL = fullfile(sdirs.fcn,'reinfL');
end