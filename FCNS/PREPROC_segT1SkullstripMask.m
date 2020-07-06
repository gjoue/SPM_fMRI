%%-------------------------------------------------------------------------
%%                   4.  SEGMENT T1 and EPI to tissue maps, mvmt realign betw scans
%%-----------------------------------------------------------------
%% segment T1 and bias correct
%% INPUT:
%%         * T1 MPRAGE
%% OUTPUT:
%%         * m*.nii             attenuation corrected image
%%         * y*.nii             forward deformation field
%%         * BiasField_*.nii    bias field
%%         * *_seg8.mat         transformation matrix
%%         * c1*.nii            GM tissue map
%%         * c2*.nii            WM tissue map
%%         * c3*.nii            CSF
%%         * wc[12345]*.nii     normalized versions of tissue maps
%%         *
function jobs = PREPROC_segT1SkullstripMask(dirT1,dirSPM)
    clear jobs;
    
    T1      = spm_select('FPList', dirT1, '^sP.*nii$');
    
    %% then segment using bias-corrected T1
    jj = 1;
    jobs{jj}.spm.spatial.preproc.channel.vols = {T1};
    jobs{jj}.spm.spatial.preproc.channel.biasreg = 0.001;
    jobs{jj}.spm.spatial.preproc.channel.biasfwhm = 60; % default is 60...play with this
    jobs{jj}.spm.spatial.preproc.channel.write = [1 1]; % save bias field (BiasField_*) and corrected (m*), tho don't need this for DARTEL
    jobs{jj}.spm.spatial.preproc.tissue(1).tpm = {fullfile(dirSPM,'tpm/TPM.nii,1')}; % GM
    jobs{jj}.spm.spatial.preproc.tissue(1).ngaus = 1;
    jobs{jj}.spm.spatial.preproc.tissue(1).native = [1 1]; % native + Dartel imported (lower res for Dartel reg later)
    jobs{jj}.spm.spatial.preproc.tissue(1).warped = [0 0]; % for VBM, but leave as none because if do VBM, will first use Dartel to get closer alignment
    jobs{jj}.spm.spatial.preproc.tissue(2).tpm = {fullfile(dirSPM,'tpm/TPM.nii,2')}; % WM
    jobs{jj}.spm.spatial.preproc.tissue(2).ngaus = 1;
    jobs{jj}.spm.spatial.preproc.tissue(2).native = [1 1]; % native + Dartel imported
    jobs{jj}.spm.spatial.preproc.tissue(2).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(3).tpm = {fullfile(dirSPM,'tpm/TPM.nii,3')}; % CSF
    jobs{jj}.spm.spatial.preproc.tissue(3).ngaus = 2;
    jobs{jj}.spm.spatial.preproc.tissue(3).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(3).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(4).tpm = {fullfile(dirSPM,'tpm/TPM.nii,4')}; % skull
    jobs{jj}.spm.spatial.preproc.tissue(4).ngaus = 3;
    jobs{jj}.spm.spatial.preproc.tissue(4).native = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(4).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(5).tpm = {fullfile(dirSPM,'tpm/TPM.nii,5')}; % soft tissue outside brain
    jobs{jj}.spm.spatial.preproc.tissue(5).ngaus = 4;
    jobs{jj}.spm.spatial.preproc.tissue(5).native = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(5).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(6).tpm = {fullfile(dirSPM,'tpm/TPM.nii,6')}; % air etc outside brain
    jobs{jj}.spm.spatial.preproc.tissue(6).ngaus = 2;
    jobs{jj}.spm.spatial.preproc.tissue(6).native = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(6).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.warp.mrf = 1;
    jobs{jj}.spm.spatial.preproc.warp.cleanup = 1;
    jobs{jj}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    jobs{jj}.spm.spatial.preproc.warp.affreg = 'mni';
    jobs{jj}.spm.spatial.preproc.warp.fwhm = 0;
    jobs{jj}.spm.spatial.preproc.warp.samp = 3;
    jobs{jj}.spm.spatial.preproc.warp.write = [0 1]; % [inv fwd] deformation field
    
    %% skull strip T1 brain
    jj = jj + 1;
    
    jobs{jj}.spm.util.imcalc.input(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{jj-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
    jobs{jj}.spm.util.imcalc.input(2) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{jj-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
    jobs{jj}.spm.util.imcalc.input(3) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{jj-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{jj}, '.','c', '()',{':'}));
    jobs{jj}.spm.util.imcalc.input(4) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{jj-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
    jobs{jj}.spm.util.imcalc.output = 'skulled_T1';
    jobs{jj}.spm.util.imcalc.outdir = {dirT1};
    jobs{jj}.spm.util.imcalc.expression = 'i1.*(i2+i3+i4)>0.5';
    jobs{jj}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    jobs{jj}.spm.util.imcalc.options.dmtx = 0;
    jobs{jj}.spm.util.imcalc.options.mask = 0;
    jobs{jj}.spm.util.imcalc.options.interp = 1;
    jobs{jj}.spm.util.imcalc.options.dtype = 4;
    
    %% brain mask of WM and GM
    jj = jj + 1;
    jobs{jj}.spm.util.imcalc.input(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{jj-2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
    jobs{jj}.spm.util.imcalc.input(2) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{jj-2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
    jobs{jj}.spm.util.imcalc.output = 'mask_WMpGM';
    jobs{jj}.spm.util.imcalc.outdir = {dirT1};
    jobs{jj}.spm.util.imcalc.expression = '(i1+i2)>0.2';
    jobs{jj}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    jobs{jj}.spm.util.imcalc.options.dmtx = 0;
    jobs{jj}.spm.util.imcalc.options.mask = 0;
    jobs{jj}.spm.util.imcalc.options.interp = 1;
    jobs{jj}.spm.util.imcalc.options.dtype = 4;
    
%     P = strvcat(P1(i,:),P2(i,:)));
%     Q = ['brainmpr_' num2str(i) '.img'];
%     f = '(i1+i2)>0.5';
%     flags = {[],[],[],[]};
%     Q = spm_imcalc_ui(P,Q,f,flags);

    
    %% ANTs bias correction
    %%    -d image dimensionality
    %%    -i input -o output
    %%    -s shrinkage factor (typically <=4)
    %%    -c #iter,convThresh
    %%    -x mask (if do not specify, tool will create one)
    %N4BiasFieldCorrection -d 3 -i 7875_T1.nii -s 2 -c [100x100x100x100,0.0000000001] -o prova2.nii.gz
end

