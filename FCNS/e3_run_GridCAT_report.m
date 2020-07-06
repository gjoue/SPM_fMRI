%% EXPORT GRID METRICS
function e3_run_GridCAT_report(do,cfg,whichreport)
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
                    
                    
                    if ~isempty(ROImasks)

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

            if do.TESTING
                for ss = 1:length(do.Ss)
                    subj = do.Ss(ss);
                    e3_GridCat_report_mag(subj,cfg, GCcfg);
                end
            else
                parfor ss = 1:length(do.Ss)
                    subj = do.Ss(ss);
                    e3_GridCat_report_mag(subj,cfg, GCcfg);
                end
            end
            
            fprintf('\n============== SCRIPT ENDED [%s] ===========\n', datetime('now'));
            diary off;

             
         otherwise
            warning('Option to create GridCat report not valid: %s', whichreport);
     end
         
     diary off;
end

