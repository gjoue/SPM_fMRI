%% calculate DROP_ERROR
function dropErrs = e3_gridC_behav_getDropErrs_tns_gj(file_trials, file_pulses)

% ID = strsplit(file_trials,'.');
% pathprefix = ID{1};
% subj       = ID{2};
% sess       = sprintf('%s.%s',ID{3},ID{4});
clear dropErrs
%log_trial = importdata(deblank(ls(file_trials))); % when all numerical data, importdata will return a structure where data is in field 'data' -- if mixed data types then creates cell array

log_trialtmp   = readtable(deblank(ls(file_trials))); 
log_trial_data = table2array( log_trialtmp(:,1:end-1) );

%ntrials   = length(log_trial.data); % first line is the header
ntrials   = length(log_trial_data); % first line is the header

dropErrs.drop_dist = zeros(ntrials);
%computes euclidean distance between dropped location and original location
for nr_trial=1:ntrials
%     dropErrs.drop_dist(nr_trial,1)= sqrt((log_trial.data(nr_trial,9)-log_trial.data(nr_trial,11))^2 + (log_trial.data(nr_trial,10)-log_trial.data(nr_trial,12))^2);
%     dropErrs.drop_dist(nr_trial,2)=log_trial.data(nr_trial,5);
    dropErrs.drop_dist(nr_trial,1)= sqrt((log_trial_data(nr_trial,9)-log_trial_data(nr_trial,11))^2 + (log_trial_data(nr_trial,10)-log_trial_data(nr_trial,12))^2);
    dropErrs.drop_dist(nr_trial,2)=log_trial_data(nr_trial,5);
end

%computes spatial performance (here: uses max and min of participant!!)
for nsr_trial=1:ntrials
    dropErrs.drop_dist(nr_trial,3)= (max(dropErrs.drop_dist(:,1))-dropErrs.drop_dist(nr_trial,1)+min(dropErrs.drop_dist(:,1)))/max(dropErrs.drop_dist(:,1));
end




%% Calculate DROP_ERROR as function of time (1-min bins): LEARNING CURVES

%1min bins
OneMin_bins=[0,60:60:3840];

%write drop errors into corresponding bins
for i=1:length(dropErrs.drop_dist(:,1))
    for j=2:length(OneMin_bins(1,:))
        if dropErrs.drop_dist(i,2)<= OneMin_bins(1,j) && dropErrs.drop_dist(i,2)> OneMin_bins(1,j-1)
            OneMin_bins(i+1,j) = dropErrs.drop_dist(i,1);
            break
        end
    end

end

for i= 1:length(OneMin_bins(1,:))
    dropErrs.dropErrs_perMin(i) = sum(OneMin_bins(2:length(OneMin_bins(:,1)),i))/sum(OneMin_bins(2:length(OneMin_bins(:,1)),i)~=0);
end
    

%% Calculate DROP_ERROR as function of time (3-min bins): LEARNING CURVES

%1min bins
OneMin_bins=[0,60:180:3840];

%write drop errors into corresponding bins
for i=1:length(dropErrs.drop_dist(:,1))
    for j=2:length(OneMin_bins(1,:))
        if dropErrs.drop_dist(i,2)<= OneMin_bins(1,j) && dropErrs.drop_dist(i,2)> OneMin_bins(1,j-1)
            OneMin_bins(i+1,j) = dropErrs.drop_dist(i,1);
            break
        end
    end
end

for i= 1:length(OneMin_bins(1,:))
    dropErrs.dropErrs_per3Min(i) = sum(OneMin_bins(2:length(OneMin_bins(:,1)),i))/sum(OneMin_bins(2:length(OneMin_bins(:,1)),i)~=0);
end
    
% figDE = figure;
% plot(dropErrs.dropErrs_per3Min)
% title(sprintf('Drop distance errors (3-min bins): %s (%s)',subj,sess));
% ylabel('Distance errors');
% xlabel('time (min)');
% saveas(figDE,sprintf('%s_plot.dropErrs_%s_%s.pdf',pathprefix,subj,sess));

%% Get ONSETS for red smileys and green smileys (reward - contrast)
if exist('file_pulses','var')
    %timepoints of red smileys and green smileys
    pulse_timepoints = importdata( deblank(ls(file_pulses)) );
    t0 = pulse_timepoints.data(6,2);

    counter_rs = 1;
    counter_gs = 1;

    for i = 1:length(dropErrs.drop_dist(:,1))
        if dropErrs.drop_dist(i,1) > 2500
            redsmile_tp(counter_rs,1)= dropErrs.drop_dist(i,2);
            counter_rs = counter_rs +1;
        elseif dropErrs.drop_dist(i,1) < 1500
            greensmile_tp(counter_gs,1)= dropErrs.drop_dist(i,2);
            counter_gs = counter_gs +1;
        end
    end

    %% sometimes don't have redsmileys like with sub043/MA12
    if exist('redsmile_tp','var')
        fprintf('Logging red smileys\n');
        dropErrs.ons_redsmiley_temp = redsmile_tp(:,1)-t0;
        dropErrs.ons_redsmiley = dropErrs.ons_redsmiley_temp(dropErrs.ons_redsmiley_temp>0,1);
    else
        dropErrs.ons_redsmiley = [];
        warning('!!!  No red smileys?? !!!');
    end
    
    if exist('greensmile_tp','var')
        fprintf('Logging green smileys\n');
        dropErrs.ons_greensmiley_temp = greensmile_tp(:,1)-t0;
        dropErrs.ons_greensmiley = dropErrs.ons_greensmiley_temp(dropErrs.ons_greensmiley_temp>0,1);
    else
        dropErrs.ons_greensmiley = [];
        warning('!!! No green smileys?? !!!\n');
    end
end

fprintf('===== finished getting drop errors ======= \n');
