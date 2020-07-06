function [subsetIDs, subsetGCIDs] = e3_get_subsetXsexNgrp(sex,grp,subjList,cfg)
    % given list of subjects (subjList), grab subset that fall into given
    % sex and grp
    subjdata = e3_load_subjInfo(cfg.files.subjdata);

    subsetIDs   = table2array(subjdata( strcmp(subjdata.Sex,sex) & contains(subjdata.GROUP,grp),'PbNr'));
    subsetGCIDs = table2cell(subjdata( strcmp(subjdata.Sex,sex) & contains(subjdata.GROUP,grp),'PbNr_GridCell'));

    [subsetIDs, ia, ~] = intersect(subsetIDs, subjList);
    subsetGCIDs        = {subsetGCIDs{ia}};
end