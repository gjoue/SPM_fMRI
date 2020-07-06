function sdirs = e3_orgBlips(sdirs)
    %% renames the following
    %%     `-- revBlipEPI              ==> blips
    %%         `-- GRE                   ==> GE
    %%         |    `-- blipGRE1_d         ==> blipGE1_d
    %%         |    `-- blipGRE2_d         ==> blipGE2_d
    %%         |                       ---> adds blipGE1_p and blipGE2_p, and 
    %%         |                      populates with the same number of vols as in blip_d from fMRI series closest to the blip-down
    %%         |                       = last volumes of grid cell OR first volumes of reinfL task
    %%         `-- SE
    %%              `-- blipSE1_d
    %%              |-- blipSE1_p
    %%              |-- blipSE2_d
    %%              `-- blipSE2_p
    
    dirGE = 'GE';
    
    cd(sdirs.subj);
    fprintf('organizing/renaming BLIP files for %s\n',sdirs.subj);
    if ( exist('revBlipEPI','dir') ) 
        system('mv revBlipEPI blips');
    end
    
    %find . -name '*GRE*' -type d -exec bash -c 'echo $1' -- {} \;  % this works 
    %system('find . -name ''*GRE*'' -type d -exec bash -c ''mv ""$1""
    %""${1/GRE/GE/}""'' -- {} \;'); % this doesn't
    
    %% need the single quotes around *GRE* otherwise won't be recursivex
    system(sprintf('find . -type d -name ''*GRE*'' | while read FNAME; do mv ""$FNAME"" ""${FNAME//GRE/GE}""; done'));
    
    sdirs = e3_reset_sdirs(sdirs,dirGE); 
    
    if ( ~exist(fullfile(sdirs.ge,'blipGE1_p'),'dir') )
        mkdir(sdirs.ge,'blipGE1_p');
    end
    ii=1;
    fmris    = spm_select('FPList',fullfile(sdirs.fcn,'gridC','run1'),'^fPRIS.*.nii.*'); % char arrays; might be gz'ed
    blip1_ds = spm_select('FPList',sdirs.ge_d{ii},'^fPRIS.*.nii.*'); % char arrayc
    nblips   = size(blip1_ds,1);
    whichEnd = 'end';
    cpFileSeq(fmris,sdirs.ge_p{ii},nblips,whichEnd);
    system(sprintf('gunzip -f %s',fullfile(sdirs.ge_p{ii},'*.gz')));
    
    if exist(fullfile(sdirs.ge,'blipGE2_d'),'dir')
        ii=2;        
        mkdir( sdirs.ge_p{ii} );
    
        sdirs.ge_p{ii} = fullfile(sdirs.ge, 'blipGE2_p');
        sdirs.ge_d{ii} = fullfile(sdirs.ge, 'blipGE2_d');
            
        fmris = spm_select('FPList',fullfile(sdirs.fcn,'reinfL','run1'),'^fPRIS.*.nii.*'); % char arrayc
        blip2_ds = spm_select('FPList',sdirs.ge_d{ii},'^fPRIS.*.nii.*'); % char arrayc
        nblips   = size(blip2_ds,1);
        whichEnd = 'beg';
        cpFileSeq(fmris,sdirs.ge_p{ii},nblips,whichEnd);
        system(sprintf('gunzip -f %s',fullfile(sdirs.ge_p{ii},'*.gz')));
   end