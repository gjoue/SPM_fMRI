 function [cnam, cwgt, ctyp] = specify_TcontrXrun(SPM,conVec0,patt1,patt2,lab1,lab2,lab1c,lab2c)
     i = 0;
     
     %% contrasts per run
     for runIdx = 1:length(SPM.Sess)
        conVecAR     = conVec0;
        con1  = sprintf('Run%d_%s', runIdx, lab1c);
        con2 = sprintf('Run%d_%s', runIdx, lab2c);

        i1   = find(~cellfun('isempty', regexp(SPM.xX.name, ['Sn(' num2str(runIdx) '.*' patt1])));
        
        if ~isempty(patt2)
            i2   = find(~cellfun('isempty', regexp(SPM.xX.name, ['Sn(' num2str(runIdx) '.*' patt2])));        
            conVecAR(i2) = -1;
        end
        

        conVecAR(i1) = 1;

        i=i+1;
        cnam{i} = con1;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';
        fprintf(1,'Contrast %s (size %s)\n',con1,num2str(size(conVecAR))); 

        i=i+1;
        conVecAR = -conVecAR;
        cnam{i} = con2;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';
        fprintf(1,'Contrast %s (size %s)\n',con1,num2str(size(conVecAR))); 

     end

     %% contrasts averaged across runs
    conVecAR     = conVec0;
    
    con1 = sprintf('RunAll_%s', lab1c);
    con2 = sprintf('RunAll_%s', lab2c);

    i1     = find(contains(SPM.xX.name,patt1));
    conVecAR(i1) = 1;

    if ~isempty(patt2)
        i2     = find(contains(SPM.xX.name,patt2));       
        conVecAR(i2) = -1;
    end
     
    i=i+1;
    cnam{i} = con1;
    cwgt{i} = conVecAR';	
    ctyp{i} = 'T';

    i=i+1;
    cnam{i} = con2;
    cwgt{i} = -conVecAR';	
    ctyp{i} = 'T';
    fprintf(1,'Contrast %s (size %s)\n',con1,num2str(size(conVecAR)));

    %% separate contrasts for i1 and i2
    %% (simple contrasts)
    if ~isempty(patt2)
        i=i+1;
        cnam{i} = con1;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';

        i=i+1;
        conVecAR = -conVecAR;
        cnam{i} = con2;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';  

        con1 = sprintf('RunAll_%s', lab1);
        con2 = sprintf('RunAll_%s', lab2);

        i=i+1;
        conVecAR = conVec0;
        conVecAR(i1) = 1;
        cnam{i} = con1;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';  

        i=i+1;
        conVecAR = conVec0;
        conVecAR(i2) = 1;
        cnam{i} = con2;
        cwgt{i} = conVecAR';	
        ctyp{i} = 'T';  
    end
 end