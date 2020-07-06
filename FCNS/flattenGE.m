%%-------------------------------------------------------------------------
%%                     FLATTEN / BIAS-CORRECT INTENSITY  
%%-------------------------------------------------------------------------
%% spm_preproc_run
function flattenGE(whichvol,dirSPM)
    clear subjobs;
    subjobs{1}.spm.spatial.preproc.channel.vols = {whichvol};
    subjobs{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    subjobs{1}.spm.spatial.preproc.channel.biasfwhm = 30; % default is 60...play with this
    subjobs{1}.spm.spatial.preproc.channel.write = [1 1]; % save bias field (BiasField_*) and corrected (m*)
    subjobs{1}.spm.spatial.preproc.tissue(1).tpm = {fullfile(dirSPM,'tpm/TPM.nii,1')}; % GM
    subjobs{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    subjobs{1}.spm.spatial.preproc.tissue(1).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(2).tpm = {fullfile(dirSPM,'tpm/TPM.nii,2')}; % WM
    subjobs{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    subjobs{1}.spm.spatial.preproc.tissue(2).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(3).tpm = {fullfile(dirSPM,'tpm/TPM.nii,3')}; % CSF
    subjobs{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    subjobs{1}.spm.spatial.preproc.tissue(3).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(4).tpm = {fullfile(dirSPM,'tpm/TPM.nii,4')};
    subjobs{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    subjobs{1}.spm.spatial.preproc.tissue(4).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(5).tpm = {fullfile(dirSPM,'tpm/TPM.nii,5')};
    subjobs{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    subjobs{1}.spm.spatial.preproc.tissue(5).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(6).tpm = {fullfile(dirSPM,'tpm/TPM.nii,6')};
    subjobs{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    subjobs{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    subjobs{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    subjobs{1}.spm.spatial.preproc.warp.mrf = 1;
    subjobs{1}.spm.spatial.preproc.warp.cleanup = 1;
    subjobs{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    subjobs{1}.spm.spatial.preproc.warp.affreg = 'mni';
    subjobs{1}.spm.spatial.preproc.warp.fwhm = 0;
    subjobs{1}.spm.spatial.preproc.warp.samp = 3;
    subjobs{1}.spm.spatial.preproc.warp.write = [0 0];
       
    spm_jobman('run', subjobs);
end