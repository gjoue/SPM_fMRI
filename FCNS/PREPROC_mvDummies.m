%%-------------------------------------------------------------------------
%%                   MOVE DUMMIES                            
%%-----------------------------------------------------------------
%% moves first ndummies from each MRI scan/session in a task folder to
%% assumes that in the task folder dirTask, the different MR sessions are 
%% in separate subfolders and the functional files are sequentially numbered
%% and follow the naming convention  f.*000n-01.nii, where n marks the vol#
function PREPROC_mvDummies(dirTask,ndummies)
    cd(dirTask)
    runs = get_subfolders('.');
%     tdirs = dir;
%     tdirs = tdirs(~ismember({tdirs.name},{'.','..'}));
%     runs = {tdirs.name};
    for rr = 1:length(runs)
            run = runs{rr};
            fprintf('\t%s, %s\n', dirTask, run);
            dirRun = fullfile(dirTask,run);

            dirDummies = fullfile(dirRun,'dummies');
            fprintf('Moving first %d scans into folder %s',ndummies,dirDummies);
            
            if ~exist(dirDummies,'dir')
                mkdir(dirDummies);
            end

            img = dir(dirRun);
            img = {img.name};
            
            iimg = find(~cellfun(@isempty,regexp(img,sprintf('^f.*000[1-%d]-01.nii',ndummies))));
            img2mv = {img{iimg}};
            
            for j = 1:length(img2mv)
                fprintf('moving %s\n',img2mv{j});
               movefile(fullfile(dirRun,img2mv{j}),fullfile(dirDummies,img2mv{j}));
            end
    end
end