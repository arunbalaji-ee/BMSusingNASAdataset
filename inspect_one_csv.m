clear; clc;

% Get full path of this script
scriptPath = mfilename('fullpath');
projectRoot = fileparts(scriptPath);        % scripts/
projectRoot = fileparts(projectRoot);       % NASA_Battery_Project/

% Base data directory
dataRoot = fullfile(projectRoot, 'data');

% Recursively find all CSV files
files = dir(fullfile(dataRoot, '**', '*.csv'));

% Remove metadata.csv explicitly
files = files(~strcmp({files.name}, 'metadata.csv'));

% Safety check
if isempty(files)
    error('No CSV files found. Check folder structure.');
end

% Pick ONE file for inspection
sampleFile = fullfile(files(1).folder, files(1).name);

% Read CSV
T = readtable(sampleFile);

% Display structure
disp('Column names:')
disp(T.Properties.VariableNames)

disp('First few rows:')
head(T)
