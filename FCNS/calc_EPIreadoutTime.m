%%-------------------------------------------------------------------------
%%                     calculate the EPI readout time for VDM estim
%%-------------------------------------------------------------------------
%% get total EPI readout time of the EPI echo train etc.
%%            - in ms, typically 10s 
%%            = time taken to acquire all of the phase encode steps required to cover k-space (i.e., one image slice)

function ret = calc_EPIreadoutTime(nechoes,phaseAccelFactor,echoSpacing) 
    %% EPI readout time = (number of phase echo * echo-spacing)/(phase acceleration factor)
    %% alternative calc: Total readout time = 1/"Bandwidth Per Pixel Phase Encode", stored in DICOM tag (0019, 1028) --> Example: 1 / 15.625 Hz = 64 ms (Or without GRAPPA: 1 / 7.8 Hz = 128 ms)
    %%    NOTE: "Bandwidth per Pixel" is not the same as "Bandwidth per pixel phase encode"!!!


    ret = (nechoes * echoSpacing) / phaseAccelFactor;
end
