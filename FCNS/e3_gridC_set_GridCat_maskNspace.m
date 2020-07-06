function [GCcfg, errCode] = e3_gridC_set_GridCat_maskNspace(subjID,GCcfg,cfg,mask)

    if GCcfg.GLM.TNS7T 
        GCcfg.GLM.nativeSpace = 0;
        errCode = 0;
    else
        errCode = 1; % 1=continue/no error

        if strfind(mask,'%s') 
            GCcfg.GLM.nativeSpace = 1;
            GCcfg.GLM.GLM2_roiMask_calcMeanGridOri = {sprintf(mask, subjID)};
            mask = GCcfg.GLM.GLM2_roiMask_calcMeanGridOri{1};
        else
            GCcfg.GLM.nativeSpace = 0;
            GCcfg.GLM.GLM2_roiMask_calcMeanGridOri = {mask};
        end

        if exist(mask,'file')==7
            errCode = 0;
            warning("Mask file %s for %s could not be found....skipping",GCcfg.GLM.GLM2_roiMask_calcMeanGridOri, subjID);
        end

        % Specify data directory for this GLM
        % The directory will be created if it does not exist
        %[~,tmp_roilabs,~] = fileparts(mask);
    end    
    %% reset GLM model name
    GCcfg = e3_gridC_set_modelName(GCcfg,cfg);
    
%     if any(cellfun(@(x) exist(x,'file')==7, mask)) % 2 = file exists, 7 = DNE
%         error("Mask file %s for %s could not be found",GCcfg.GLM.GLM2_roiMask_calcMeanGridOri{:}, subjID);
%     end
end