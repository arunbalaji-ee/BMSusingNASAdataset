clear; clc;

% Locate project root safely
scriptPath = mfilename('fullpath');
projectRoot = fileparts(fileparts(scriptPath));

% Paths
dataRoot   = fullfile(projectRoot,'data');
resultDir = fullfile(projectRoot,'results');
if ~exist(resultDir,'dir'); mkdir(resultDir); end

% Load metadata
meta = readtable(fullfile(dataRoot,'metadata.csv'));
meta = meta(strcmp(meta.type,'discharge'), :);

% Find all CSV files
files = dir(fullfile(dataRoot,'**','*.csv'));
files(strcmp({files.name},'metadata.csv')) = [];

Results = [];

for k = 1:length(files)

    fprintf('Processing %d / %d : %s\n',k,length(files),files(k).name);

    try
        csvFile = fullfile(files(k).folder, files(k).name);

        data = load_battery_csv(csvFile);
        idx = select_valid_window(data.time);

        % Mean temperature (stored, not used in fitting)
        T_mean = mean(data.temperature(idx),'omitnan');

        params = estimate_2RC_parameters( ...
            data.time(idx), ...
            data.voltage(idx), ...
            data.current(idx));

        row = get_metadata_row(meta, files(k).name);
        if isempty(row); continue; end

        Results = [Results; table( ...
            string(files(k).name), ...
            string(row.battery_id), ...
            row.Capacity, ...
            T_mean, ...
            params.R0, params.R1, params.C1, ...
            params.R2, params.C2, ...
            'VariableNames', ...
            {'filename','battery_id','Capacity','T_mean','R0','R1','C1','R2','C2'})];

    catch
        fprintf('Skipped %s\n',files(k).name);
    end

    if mod(k,100)==0
        save(fullfile(resultDir,'RC_partial.mat'),'Results');
    end
end

save(fullfile(resultDir,'RC_all.mat'),'Results');
writetable(Results, fullfile(resultDir,'RC_all.csv'));

disp('RC extraction completed.');
