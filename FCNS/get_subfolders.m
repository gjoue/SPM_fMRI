function sdirs = get_subfolders(indir)
    dirstruc = dir(indir);
    dirstruc = dirstruc([dirstruc.isdir]);  % no files, only folders
    dirstruc = dirstruc(~ismember({dirstruc.name},{'.','..'})); % remove dot folders
    sdirs = {dirstruc.name};
end