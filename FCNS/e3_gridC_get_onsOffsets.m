function [i_onset, i_offset] = e3_gridC_get_onsOffsets(fieldvec)
    i_onset  = diff( [ ~fieldvec(1) ; fieldvec ] ) == 1;  
    i_offset = diff( [ fieldvec ; ~fieldvec(end) ] ) == -1; 
end