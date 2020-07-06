function startLogging(scriptFullPath, cfg)
   
    [~,thisScript,~] = fileparts(scriptFullPath);
    
    logfn = fullfile(cfg.scriptLogs,[thisScript 'varargin' '.log']);
    diary(logfn);
    
    fprintf('\n============== SCRIPT %s STARTED [%s] ===========\n', thisScript, datetime('now'));
end