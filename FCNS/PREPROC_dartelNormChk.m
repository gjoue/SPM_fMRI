function PREPROC_dartelNormChk(cfg)
        whichT1    = 'w'; %'sw';
        outT1      = sprintf('mean_%smT1.nii',whichT1);
        snormedT1s = dir(sprintf('%s/*/anat/T1/%smsPRIS*.nii',cfg.dirs.sub,whichT1));

        V      = spm_vol( fullfile({snormedT1s.folder},{snormedT1s.name}) );
        img    = spm_read_vols(V{1});
        img_mu = zeros(size( V{1} ));
        
        N = size(snormedT1s,1);
        
        for i=1:N
            img    = spm_read_vols(V{i});
            img_mu = (img_mu + img)/N; 
%             P = strvcat(P1(i,:),P2(i,:)));
%             Q = ['brainmpr_' num2str(i) '.img'];
%             f = '(i1+i2)>0.5';
%             flags = {[],[],[],[]};
%             Q = spm_imcalc_ui(P,Q,f,flags);
        end
        
        if ~exist(cfg.dirs.grp,'dir')
            mkdir(cfg.dirs.grp);
        end
        
        fprintf('Writing out %s, the average of %sT1s to %s\n',outT1, whichT1, cfg.dirs.grp);
        V{1}.fname = fullfile(cfg.dirs.grp,outT1);
        spm_write_vol(V{1},img_mu);
end
