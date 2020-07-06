%% get all MOVEMENT and all STATIONARY timepoints
%includes time points during initial learning, ITIs
function mvmt = e3_gridC_behav_getMvmtTimepts_tns_gj(file_trials, file_path)

% ID = strsplit(file_trials,'.');
% pathprefix = ID{1};
% subj       = ID{2};
% sess       = sprintf('%s.%s',ID{3},ID{4});
clear mvmt;

%log_path  = importdata( deblank(ls(file_path)) );     % path_i  path_x  path_y  path_ons
%log_trial = importdata( deblank(ls(file_trials)) );   % col2 = nav_ons, col5 = drop_t, col6 = grab_t

% had added object name to dat files (string so importdata imports into a
% cell array rather than structure
log_path_tmp  = readtable(deblank(ls(file_path))); 
log_path_data = table2array( log_path_tmp(:,1:end-1) );

log_trial_tmp  = readtable(deblank(ls(file_trials))); 
log_trial_data = table2array( log_trial_tmp(:,1:end-1) );

%mvmt.path = log_path.data;
mvmt.path = log_path_data;


%divide timepoints into movement (coordinates not same to previous
%position) or stationary (same corrdinates as for previous time point)

fprintf('____________Dividing timepoints into mvmt or stationary\n');
counter_mv = 1;
counter_st = 1;

for i = 1:length(mvmt.path(:,1))-1
    if mvmt.path(i+1,2)~=mvmt.path(i,2) || mvmt.path(i+1,3)~=mvmt.path(i,3) 
        %mvmt.mvmt_timepts(counter_mv,1:4) = mvmt.path(i+1,:);
        mvmt.mvmt_timepts(counter_mv,1:4) = mvmt.path(i+1,1:4);
        counter_mv = counter_mv +1;
    else
%        mvmt.stationary_timepts(counter_st,1:4) = mvmt.path(i+1,:);
        mvmt.stationary_timepts(counter_st,1:4) = mvmt.path(i+1,1:4);
        counter_st = counter_st +1;
    end
end


%% Divide movement timepoints into RETRIEVAL and COLLECTION phases
fprintf('____________Dividing movement timepoints into retrieval or collection\n');


counter_mv_retrieval = 1;
counter_st_retrieval = 1;
counter_mv_collection = 1;
counter_st_collection = 1;


log_c = 2; % WHY DOES THIS START AT 2?? but seems to match -- e.g. log_path has index = 26 and log_trial = 29

%%mvmt.path starts with trial number zero -- so skip all 0th trial data
%%points
while mvmt.path(log_c,1)==0
    log_c = log_c+1;
end

flag = 0;
% for j = 1:length(log_trial.data(:,1))
for j = 1:length(log_trial_data(:,1))
    if flag
        break
    else
%        while mvmt.path(log_c,1)== log_trial.data(j,1)
        while mvmt.path(log_c,1)== log_trial_data(j,1)
            if mvmt.path(log_c,2)~=mvmt.path(log_c-1,2) || mvmt.path(log_c,3)~=mvmt.path(log_c-1,3) %if coordinates of subsequent locations are not identical (= movement)
                %%                path_ons              nav_ons           path_ons    drop_t
                %if mvmt.path(log_c,4) >= log_trial.data(j,2) && mvmt.path(log_c,4) <= log_trial.data(j,5) %time between navigation onset and droptime
                if mvmt.path(log_c,4) >= log_trial_data(j,2) && mvmt.path(log_c,4) <= log_trial_data(j,5) %time between navigation onset and droptime
                    %mvmt.timepts.retrieval.mvmt(counter_mv_retrieval,1:4) = mvmt.path(log_c-1,:);
                    mvmt.timepts.retrieval.mvmt(counter_mv_retrieval,1:4) = mvmt.path(log_c-1,1:4);
                    counter_mv_retrieval = counter_mv_retrieval +1;
                %%               path_ons               drop_t                path_ons             grab_t
                %elseif mvmt.path(log_c,4) >= log_trial.data(j,5) && mvmt.path(log_c,4) <= log_trial.data(j,6) %time between droptime and grabtime
                elseif mvmt.path(log_c,4) >= log_trial_data(j,5) && mvmt.path(log_c,4) <= log_trial_data(j,6) %time between droptime and grabtime
                    %mvmt.timepts.collect.mvmt(counter_mv_collection,1:4) = mvmt.path(log_c-1,:);
                    mvmt.timepts.collect.mvmt(counter_mv_collection,1:4) = mvmt.path(log_c-1,1:4);
                    counter_mv_collection = counter_mv_collection +1;
                end
            else %if coordinates of subsequent locations are identical (= stationary)
                %if mvmt.path(log_c,4) >= log_trial.data(j,2) && mvmt.path(log_c,4) <= log_trial.data(j,5) %time between navigation onset and droptime
                if mvmt.path(log_c,4) >= log_trial_data(j,2) && mvmt.path(log_c,4) <= log_trial_data(j,5) %time between navigation onset and droptime
                    %mvmt.timepts.retrieval.stationary(counter_st_retrieval,1:4) = mvmt.path(log_c-1,:);
                    mvmt.timepts.retrieval.stationary(counter_st_retrieval,1:4) = mvmt.path(log_c-1,1:4);
                    counter_st_retrieval = counter_st_retrieval +1;
                %elseif mvmt.path(log_c,4) >= log_trial.data(j,5) && mvmt.path(log_c,4) <= log_trial.data(j,6) %time between droptime and grabtime         mvmt.timepts.collect.mvmt(counter_mv,1) = mvmt.path(log_c+1,4);
                elseif mvmt.path(log_c,4) >= log_trial_data(j,5) && mvmt.path(log_c,4) <= log_trial_data(j,6) %time between droptime and grabtime         mvmt.timepts.collect.mvmt(counter_mv,1) = mvmt.path(log_c+1,4);
                    %mvmt.timepts.collect.stationary(counter_st_collection,1:4) = mvmt.path(log_c-1,:);
                    mvmt.timepts.collect.stationary(counter_st_collection,1:4) = mvmt.path(log_c-1,1:4);
                    counter_st_collection = counter_st_collection +1;
                end
            end
            log_c = log_c+1;
            if log_c > length(mvmt.path(:,1)) %if reached end of timepoints break while-loop
                flag = 1;
                break
            end
        end
    end
end

% %plot walking paths
% figPath = figure;
% plot(mvmt.path(:,2),mvmt.path(:,3),'.')
% title(sprintf('Navigation path: %s (%s)',subj,sess));
% saveas(figPath,sprintf('%s_plot.navPath_%s_%s.pdf',pathprefix,subj,sess));
% 
% figMvmt = figure;
% plot(mvmt.mvmt_timepts(:,2),mvmt.mvmt_timepts(:,3),'.')
% title(sprintf('Moving timepoints: %s (%s)',subj,sess));
% saveas(figMvmt,sprintf('%s_plot.mvmt_%s_%s.pdf',pathprefix,subj,sess));
% 
% figStat = figure;
% plot(mvmt.stationary_timepts(:,2),mvmt.stationary_timepts(:,3),'.')
% title(sprintf('Stationary timepoints: %s (%s)',pathprefix,subj,sess));
% saveas(figStat,sprintf('%s_plot.stationary_%s_%s.pdf',pathprefix,subj,sess));


%% Calculate NAVIGATIONAL PREFERENCE
fprintf('____________Calculating navigational preferences\n');

% arena radius: 4500 vu

fprintf('...... for all time points......\n');
%%%%%%%%%%%%%%% for all time points %%%%%%%%%%%%%%%%%
mvmt.counter_ctr = 0;
mvmt.counter_peri = 0;

for i = 1:length(mvmt.path(:,1))
    % # of timepoints for central navigation (i.e. x,y<2250)
    if mvmt.path(i,2)<2250 && mvmt.path(i,3)<2250 
        mvmt.counter_ctr = mvmt.counter_ctr + 1;
     % # of timepoints for peripheral navigation (i.e. x or y>=2250)
    else
        mvmt.counter_peri = mvmt.counter_peri + 1;
    end
end

mvmt.navi_pref = mvmt.counter_peri/(mvmt.counter_ctr+mvmt.counter_peri);

fprintf('......now for retrieval time points only......\n');
%%%%%%%%%%%%%%% for retrieval time points only %%%%%%%%%%%%%%%%%
mvmt.timepts.retrieval.all = [mvmt.timepts.retrieval.mvmt; mvmt.timepts.retrieval.stationary];

counter_ctr_retrieval= 0;
mvmt.counter_peri_retrieval = 0;

for i = 1:length(mvmt.timepts.retrieval.all(:,1))
    % # of timepoints for central navigation (i.e. x,y<2250)
    if mvmt.timepts.retrieval.all(i,2)<2250 && mvmt.timepts.retrieval.all(i,3)<2250 
        counter_ctr_retrieval = counter_ctr_retrieval + 1;
     % # of timepoints for peripheral navigation (i.e. x or y>=2250)
    else
        mvmt.counter_peri_retrieval = mvmt.counter_peri_retrieval + 1;
    end
end

mvmt.navi_pref_retrieval = mvmt.counter_peri_retrieval/(counter_ctr_retrieval+mvmt.counter_peri_retrieval);

fprintf('===== finished getting movement/stationary timepoints ======= \n');



        