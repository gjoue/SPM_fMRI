%%-------------------------------------------------------------------------
%%                   MOVE DUMMIES in "dummies" subfolder back out                            
%%-----------------------------------------------------------------
function putDummiesBack(sdirs)
    cd(sdirs.task)
    runs = get_subfolders('.');

    for rr = 1:length(runs)
            run = runs{rr};
            fprintf('%s, %s\n', sdirs.task, run);
            sdirs.run = fullfile(sdirs.task,run);

            sdirs.dummies = fullfile(sdirs.run,'dummies');
            unix(['rmdir ' sdirs.dummies]);
    end
end