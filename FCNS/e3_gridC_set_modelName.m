function GCcfg = e3_gridC_set_modelName(GCcfg, cfg)

    if isempty(strfind( GCcfg.modelname, 'rp' ) )
        if GCcfg.GLM.use.realignParams
            GCcfg.modelname = [GCcfg.modelname '_rp1'];
        else
            GCcfg.modelname = [GCcfg.modelname '_rp0'];
        end
    end
    
    
    if isempty(strfind( GCcfg.modelname, 'sp' ))
        if GCcfg.GLM.nativeSpace
            GCcfg.modelname = [GCcfg.modelname '_spNatv'];
        else
            GCcfg.modelname = [GCcfg.modelname '_spNorm'];
        end
    else
        if GCcfg.GLM.nativeSpace & strfind( GCcfg.modelname, 'spNorm' ) 
            GCcfg.modelname = strrep(GCcfg.modelname,'Norm','Natv');
        elseif ~GCcfg.GLM.nativeSpace & strfind( GCcfg.modelname, 'spNatv' ) 
            GCcfg.modelname = strrep(GCcfg.modelname,'Natv','Norm');
        end
    end
    
    
    if ~strcmp(GCcfg.grid.spdThresh, 'none') &&  isempty(strfind(GCcfg.modelname, 'Q')) && isempty(strfind( GCcfg.modelname, 'T')) 
        
        GCcfg.modelname = sprintf('%s%s%s', GCcfg.modelname, GCcfg.suffix.spdThr, GCcfg.grid.suffix);
        
    end

end