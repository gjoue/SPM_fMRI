function [perf, perf_headers] = MentalRotMR_perf_jb_gj(sub, mainpath)



    
    perf = [];

    %% read in MR output file %%%%
    % path = [ mainpath filesep 'VP' num2str(sub) filesep 'EstroPharm_MR_OUTPUT_VP' num2str(sub) '.txt'];
      path = [ mainpath filesep 'EstroPharm_MR_OUTPUT_VP' num2str(sub) '.txt'];
 % path = [ mainpath  filesep 'EstroPharm_MR_OUTPUT_VP' num2str(sub) '.txt'];
    fid = fopen(path);
    column_nr = 7;   
   
    % number of columns in textfile
    formatstring=strcat(repmat('%s ',1,column_nr));                                 % erzeugt Formatierungsstring
    pres_out = textscan(fid, formatstring, 'delimiter', '\t');     %   übergibt Inhalt des logfiles an data
    pres_out= cat(2, pres_out{:} ); 
    status = fclose(fid);   %schliesst die Datei wieder, wenn das nicht ging bekommt fid den Wert -1
    headers = pres_out(1,:);
    pres_out = pres_out(2:35, :);
    
      %% read in MR output file (for RT) %%%%
    %path = [ mainpath filesep 'VP' num2str(sub) filesep  'EstroPharm_MR_logfile_VP' num2str(sub) '.txt'];
    path = [ mainpath filesep 'EstroPharm_MR_logfile_VP' num2str(sub) '.txt'];
    fid = fopen(path);
    column_nr = 10;                                                                 % number of columns in textfile
    formatstring=strcat(repmat('%s ',1,column_nr));                                 % erzeugt Formatierungsstring
    pres_log = textscan(fid, formatstring, 'delimiter', '\t');     %   übergibt Inhalt des logfiles an data
    pres_log= cat(2, pres_log{:} ); 
    status = fclose(fid);   %schliesst die Datei wieder, wenn das nicht ging bekommt fid den Wert -1
    
%     pres_log = pres_log(5:end, 4:5);
%     pres_log = cellfun(@str2num, pres_log, 'UniformOutput', false);
    
    trial_rows = strmatch('Figure', pres_log(:,4));
    end_rows = strmatch('BREAK', pres_log(:,4));
    trial_rows = [min(trial_rows)-3; trial_rows( trial_rows < end_rows(2)); min(trial_rows(trial_rows>end_rows(2)))-3; trial_rows(trial_rows>end_rows(2))]; 
    pres_log = pres_log(:, 3:5);
    pres_log = cellfun(@str2num, pres_log, 'UniformOutput', false);
    
    rt_a1= []; rt_a2= []; 
    
    for ii = 1 : size(trial_rows,1)
        t_trialstart(ii) = pres_log{trial_rows(ii),3};
        if trial_rows(ii)+1 <= size(pres_log,1)
        if ~isempty(pres_log{trial_rows(ii)+1,2}) & pres_log{trial_rows(ii)+1,2} <5  % is neither string nor spacebar
            rt_a1(ii) =  pres_log{trial_rows(ii)+1,3} -  t_trialstart(ii);
        else
            rt_a1(ii) = 9999;
        end;
        end;
        if trial_rows(ii)+2 <= size(pres_log,1)
         if ~isempty(pres_log{trial_rows(ii)+2,2}) & pres_log{trial_rows(ii)+2,2} <5  % is neither string nor spacebar
            rt_a2(ii) =  pres_log{trial_rows(ii)+2,3} -  pres_log{trial_rows(ii)+1,3};
         else
            rt_a2(ii) = 9999;
           
        end;
        end;
end;

% trenne rt nach bloecken
rt_a1_block1 = rt_a1(1: size(trial_rows(trial_rows<end_rows(1)),1))/10;
rt_a2_block1 = rt_a2(1: size(trial_rows(trial_rows<end_rows(1)),1))/10;
rt_a1_block2 = rt_a1(size(trial_rows(trial_rows<end_rows(1)),1)+1:end)/10;
rt_a2_block2 = rt_a2(size(trial_rows(trial_rows<end_rows(1)),1)+1:end)/10;


     %% read correct answers and replace (necessary because solution provided by outputfile is not quite right) %%%%
    path = [  '/users/bayer/EstroPharm_Tasks/MR_CorrectAnswers.txt'];
    fid = fopen(path);
    column_nr = 3;                                                                 % number of columns in textfile
    formatstring=strcat(repmat('%s ',1,column_nr));                                 % erzeugt Formatierungsstring
    cora = textscan(fid, formatstring, 'delimiter', ',');     %   übergibt Inhalt des logfiles an data
%     cora = textscan(fid, formatstring, 'delimiter', '\t');     %   übergibt Inhalt des logfiles an data
    cora= cat(2, cora{:} ); 
    status = fclose(fid);  
    
    cora(strcmp('a', cora(:,2)),2) = {'1'};
    cora(strcmp('b', cora(:,2)),2)  = {'2'};
    cora(strcmp('c', cora(:,2)),2)  = {'3'};
    cora(strcmp('d', cora(:,2)),2)  = {'4'};
    cora(strcmp('a', cora(:,3)),3)  = {'1'};
    cora(strcmp('b', cora(:,3)),3)   = {'2'};
    cora(strcmp('c', cora(:,3)),3)   = {'3'};
    cora(strcmp('d', cora(:,3)),3)   = {'4'};
    cora = cell2mat(cellfun(@str2num, cora, 'UniformOutput', false)); 
    
    pres_out(strcmp('a', pres_out(:,5)),5) = {'1'};
    pres_out(strcmp('b', pres_out(:,5)),5) = {'2'};
    pres_out(strcmp('c', pres_out(:,5)),5) = {'3'};
    pres_out(strcmp('d', pres_out(:,5)),5) = {'4'};
    pres_out(strcmp('a', pres_out(:,6)),6) = {'1'};
    pres_out(strcmp('b', pres_out(:,6)),6) = {'2'};
    pres_out(strcmp('c', pres_out(:,6)),6) = {'3'};
    pres_out(strcmp('d', pres_out(:,6)),6) = {'4'};
  
    pres_out = cell2mat(cellfun(@str2num, pres_out(:,1:3), 'UniformOutput', false)); 
  
    pres_out(pres_out(:, 2)==pres_out(:, 3),3)= 0; 
    pres_out(pres_out(:, 2)== 0 & pres_out(:, 3)==0,:)= []; 
    
    
   cora(~ismember(cora(:,1), pres_out(:,1)),:) = [];
    if length(cora) < length(pres_out)
        pres_out(:,4:6) = [cora(:,1:3); 0,0]; 
    else
       pres_out(:,4:6) = cora(:,1:3); 
    end;
    
       
   
    correct = []; 
    %% first block
    correct(:,1)= sum(pres_out(pres_out(:,1) <= 12, 2) == pres_out(pres_out(:,1) <= 12, 5),2);
    correct(:,2)=  sum(pres_out(pres_out(:,1) <= 12, 2) == pres_out(pres_out(:,1) <= 12, 6),2);
    correct(:,3)=  sum(pres_out(pres_out(:,1) <= 12, 3) == pres_out(pres_out(:,1) <= 12, 5),2);
    correct(:,4)= sum(pres_out(pres_out(:,1) <= 12, 3) == pres_out(pres_out(:,1) <= 12, 6),2);
  
    b1_1 = sum(sum(correct,2)==1); 
    b1_2 = sum(sum(correct,2)==2); 
    
    rt_a1_block1 = (rt_a1_block1(1:size(correct,1)))'; % delete unprocessed trials
    rt_a2_block1 = (rt_a2_block1(1:size(correct,1)))';
    
    b1_1_RT = median(rt_a1_block1(rt_a1_block1~=999.9 & rt_a1_block1>500 & sum(correct(:,1:2),2)==1));
    b1_2_RT = median(rt_a2_block1(rt_a2_block1~=999.9  & rt_a2_block1>500 & sum(correct(:,3:4),2)==1));

    correct = [];
    
    %% second block
    pres_out(pres_out(:,1) <= 12,:) = []; 
    correct(:,1)= sum(pres_out(:, 2) == pres_out(:, 5),2);
    correct(:,2)=  sum(pres_out(:, 2) == pres_out(:, 6),2);
    correct(:,3)=  sum(pres_out(:, 3) == pres_out(:, 5),2);
    correct(:,4)= sum(pres_out(:, 3) == pres_out(:, 6),2);
    
    b2_1 = sum(sum(correct,2)==1); 
    b2_2 = sum(sum(correct,2)==2); 
    
    rt_a1_block2 = (rt_a1_block2(1:size(correct,1)))'; % delete unprocessed trials
    rt_a2_block2 = (rt_a2_block2(1:size(correct,1)))';
    
    b2_1_RT = median(rt_a1_block2(rt_a1_block2~=999.9 & rt_a1_block2>500 & sum(correct(:,1:2),2)==1));
    b2_2_RT = median(rt_a2_block2(rt_a2_block2~=999.9  & rt_a2_block2>500& sum(correct(:,3:4),2)==1));

    correct = [];
    
 
    
    perf = [b1_1 , b1_2, b1_1_RT, b1_2_RT, b2_1, b2_2,b2_1_RT, b2_2_RT];
    perf_headers = {'MR_b1_1' , 'MR_b1_2', 'MR_b1_1stcor_RT', 'MR_b1_2ndcor_RT', 'MR_b2_1', 'MR_b2_2','MR_b2_1stcor_RT', 'MR_b2_2ndcor_RT',};
    
