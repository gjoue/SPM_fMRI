function [navmat, phasemat] = e3_gridC_populateOnsets(subjNr, sessNr, evlab2print, ev_ons, ev_dur, ev_ang, ev_spd, ev_phaseLab, ev_phaseVec, navmat, phasemat)

   %% ZEROing any angles for TurnLeft and TurnRight --
   if ( isempty(ev_ons) )
       warning('sub%03d - run %d: no %s!\n', subjNr, sessNr, evlab2print);
   else
       % GridCat expects col 5 and 6 of onsets to be whether to include
       % onsets in GLM1 and GLM2, resp -- so do not create onset files with
       % more than 4 cols
%       newnav     = [cellstr(repmat(evlab2print,length(ev_ons),1)), num2cell(ev_ons), num2cell(ev_dur), num2cell(ev_ang), num2cell(ev_spd)];
       newnav     = [cellstr(repmat(evlab2print,length(ev_ons),1)), num2cell(ev_ons), num2cell(ev_dur), num2cell(ev_ang)];

       navmat     = [navmat; newnav];
       phasemat   = [phasemat; newnav, ev_phaseLab];
   end
end