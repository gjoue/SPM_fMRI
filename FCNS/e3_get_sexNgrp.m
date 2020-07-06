function [subjSexGrp,nSsXgrp] = e3_get_sexNgrp(subjdata,subjList)
    % given list of subjects (subjList), grab sex/grp for them and count
    % how many per sex x grp category
    nSsXgrp = table;
    
    subjSexGrp       = subjdata( subjList, {'PbNr','Sex','GROUP'} );
    subjSexGrp.GROUP = regexprep( subjSexGrp.GROUP, '_.*','' );
    
    
    sexgrp = strcat(subjSexGrp.Sex,'_',subjSexGrp.GROUP);
        
    c =  categorical(sexgrp);
    nSsXgrp.sex_grp = categories(c);
    nSsXgrp.count   = countcats(c);
    
    
end