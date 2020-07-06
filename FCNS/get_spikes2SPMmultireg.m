function spikeR = get_spikes2SPMmultireg(spikeMatFileName, nscans)
% INPUTS:
%   1. the mat filename calculated for a given run by Rik Henson's spike.m script
%   2. total number of volumes in that run
% one OUTPUT:
% a binary matrix for SPM.Sess.C.C, with the number of rows matching the number of volumes
%      and a column per spike found

    spikeR = [];
    nspikes = 0;
    
    spikeMat = load(spikeMatFileName);
            
    if ( isfield(spikeMat,'adout') )
        spikesFoundLong = spikeMat.adout; % fields of output of Rik Henson's script when specify output other than default
    elseif ( isfield(spikeMat,'dout') )
        spikesFoundLong = spikeMat.dout;  % fields of default output of Rik Henson's script
    else
        warning('Spike mat file %s not a recognized format. No spikes included', spikeMatFile);
    end

    if(~isempty(spikesFoundLong))
        spikesFound = unique(spikesFoundLong(:,1));
        nspikes = length(spikesFound);

        spikeR.R = zeros(nscans,nspikes);

        for spk=1:nspikes
            spikeR.R( spikesFound(spk), spk ) = 1;
        end

%         SPM.Sess(run).C.C = spikeR;
        spikeR.names = cell(1,nspikes);
        for s = 1:nspikes
            spikeR.names{s} = sprintf('spike%d',s);
        end
%         SPM.Sess(run).C.name = tmp;
    end

        %%
%         mname = spm_select('List', fullfile(fwd,rdn), '^rp_.*\.txt$');
%         mpars = load(fullfile(fwd,rdn,mname));
% 
%         SPM.Sess(run).C.C    = [SPM.Sess(run).C.C mpars];
%         SPM.Sess(run).C.name = [tmp {'x' 'y' 'z' 'p' 'r' 'y'}];
% 
%         nspikes = nspikes+6;
              
end