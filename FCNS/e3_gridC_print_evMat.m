%% print events, ordered by onset timestamp
function e3_gridC_print_evMat(fid,evtimemat,onsetCol)
    format long g;
    
    [~, i_sort]  = sort(cell2mat(evtimemat(:,onsetCol)));
    evmat2print = evtimemat(i_sort,:)';
    
    if size(evtimemat,2) == 5
       % fprintf(fid,"%s\t%.2f\t%.2f\t%.2f\t%s\n",evmat2print{:});    
        fprintf(fid,"%s\t%.2f\t%.2f\t%.2f\t%.2f\n",evmat2print{:});    
    else
        fprintf(fid,"%s\t%.2f\t%.2f\t%.2f\n",evmat2print{:});
    end
end