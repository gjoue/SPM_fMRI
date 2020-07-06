%% Add some contrasts to GridCat GLM1 to check signal quality
function e3_GridCat_GLM1_addCheckContr(subjID, GCcfg, cfg)

    spm('Defaults','fMRI');
    global defaults;
    global UFp; UFp = 0.001;
 
    
    for ff=GCcfg.GLM.rotatefolds
        % x-fold symmetry value that the model is testing for
        GCcfg.GLM.xFoldSymmetry       = ff;

        % Specify data directory for this GLM
        % The directory will be created if it does not exist
        GLM1_dir = e3_gridC_get_GLM1dir(subjID, cfg, GCcfg);

        try
            cd(GLM1_dir);
        catch
            warning('need to run estimation script first -- no directory %s', GLM1_dir);
            continue
        end
        
        ncons = numel(dir(fullfile(GLM1_dir,'con*')));
        
        if ~cfg.grid.GLM1_replaceContr
            if ( ncons > 1 ) %% already added contrasts, so skip
                warning('Sanity check contrasts already added to %s, fold %d -- skipping...',subjID, ff);
                continue
            end
        end
        
        fprintf('ADDING CONTRASTS TO.....\n');
        fprintf('\t%s [%s]\n',GLM1_dir, datestr(now));


        %% load subj's SPM.mat
        load(fullfile(GLM1_dir,'SPM.mat'));

        ipm     = find(contains(SPM.xX.name,'pmod'));
        iunused = find(contains(SPM.xX.name,'Unused'));
        inuis   = find(contains(SPM.xX.name,'R.') | contains(SPM.xX.name,'spike') | contains(SPM.xX.name,'constant'));

        conVec1 = ones(size(SPM.xX.name)); 
        conVec0 = zeros(size(SPM.xX.name)); 

        conMat1 = diag(conVec1); 

        try
            %% Add extra contrasts to what contrasts have already been defined
            ocon = length(SPM.xCon);            %% default contrasts
        catch
            ocon = 0;
        end

        %% SPM5 doesn't seem to automatically initialize SPM.xCon, so do it
        %% manually; otherwise get an error that
        %% "Subscripted assignment between dissimilar structures."
        if cfg.grid.GLM1_replaceContr || ocon == 0 
            ocon = 0;
            SPM.xCon = struct( 'name',{{'init'}}, 'STAT', 1, 'c', 1, 'X0', 1, ...
                 'iX0', {{'init'}}, 'X1o', 1, 'eidf', [], 'Vcon', [],  'Vspm', [] );
        end

        %eb = eye(SPM.xBF.order);			%% basis functions
        clear cnam;
        clear cwgt;
        clear ctyp;
        clear conMatAR;
        clear conVecAR;

        i=1;
        con = 'EOF';

        conMatAR = conMat1;


        conMatAR(ipm, ipm)        = 0;
        conMatAR(iunused, iunused) = 0;
        conMatAR(inuis, inuis)    = 0;

        cnam{i} = con;
        cwgt{i} = conMatAR;	
        ctyp{i} = 'F';
        fprintf(1,'Contrast %s (size %d %d) \n',con,num2str(size(conMatAR)));



        i=i+1;
        con = 'cue-feedback';

        i1     = find(contains(SPM.xX.name,'cue'));
        i2     = find(contains(SPM.xX.name,'feedback'));
        conVecAR = conVec0;
        conVecAR(i1) = 1;
        conVecAR(i2) = -1;

        cnam{i} = con;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';
        fprintf(1,'Contrast %s (size %s)\n',con,num2str(size(conVecAR)));    

        i=i+1;
        con = 'feedback-cue';

%            i1     = find(contains(SPM.xX.name,'cue'));
%            i2     = find(contains(SPM.xX.name,'feedback'));
        conVecAR = conVec0;
        conVecAR(i1) = -1;
        conVecAR(i2) = 1;

        cnam{i} = con;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';
        fprintf(1,'Contrast %s (size %s)\n',con,num2str(size(conVecAR)));    


        conVecAR = conVec0;
        if GCcfg.GLM.TNS7T_align
            
            patt1 = '_aligned';
            patt2 = '_misaligned';
            
            lab1  = 'alignedWithPolarAxis';
            lab2  = 'misalignedWithPolarAxis';

            lab1c  = 'alignedWithPolarAxis-misalignedWithPolarAxis';
            lab2c  = 'misalignedWithPolarAxis-alignedWithPolarAxis';
            
            [t_nam, t_wgt, t_typ] = specify_TcontrXrun(SPM,conVec0,patt1,patt2,lab1,lab2,lab1c,lab2c);
            
            cnam = [cnam t_nam];
            cwgt = [cwgt t_wgt];
            ctyp = [ctyp t_typ];
            
        elseif GCcfg.GLM.TNS7T_pm 
            patt1        = '-alignedWithPolarAxis';
            patt2        = '';
            
            lab1         = 'alignMeasWithPolarAxis';
            lab2         = '-alignMeasWithPolarAxis';
            lab1c        = lab1;
            lab2c        = lab2;

            [t_nam, t_wgt, t_typ] = specify_TcontrXrun(SPM,conVec0,patt1,patt2,lab1,lab2,lab1c,lab2c);
            
            cnam = [cnam t_nam];
            cwgt = [cwgt t_wgt];
            ctyp = [ctyp t_typ];
            
        else
            con     = 'Translation-Still';
            rcon    = 'Still-Translation';
            %i1     = find(contains(SPM.xX.name,'GridEvent-Translation*bf'));
            i10     = find(contains(SPM.xX.name,'GridEvent-Transl'));
            i1x     = find(contains(SPM.xX.name,'pmod'));
            i1      = setdiff(i10,i1x);
            i2     = find(contains(SPM.xX.name,'Still'));
            conVecAR(i1) = 1;
            conVecAR(i2) = -1;
        end
     
        for c = 1:length(cnam)
            if ischar(cnam{c})
                fprintf(1,'Adding to SPM.xCon...con %d: %s\n', c, cnam{c});

%                     clear cw;
%                     cw = [cwgt{c} zeros(size(cwgt{c},1),nruns)]';	% pad with zero for constant for each run

                SPM.xCon(c+ocon)     = spm_FcUtil('Set',cnam{c},ctyp{c},'c',cwgt{c},SPM.xX.xKXs);
            end
            %% Fc = spm_FcUtil('Set',name, STAT, set_action, value, sX)
            %%
            %%- Set will fill in the contrast structure, in particular
            %%- c (in the contrast space), X1o (the space actually tested) and
            %%- X0 (the space left untested), such that space([X1o X0]) == sX.
            %%- STAT is either 'F' or 'T';
            %%- name is a string describing the contrast.
            %%
            %%- There are three ways to set a contrast :
            %%- set_action is 'c','c+' : value can then be zeros.
            %%- dimensions are in X',
            %%- if c+ is used, value is projected onto sX';
            %%- iX0 is set to 'c' or 'c+';
            %%- set_action is 'iX0' : defines the indices of the columns
            %%- that will not be tested. Can be empty.
            %%- set_action is 'X0' : defines the space that will remain
            %%- unchanged. The orthogonal complement is
            %%- tested; iX0 is set to 'X0';

        end


        % and evaluate
        %----------------------------------------------------------------------
        spm_contrasts(SPM);
    end
end

