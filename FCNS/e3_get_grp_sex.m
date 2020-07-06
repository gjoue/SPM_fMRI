function [vec_sex, vec_grp, map_sex, map_grp] = e3_get_grp_sex(subjList, subjxls)
    nSs = length(subjList);
    vec_sex = zeros(nSs,1);
    vec_grp = zeros(nSs,1);
    
    subjdata       = e3_load_subjInfo(subjxls);
    subjdata.GROUP = regexprep(subjdata.GROUP,'_.*','');

    lvl_sex = unique(subjdata.Sex);
    lvl_grp = unique(subjdata.GROUP);
    
    code_sex = 1:length(lvl_sex);
    code_grp = 1:length(lvl_grp);
    
    map_sex = containers.Map(lvl_sex, code_sex);
    map_grp = containers.Map(lvl_grp, code_grp);
    
    for ss = 1:nSs 
        subj   = subjList(ss);
        subjID = sprintf('sub%03d',subj);

        sex    = subjdata.('Sex'){subjdata.PbNr==ss};
        grp    = subjdata.('GROUP'){subjdata.PbNr==ss};
        
        vec_sex(ss) = map_sex(sex);
        vec_grp(ss) = map_grp(grp);
    end
end