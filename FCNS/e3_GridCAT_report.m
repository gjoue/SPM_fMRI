%% EXPORT GRID METRICS
function e3_GridCAT_report(do,cfg,whichreport)
     GCcfg = e3_cfg_GridCAT_gen(cfg);
     GCcfg = e3_cfg_GridCAT_report(cfg,GCcfg);
     
     ROImasks = {};

     diaryfn = sprintf('GridCat_report_warnings_%s.log', GCcfg.modelname);
     diary( fullfile(cfg.scriptLogs,diaryfn) );

     switch whichreport
         
         case 'coh' % GLM1
              for ss = 1:length(do.Ss)
                    subj   = do.Ss(ss);
                    subjID = sprintf('sub%03d',subj);
                    fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));
     
                    r2 = 1;
                    for r=1:length(GCcfg.report.GLM1masks)
                        mask = sprintf(GCcfg.report.GLM1masks{r},subjID);
                        
                        if isfile(mask)
                            ROImasks{r2} = mask;
                            r2 = r2 + 1;
                        end
                    end
                    
                    if length(ROImasks) > 0

                        for ff=GCcfg.GLM.rotatefolds
                            GCcfg.GLM.xFoldSymmetry = ff;
                            [dir_GLM1,dir_report] = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg);

                            if isfield(GCcfg.report,'note') && ~isempty(GCcfg.report.note)
                                outfilename    = sprintf('%s.sub%03d.fold%d.%s.txt',GCcfg.report.basename, subj, ff, GCcfg.report.note);
                            else
                                outfilename    = sprintf('%s.sub%03d.fold%d.txt',GCcfg.report.basename, subj, ff);
                            end

                            outfile_report = {fullfile(dir_report, outfilename)};

                            % Calculate and export grid metrics
                            gridMetric_export_GLM1_gj(ROImasks, dir_GLM1, outfile_report);
                        end
                    else 
                        fprintf('\t NO ROIs for subject...skipping grid metric export for this subject\n');
                    end
              end
             
         case 'mag' % GLM2
%              GCcfg.Ss.allGLM2s = do.Ss;%setdiff(do.Ss,GCcfg.Ss.failedSomeGLM2); 
%              nSs = length(GCcfg.Ss.allGLM2s);
% 
%              %% just some info about grps
%              subjdata  = e3_load_subjInfo(cfg.files.subjdata);
%              [~,nXgrp] = e3_get_sexNgrp(subjdata, GCcfg.Ss.allGLM2s);
% 
%              fprintf('______ Total %d Ss with all GLM2s estimated ______\n', nSs);
%              disp(nXgrp);
% 
%             %% failures for Ss by ROI
%             print_failedGLM2s(subjdata, GCcfg, cfg);

            
             parfor ss = 1:length(do.Ss)
                 sGCcfg = GCcfg;
                    subj   = do.Ss(ss);
                    subjID = sprintf('sub%03d',subj);
                    fprintf('************ subject %d [%s] ************\n',subj, datetime('now'));

                    r2 = 1;
                    doMasks = GCcfg.GLM.GLM2.doMasks;
                    GCcfg.GLM.GLM2.doMasks = '';
                    for r=1:length(doMasks)
                        mask = sprintf(doMasks{r},subjID);
                        
                        if isfile(mask)
                            GCcfg.GLM.GLM2.doMasks{r2} = mask;
                            r2 = r2 + 1;
                        end
                    end
                    
                    
                    for ff=GCcfg.GLM.rotatefolds
                        GCcfg.GLM.xFoldSymmetry = ff;
                        for mm=1:length(GCcfg.GLM.GLM2.roiLabels)
                            GCcfg.GLM.GLM2.roi = GCcfg.GLM.GLM2.roiLabels{mm};
                            roiFile  = GCcfg.GLM.GLM2.doMasks{mm};
                            
                            
                            [dir_GLM2,  dir_report]  = e3_gridC_get_GLM2dir(subjID, cfg, GCcfg); % GLM2 path includes roi label

                            %GCcfg.dirname.Res

                            if exist(dir_GLM2, 'dir')
                                if ~isempty(dir( fullfile(dir_GLM2,'con*.nii') ) )
                                    if isfield(GCcfg.report,'note') && ~isempty(GCcfg.report.note)
                                        outfilename    = sprintf('%s.sub%03d.fold%d.%s.%s.txt',GCcfg.report.basename, subj, ff, GCcfg.report.note, GCcfg.GLM.GLM2.roi);
                                    else
                                        outfilename    = sprintf('%s.sub%03d.fold%d.%s.txt',GCcfg.report.basename, subj, ff, GCcfg.GLM.GLM2.roi);
                                    end

                                    outfile_report = {fullfile(dir_report, outfilename)};


                                    % Calculate and export grid metrics
                                    %gridMetric_export_GLM2_gj(GCcfg.report.GLM2ROIs, dir_GLM2, outfile_report);
                                    gridMetric_export_GLM2_gj({roiFile}, dir_GLM2, outfile_report);
                                else
                                    warning('!*!*!* no GLM2 contrasts estimated for %s',dir_GLM2);
                                end
                            else
                                warning('!*!*!* no GLM2 directory %s',dir_GLM2);
                                continue;
                            end
                        end
                    end
             end
            fprintf('\n============== SCRIPT ENDED [%s] ===========\n', datetime('now'));
            diary off;

             
         otherwise
            warning('Option to create GridCat report not valid: ', whichreport);
     end
         
     diary off;
end

