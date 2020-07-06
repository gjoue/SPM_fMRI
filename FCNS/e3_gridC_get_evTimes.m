%% get onset, duration and angles of given fields in cell array strucfields 
%% of structure trialNaviStruc for specified run number (sessNr)
%% returns a cell array of all fields and respective info

function [navmat, phasemat, trialNaviStruc] = e3_gridC_get_evTimes(subjNr,trialNaviStruc,strucfields,sessNr,spdThresh)
       navmat     = {};
       phasemat   = {};
       %phasemat01 = {};
       evlab2print = '';
       thresh   = 0;
       
       for ff = 1:length(strucfields)
           thefield   = strucfields{ff};        
           
           dothresh = 0;
       
           % rename some fields
           switch thefield
               case 'Moving'
                   evlab2print = 'Translation';
                   
                    %% TNS' UDK scripts allow Rotating to be within "Moving" -- 
                    %% make "Moving" more strict so that doesn't overlap with
                    %% Rotating and is more like "Translation". That way, we also
                    %% have the different angles each time people change directions
                    moving                      = trialNaviStruc.Moving & ~trialNaviStruc.Rotating;
                    movingNA                    = double(moving);
                    movingNA(movingNA==0)       = NaN; % sometimes there are Moving data points with zero speed, so be sure we're adjusting only moving time points in the next line
                    speed_moving                = movingNA .* trialNaviStruc.Speed; % only have speed values for the moving time points

                    switch spdThresh
                        case 'none'
                            thresh = 0; % navmat and phasemat will be done below for Move itself
                        case 'Q2'
                            dothresh = 1;
                            % quantile(speed_Moving, 0.5) close to
                            % trialNaviStruc.medianSpeed, but not exactly --
                            % take what Tobias has calculated for consistency
                            thresh = trialNaviStruc.medianSpeed;
                        case 'T3'
                            dothresh = 1;
                            thresh = quantile(speed_moving, 0.66); % only get the speeds of when moving, i.e. filter out all the 0 speeds from standing still
                        case 'T2'
                            dothresh = 1;
                            thresh = quantile(speed_moving, 0.33); % only get the speeds of when moving, i.e. filter out all the 0 speeds from standing still    
                    end

                    
               case 'Still'
                   evlab2print = thefield;
                    trialNaviStruc.Still = trialNaviStruc.Active - trialNaviStruc.Moving & ~trialNaviStruc.Rotating;
               case 'cue2'
                   evlab2print = 'cue';
               case 'drop2'
                   evlab2print = 'drop';
               case 'feedback2'
                   evlab2print = 'feedback';
               otherwise
                   evlab2print = thefield;
           end
           
           
            if dothresh
                fprintf('_______\n%sql THRESHOLD = %.2f\n', spdThresh, thresh);
                
                
                lab_threshd  = ['Transl_GT_' spdThresh]; % double quotes creates a string array rather than concatenating
                lab_tooSlow  = ['Transl_LT_' spdThresh];

                evlab2print = lab_tooSlow; % for onsets at end of if-block
                thefield    = lab_tooSlow; 
                
                trialNaviStruc.(lab_threshd)   = speed_moving >= thresh; % onset vectors for moving time points that are fast enough
                trialNaviStruc.(lab_tooSlow)   = moving - trialNaviStruc.(lab_threshd);

                [ev_ons, ev_dur, ev_ang, ev_spd, ev_phaseLab, ev_phaseVec] = e3_gridC_get_UDKtimeRange_navi(subjNr,trialNaviStruc,lab_threshd,sessNr);
                [navmat, phasemat]                                 = e3_gridC_populateOnsets(subjNr,sessNr, lab_threshd, ev_ons, ev_dur, ev_ang, ev_spd, ev_phaseLab, ev_phaseVec, navmat, phasemat);
                
            end

           [ev_ons, ev_dur, ev_ang, ev_spd, ev_phaseLab, ev_phaseVec] = e3_gridC_get_UDKtimeRange_navi(subjNr,trialNaviStruc,thefield,sessNr);
           [navmat, phasemat]                                 = e3_gridC_populateOnsets(subjNr,sessNr, evlab2print, ev_ons, ev_dur, ev_ang, ev_spd, ev_phaseLab, ev_phaseVec, navmat, phasemat);

                    
           
       end
end