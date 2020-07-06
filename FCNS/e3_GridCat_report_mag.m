function e3_GridCat_report_mag(subjNo, cfg, GCcfg)
        
        subjID = sprintf('sub%03d',subjNo);
        fprintf('************ subject %d [%s] ************\n',subjNo, datetime('now'));

        if any(~cellfun('isempty', strfind(GCcfg.GLM.GLM2.doMasks,'%') ))
            doMasks = GCcfg.GLM.GLM2.doMasks;
            GCcfg.GLM.GLM2.doMasks = '';
            for r=1:length(doMasks)
                mask = sprintf(doMasks{r},subjID);

                if isfile(mask)
                    GCcfg.GLM.GLM2.doMasks{r} = mask;
                end
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
                            outfilename    = sprintf('%s.sub%03d.fold%d.%s.%s.txt',GCcfg.report.basename, subjNo, ff, GCcfg.report.note, GCcfg.GLM.GLM2.roi);
                        else
                            outfilename    = sprintf('%s.sub%03d.fold%d.%s.txt',GCcfg.report.basename, subjNo, ff, GCcfg.GLM.GLM2.roi);
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