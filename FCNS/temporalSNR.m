function tSNR = temporalSNR(time_series,masks,maskLabels)
    %% modified from Cyril Pernet's SPM Utility Plus toolbox spmup_temporalSNR.m
    %% to calculate tSNR within a ROIs
    
    V      = spm_vol(time_series);
    nmasks = length(masks);
    
    if size(time_series,1) == 1 && strcmp(time_series(length(time_series)-1:end),',1')
        time_series = time_series(1:length(time_series)-2); % in case picked 4D put left ,1
    end

    if iscell(time_series)
        for v=1:size(time_series,1)
            Vfmri(v) =spm_vol(time_series{v});
        end
    else
        Vfmri = spm_vol(time_series);
    end

    if iscell(V); V = cell2mat(V); end
    if size(V,1) < 10; error('there is less than 10 images in your time series ??'); end

    for m=1:nmasks
        if iscell(masks) ==0
            VM(m) = spm_vol(masks(m,:));
        else
            VM(m) = spm_vol(masks{m});
        end
    end

    if iscell(VM); VM = cell2mat(VM); end

%     maskpairs = combntns(1:nmasks,2);
%     
%     dimMismatch = 0;
%     for cc=1:length(maskpairs)
%         if VM(maskpairs(cc,1)).dim~= VM(maskpairs(cc,2)).dim
%             dimMismatch = 1;
%             error('dimension mismatch between some of the masks: %s [%d %d %d] but %s [%d %d %d]\n%s\n%s',...
%                       maskLabels{maskpairs(cc,1)}, VM(maskpairs(cc,1)).dim,...
%                       maskLabels{maskpairs(cc,2)}, VM(maskpairs(cc,2)).dim,...
%                       masks{maskpairs(cc,1)}, {maskpairs(cc,2)});
%         end
%     end
%     
%     if any(V(1).dim~= VM(1).dim)
% htings to         error('dimension mismatch between the time series [%d %d %d] and masks [%d %d %d]', V(1).dim, VM(1).dim)
%     end

    for cc=1:length(masks)
        VVM = spm_read_vols(VM(cc));
       
%         ivx        = find(VVM>0);
%         XYZmm      = VVM(ivx);
%         [Xvx,Yvx,Xvx] = ind2sub(V(1).dim,ivx); % volume index => [x y z] vx coords
%                 
        %% in masks tSNR
        clear x y z 
        [x,y,z]  = ind2sub(V(1).dim, find(VVM));
        data     = spm_get_data(V,[x y z]');
        stdV     = nanmean(nanstd(data,1));
        tSNR.(maskLabels{cc}) = nanmean(nanmean(data,1)) / stdV; 
 
    end


end