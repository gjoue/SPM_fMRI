%%-------------------------------------------------------------------------
%%                     AVERAGE IMAGES
%%-------------------------------------------------------------------------
function avgImg(infiles,outname)
    infiles    = cellstr(infiles);  % if already cell, doesn't change anyth
    nfiles     = size(infiles,1);
    
    V          = spm_vol(infiles);
    Vidat       = spm_read_vols( V{1} );
    Vmoutdat   = zeros(size(Vidat));
    
    for ii=1:nfiles
        Vidat     = spm_read_vols( V{ii} );
        Vmoutdat = Vmoutdat + Vidat/nfiles;
    end            
    
    % write out
    Vmout          = V{1};  % copy input img info for output image
    Vmout(1).fname = outname;
    spm_write_vol(Vmout(1), Vmoutdat);
end