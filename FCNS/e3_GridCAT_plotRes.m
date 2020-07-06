function e3_GridCAT_plotRes(do,cfg)
    %% this function requires export_fig from MathWorks File Exchange (a
    %% copy of which is in /projects/crunchie/TOOLBOXES)
    %% and is basically modified calls to GridCat Toolbox functions
    %%    gridMetric_oriCoherence_withinVox.m
    %%    gridMetric_oriCoherence_betweenVox.m 
    %% to plot and save plots to one pdf file
    close all force;
    %delete(findall(0));
    
    dispOutput_flag = 1; % show plots (the entire point!)
    
    GCcfg = e3_cfg_GridCAT_gen(cfg);
    GCcfg = e3_cfg_GridCAT_report(cfg,GCcfg);

    dir_mod       = fullfile(cfg.dirs.gridC.res, GCcfg.modelname);

    for xx=1:length(cfg.codes.sex)
        sex = cfg.codes.sex{xx};
        
        for gg=1:length(cfg.codes.grp)
            grp = cfg.codes.grp{gg};

            fprintf('________________ %s : %s [%s] ________________\n',sex, grp, datetime('now'));
    
            [subset_Ss, subset_Ss_gcID] = e3_get_subsetXsexNgrp(sex,grp,do.Ss,cfg);
    
            for ss = 1: length(subset_Ss)
                subj    = subset_Ss(ss);
                subjID  = sprintf('sub%03d',subj);
                
                subjGC  = subset_Ss_gcID{ss};
                
                subjStr = [subjID '/' subjGC]; 
                fprintf('************ subject %s [%s] ************\n',subjStr, datetime('now'));

                for ff=GCcfg.GLM.rotatefolds
                    GCcfg.GLM.xFoldSymmetry       = ff;
                    
                    %dir_folds_sub = fullfile(dir_mod, sprintf('fold%1d',ff), subjID);
                    
                    dir_GLM1      = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg);
                    %dir_GLM2      = fullfile(dir_folds_sub, GCcfg.dirname.GLM2, GCcfg.GLM.GLM2.roiLabel);

                    file_within  = fullfile(dir_mod, sprintf('%s.%s.%s.%s.fold%1d.%s', GCcfg.report.basename_cohPlots, 'withinVx', sex, grp, ff, GCcfg.modelname));
                    file_betw    = fullfile(dir_mod, sprintf('%s.%s.%s.%s.fold%1d.%s', GCcfg.report.basename_cohPlots, 'betwVx', sex, grp, ff, GCcfg.modelname));
                    
                    % ----------------------------------------------------------------
                    % Within-voxels grid orientation coherence within ROI
                    % ----------------------------------------------------------------

                    % which xFoldSymmetry were the calculations testing for?
                    %GridCAT_matFileData = load([dir_GLM1 filesep 'GridCAT_GLM1.mat']);


                    for gg=1:length(GCcfg.report.withinCoh.runPairs)
                        iorimg1 = GCcfg.report.withinCoh.runPairs{gg}(1);
                        iorimg2 = GCcfg.report.withinCoh.runPairs{gg}(2);

                        vxwiseGridOri1 = deblank(ls([dir_GLM1 filesep 'voxelwiseGridOri*run' num2str(iorimg1) '*.nii']));
                        vxwiseGridOri2 = deblank(ls([dir_GLM1 filesep 'voxelwiseGridOri*run' num2str(iorimg2) '*.nii']));

                        % the GUI is opened separately for each ROI mask
                        for imask = 1:length(GCcfg.report.coh.masks)

                            mask = {sprintf(GCcfg.report.coh.masks{imask},subjID)};

                            % calculate grid metric just for the current ROI mask image
                            oriCoherence_withinVox_GUI_gj(dispOutput_flag, mask, {vxwiseGridOri1,vxwiseGridOri2}, ff, subjStr);
                            fh = findall(0,'type','figure');
                            export_fig(fh,file_within, '-pdf', '-append');
                            close(fh);
                        end
                    end
                    
                    
                    % ----------------------------------------------------------------
                    % Between-voxel grid orientation coherence within ROI
                    % ----------------------------------------------------------------
                    for gg=1:length(GCcfg.report.betwCoh.runs)
                        vxwiseGridOr = deblank(ls( fullfile( dir_GLM1,sprintf('voxelwiseGridOri*%s*.nii',GCcfg.report.betwCoh.runs{gg}) ) ));
                        
                        for imask = 1:length(GCcfg.report.coh.masks)
                            
                            mask = {sprintf(GCcfg.report.coh.masks{imask},subjID)};
                            
                            oriCoherence_betweenVox_GUI_gj(dispOutput_flag, mask, {vxwiseGridOr}, ff, subjStr);
                            fh = findall(0,'type','figure');
                            export_fig(fh,file_betw, '-pdf', '-append');
                            close(fh);
                        end
                    end
                end    
            end
        end
    end
end
    
    
    
    
    
    
    
    
    
    
%     ud.voxelwiseOri_images = varargin{3};
%     ud.xFoldSymmetry = varargin{4};
%     set(handles.figure1, 'UserData', ud);
% 
%     [~, mask_fname, mask_fext] = fileparts(ud.mask_images{1});
%     [~, imgA_fname, imgA_fext] = fileparts(ud.voxelwiseOri_images{1}); % inner image in plot
%     [~, imgB_fname, imgB_fext] = fileparts(ud.voxelwiseOri_images{2}); % outer image in plot
% 
%     set(handles.text_roiMask, 'String', [mask_fname mask_fext]);
%     set(handles.text_innerCircleFile, 'String', [imgA_fname imgA_fext]);
%     set(handles.text_outerCircleFile, 'String', [imgB_fname imgB_fext]);
% 
%     set(handles.text_xFoldSymmetry, 'String', [num2str(ud.xFoldSymmetry) '-fold symmetry ']);
%     set(handles.edit_stableVoxelTh, 'String', num2str(360/ud.xFoldSymmetry/4));
% 
%     set(handles.text_plotE, 'String', num2str(0));
%     set(handles.text_plotN, 'String', num2str(round((90/ud.xFoldSymmetry)*10)/10));
%     set(handles.text_plotW, 'String', num2str(round((180/ud.xFoldSymmetry)*10)/10));
%     set(handles.text_plotS, 'String', num2str(round((270/ud.xFoldSymmetry)*10)/10));
% 
%     % plot graph in axes
%     gridMetric_oriCoherence_withinVox(...
%         dispOutput_flag, ...
%         ud.mask_images, ...
%         ud.voxelwiseOri_images, ...
%         ud.xFoldSymmetry, ...
%         360/ud.xFoldSymmetry/4, ...
%         handles.axes1);
%     %    handles.text_proportionOfStableVoxels, ...  %% from here on set inside gridMetric_oriCoherence_withinVox() if not specified
%     %    lineWidth_stableVox, ...
%     %    lineWidth_unstabVox, ...
%     %    lineColor_stableVox, ...
%     %    lineColor_unstabVox, ...
%     %    lineStyle_stableVox, ...
%     %    lineStyle_unstabVox...
%     %);
% 
% 
%     
%     gridMetric_oriCoherence_withinVox(dispOutput_flag, mask_images, voxelwiseOri_images, xFoldSymmetry, stabilityThreshold_deg, handle_drawInAxes, handle_outputText, lineWidth_stableVox, lineWidth_unstabVox, lineColor_stableVox, lineColor_unstabVox, lineStyle_stableVox, lineStyle_unstabVox)
