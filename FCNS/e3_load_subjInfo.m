function subjdata = e3_load_subjInfo(subjFile)
    %[~, ~, subjdata] = xlsread(cfg.files.subjdata,1);
    subjdataOpts                 = detectImportOptions(subjFile, 'NumHeaderLines',1);
    subjdata                     = readtable(subjFile,subjdataOpts,'readVariableNames',true);
    subjdata                     = rmmissing(subjdata,'DataVariables',{'PbNr','PbNr_GridCell'});  % remove rows that have NaN as subject ID for either running or gridcell ID
    %subjdata.Properties.RowNames = cellstr(num2str(subjdata.PbNr));  % label rows by running subj ID
end