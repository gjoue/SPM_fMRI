
%% For given "field" and "whichrun" for subject "subjNr" whose data is in "trialNaviStruc",
%% outputs 
%%    * t_ons   = vector of onset time stamps
%%    * t_dur   = vector of duration
%%    * ang_deg = vector of running direction in degrees
%%    * ph_lab  = cell array with phase labels
%%    * ph_vec  = 2-col matrix with phase coding 0/1 for cue2drop and feedback2grab
function [t_ons, t_dur, ang_deg, spd, ph_lab, ph_vec] = e3_gridC_get_UDKtimeRange_navi(subjNr,trialNaviStruc,field,whichrun)
        
        phaseFields = {'cue2drop', 'feedback2grab'};

        i_run    = trialNaviStruc.Session==whichrun;
         
        i_runXfield  = ( trialNaviStruc.(field) & i_run );                
        
        i_start  = find(i_run==1,1,'first');
        t0       = trialNaviStruc.UDKtime( i_start );         
        
        [i_onset,i_offset] = e3_gridC_get_onsOffsets( i_runXfield );
          
        n_onsets  = sum(i_onset);
        n_offsets = sum(i_offset);
        if n_onsets - n_offsets == 1
            i_end            = find(i_run==1,1,'last');
            i_offset(i_end)  = true;
        elseif n_onsets > n_offsets
            error('Something went seriously wrong with onset (found %d)/offset(found %d) tagging',n_onsets, n_offsets);
        end
        
        
        %%____________  timings  ____________ 
        sampleRate = mode(diff(trialNaviStruc.UDKtime));
        
        t_ons = trialNaviStruc.UDKtime(i_onset) - t0;
        t_off = trialNaviStruc.UDKtime(i_offset) + sampleRate - t0; %% could've done UDKtime(i_offset+1) -- sometimes events only length of one timestamp, so duration would be erroneously 0 in next calc
        t_dur = t_off - t_ons;
        
        if any(t_dur < 0)
            error('Negative duration calculation! %d onsets and %d offsets', n_onsets, n_offsets);
        end
        
        
        spd  = trialNaviStruc.Speed(i_onset); 
        
        %%____________  angle  (only have when moving in one direc)____________ 
        %% altho have some angle information for rotations, do not take them -- 
        %% otherwise GridCat will treat as a grid event and create onsets for
        %% it as a regressor and as parametric modulators based on angles, and
        %% SPM will try and orthogonalize these and throw an error because
        %% the data is filled with NaNs
        
        ang_rad   = trialNaviStruc.Angle(i_onset); 
        
            
        if strcmp(field,'Moving') || contains(field,'Transl_GT') % only heading direction for ones we want to treat as gridC events (so clear angles for translations below spd threshold)
            ang_deg   = ang_rad * 180/pi;
        else
            ang_deg   = NaN( size(ang_rad) );
        end
        %%______ phases ______
        ph_lab    = cell(size(t_ons));
        ph_lab(:) = {'NaN'};
        
        ph_vec    = NaN( size(t_ons,1), 2);
        
        for ph = 1:length(phaseFields)
            thephase = phaseFields{ph};
            
            i_ph    = logical(trialNaviStruc.(thephase));
            i_phFld = i_ph(i_onset);
            
            ph_vec(:,ph) = i_ph(i_onset);
            ph_lab( [find(i_phFld == 1)] ) = cellstr(thephase);

        end
        
        %%______ data check ______
        fprintf('_______\n%s: 6th pulse ons = %.2f\n', field, t0);
        fprintf('min ons = %3.2f, max ons = %3.2f\n', min(t_ons), max(t_ons));
        fprintf('min dur = %3.2f, max dur = %3.2f\n', min(t_dur), max(t_dur));
        
                 
        if strcmp(field,'Moving')
            fprintf('min ang = %3.2f, max ang = %3.2f deg\n', min(ang_deg), max(ang_deg));
%             figure;
%             rose(ang_deg);
%             title(sprintf('sub%03d (run %d) overall running directions', subjNr, whichrun));
        end        
end
        
 %% shift onset timings using 6th pulse of run as 0
        %% sanity check of navi.Pulse structure:
        % ipulse1 = find(subtrial.navi.Pulse == 1)
        % ilast=ipulse1-1
        % subtrial.navi.Pulse(ilast)
        % length(ilast)
        % subtrial.navi.Pulse(ilast(3:7))-subtrial.navi.Pulse(ilast(2:6))
        %% gives around 390, which is the number of volumes per run for estropharm3, the 5 dummies included
        
        %% more sanity checks
        % isess1=find(subtrial.navi.Session == 1);
        % isess2=find(subtrial.navi.Session == 2); 
        % isess3=find(subtrial.navi.Session == 3);
        % isess4=find(subtrial.navi.Session == 4);
        % isess5=find(subtrial.navi.Session == 5);
        % isess6=find(subtrial.navi.Session == 6);
        %  i1s = [isess1(1), isess2(1), isess3(1), isess4(1),isess5(1),isess6(1)]        