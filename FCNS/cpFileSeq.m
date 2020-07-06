% moves nfiles from the character array filesSrc from whichEnd (beg,
% end) to the folder dirTarget
function cpFileSeq(filesSrc,dirTarget,nfiles,whichEnd)
    
    switch whichEnd
        case 'beg'
            iis = 1:nfiles;
        case 'end'
            nsrc = size(filesSrc,1);
            iis = nsrc-nfiles+1:nsrc;
    end
    
    for ii=iis
        copyfile( filesSrc(ii,:), dirTarget );
    end