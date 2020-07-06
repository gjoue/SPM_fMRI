
%%-------------------------------------------------------------------------
%%                   5b.  PLOT SPIKES with movement
%%-----------------------------------------------------------------
%% output plots tagged signal spikes from Rik Henson's spm5spikes script
%% against translation and rotation parameters (realignment parameters)
%% saves plots in dirOut
function PREPROC_SPIKEPLOT(subj,task,dirTask,spikeThresh,dirOut)
    cd(dirTask)
    runs = get_subfolders('.');

    for rr = 1:length(runs)
        run = runs{rr};

        fprintf('%s, %s\n', dirTask, run);
        dirRun = fullfile(dirTask,run);
        
        rpfilels = dir(fullfile(dirRun,'rp*txt'));
                
        if length(rpfilels) > 0
            rpfile = strcat(dirRun,'/',rpfilels(1).name);
            rp = dlmread(rpfile);
            spikes = load(sprintf('%s/spikes_%s_%s_%s_thr%d.mat',...
                dirRun,subj,task,run,spikeThresh));

            clear title; clear legend; clear ax;
            fh=figure;
            ax(1) = subplot(2,1,1); plot(rp(:,1:3));                  
            title('translation (mm)'); 
            legend('x','y','z','location','northeastoutside');
            hold on; 
            %% plot vertical lines indicating spikes tagged
            ylim = get(gca,'YLim');
            if (~isempty(spikes.adout))     % was spikes.dout                
                spikes.adout = unique(spikes.adout(:,1));
                for sp=1:length(spikes.adout)
                    x = spikes.adout(sp);
                    line([x,x],ylim,'Color',[.5 .5 .5],'LineWidth',2,'LineStyle',':');
                end
            end
            hold off;

            set(gca,'xlim',[0 size(rp,1)+1]);
            ax(2) = subplot(2,1,2); 
            linkaxes(ax,'x');
            plot(rp(:,4:6)*180/pi); 
            title('rotation (deg)'); 
            legend('p','r','y','location','northeastoutside');
%                    legend('pitch','roll','yaw','location','northeastoutside');
            set(gca,'xlim',[0 size(rp,1)+1]);
            hold on;
            %% plot vertical lines indicating spikes tagged
            ylim = get(gca,'YLim');
            if (~isempty(spikes.adout))
                for sp=1:length(spikes.adout)
                    x = spikes.adout(sp);
                    line([x,x],ylim,'Color',[.5 .5 .5],'LineWidth',2,'LineStyle',':');
                end
            end
            hold off;


            %% save current figure at 300 dpi in color eps
            print(fh,'-dpng','-r300',sprintf('%s/rp_%s_%s_%s_thr%d',dirOut,subj,task,run,spikeThresh));
        else
            fprintf(1,'*** run %d - no movement file found ***\n',r);
        end
    end
end