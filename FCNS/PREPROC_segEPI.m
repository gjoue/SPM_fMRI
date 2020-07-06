%.... same as T1 but now for EPI
function jobs = PREPROC_segEPI(dirTask,dirSPM)
    runs = get_subfolders(dirTask);
    meanEPI = spm_select('FPList',fullfile(dirTask,runs{1}),'^mu2meanuaf.*nii$'); % use SDCed + intensity-flattened mean
	
    %% bias correct the mean EPI first
    jj = 1; 
    jobs{jj}.spm.spatial.preproc.channel.vols = {meanEPI};
    jobs{jj}.spm.spatial.preproc.channel.biasreg = 0.001;
    jobs{jj}.spm.spatial.preproc.channel.biasfwhm = 150;   % default is 60...play with this
    jobs{jj}.spm.spatial.preproc.channel.write = [1 1];   % save bias field (BiasField_*) and corrected (m*)
    jobs{jj}.spm.spatial.preproc.tissue(1).tpm = {fullfile(dirSPM,'tpm/TPM.nii,1')};
    jobs{jj}.spm.spatial.preproc.tissue(1).ngaus = Inf;  % non-Gaussian
    jobs{jj}.spm.spatial.preproc.tissue(1).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(1).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(2).tpm = {fullfile(dirSPM,'tpm/TPM.nii,2')};
    jobs{jj}.spm.spatial.preproc.tissue(2).ngaus = Inf;
    jobs{jj}.spm.spatial.preproc.tissue(2).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(2).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(3).tpm = {fullfile(dirSPM,'tpm/TPM.nii,3')};
    jobs{jj}.spm.spatial.preproc.tissue(3).ngaus = Inf;
    jobs{jj}.spm.spatial.preproc.tissue(3).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(3).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(4).tpm = {fullfile(dirSPM,'tpm/TPM.nii,4')};  % skull/bone 
    jobs{jj}.spm.spatial.preproc.tissue(4).ngaus = Inf;
    jobs{jj}.spm.spatial.preproc.tissue(4).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(4).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(5).tpm = {fullfile(dirSPM,'tpm/TPM.nii,5')};  % nonbrain soft tissues
    jobs{jj}.spm.spatial.preproc.tissue(5).ngaus = Inf;
    jobs{jj}.spm.spatial.preproc.tissue(5).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(5).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.tissue(6).tpm = {fullfile(dirSPM,'tpm/TPM.nii,6')};  % air
    jobs{jj}.spm.spatial.preproc.tissue(6).ngaus = Inf;
    jobs{jj}.spm.spatial.preproc.tissue(6).native = [1 1];
    jobs{jj}.spm.spatial.preproc.tissue(6).warped = [0 0];
    jobs{jj}.spm.spatial.preproc.warp.mrf = 1;
    jobs{jj}.spm.spatial.preproc.warp.cleanup = 1;
    jobs{jj}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    jobs{jj}.spm.spatial.preproc.warp.affreg = 'mni';  % MI affine regularisation
    jobs{jj}.spm.spatial.preproc.warp.fwhm = 0;
    jobs{jj}.spm.spatial.preproc.warp.samp = 3;
    jobs{jj}.spm.spatial.preproc.warp.write = [1 1]; %[inverse fwd]
    
end
