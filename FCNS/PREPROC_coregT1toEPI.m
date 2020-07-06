%%-------------------------------------------------------------------------
%%                   8.  COREG T1 -> mean EPI
%%-------------------------------------------------------------------------

function jobs = PREPROC_coregT1toEPI(whichCoreg,subjID,task,dirTask,dirT1,dirFSLexe)
    jobs = {};
    runs = get_subfolders(dirTask);
    
    %umeanEPI = spm_select('FPList',fullfile(dirTask,runs{1}),'^mmu2meanuaf.*nii$');  % bias-corrected mean 
	meanEPI = spm_select('FPList',fullfile(dirTask,runs{1}),'^u2meanuaf.*nii$');  % not bias-corrected mean...segmenting after coreg'ing 
	T1 = spm_select('FPList', dirT1, '^sPRIS.*\.nii$');                       % bias-corrected T1
     
    %% use segmented WM instead of T1
    %T1wm = spm_select('FPList', dirT1, '^c2.*sPRIS.*\.nii$');   
    
    
    switch whichCoreg             
        case 'SPM'
            %% inputs:
            %%          * mean EPI/fcn'l image (calculated during realignment), used as reference
            %%          * bias-corrected T1 MPRAGE (source)
            %% outputs:
            %%          * header of source (T1 MPRAGE) modified
            jobs{1}.spm.spatial.coreg.estimate.ref               = {meanEPI};
            jobs{1}.spm.spatial.coreg.estimate.source            = {T1};
            jobs{1}.spm.spatial.coreg.estimate.other             = {''}; % never coreg Dartel-imported rc*.nii because they are already coreg'ed to MNI space, I think
            jobs{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
            jobs{1}.spm.spatial.coreg.estimate.eoptions.sep      = [4 2];
            jobs{1}.spm.spatial.coreg.estimate.eoptions.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
            jobs{1}.spm.spatial.coreg.estimate.eoptions.fwhm     = [7 7];

        case 'SyN'
            %% ANTs needs a 4D NIFTI, gz
            %% load 3D data files:
            %/common/apps/fsl/bin/fslmerge

%             % load your a set of n 3D volumes:
%             V=spm_vol('filename1.img');
%             vol1=spm_read_vols(V);
%             V=spm_vol('filename2.img');
%             vol2=spm_read_vols(V);
%             ....
%             V=spm_vol('filenamen.img');
%             voln=spm_read_vols(V);
% 
%             % put them in a 4D variable
% 
%             data(:,:,:,1)=vol1;
%             data(:,:,:,2)=vol2;
%             ....
%             data(:,:,:,n)=voln;
% 
%             % write the 4D nifty file
% 
%             for ii=1:n
%               V(ii).dim=size(data);
%               V(ii).fname=['filename.nii'];
%               spm_write_vol(V(ii),data(:,:,:,ii));
%             end
            
            % create 4D NIFTIs
            for rr = 1:length(runs)
                run = runs{rr};

                fprintf('%s, %s -- converting to 4D.nii.gz\n', dirTask, run);
                dirRun = fullfile(dirTask,run);
                cd(dirRun);

                img = spm_select('FPList',dirRun,'^u2uaf.*nii$'); % take realigned, ST-corrected

                prefix4D      = sprintf('%s_%s_%s',subjID,task,run);
                cmdConvert = sprintf('%s/fslmerge -t %s u2uaf*.nii',dirFSLexe,prefix4D);
                fprintf('=====\n%s, %s -- converting to 4D.nii.gz:\n%s\n', dirTask, run,cmdConvert);
                system(cmdConvert);
            end             
            
            T1brainmask = spm_select('FPList',dirT1,'^mask_WmpGM.nii$');
            T1_csf      = spm_select('FPList',dirT1,'^c3.*.nii$');
            T1_gm       = spm_select('FPList',dirT1,'^c1.*.nii$');
            T1_wm       = spm_select('FPList',dirT1,'^c2.*.nii$');
            %........
            
            %% note, passing the last session's 4D nii.gz just to pass something -- when specify an average EPI file, will not do motion correection (so will not need the 4D file anyway
            cmdANTs = sprintf('ANTs_T12fmri.sh -i %s.nii.gz -a %s -t %s -b %s -c %s -g %s -w %s -o outputdir/outputprefix',prefix4D,umeanEPI,T1,T1_brainmask,T1_csf,T1_gm,T1_wm);
            %system(fprintf('ANTs_mriToT1.sh -i 4DtimeSeries.nii.gz -t T1img.nii.gz -b T1brainmask -c T1csfpriorimage -g T1gmpriorimage -w T1wmpriorimage -o outputdir/outputprefix'));
            

        otherwise
    end
        
        
        
        
end

