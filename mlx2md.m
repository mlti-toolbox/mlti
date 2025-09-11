% exmples_mlx2md.m
% Converts all .mlx files in examples/ to .md in docs/_includes/examples

% Input and output directories
inputDir = fullfile(pwd, 'examples');
outputDir = fullfile(pwd, 'docs', '_includes', 'examples');

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Get list of all .mlx files in examples/
mlxFiles = dir(fullfile(inputDir, '*.mlx'));

for k = 1:length(mlxFiles)
    mlxFile = fullfile(inputDir, mlxFiles(k).name);
    
    % Output file name
    [~, name, ~] = fileparts(mlxFiles(k).name);
    mdFile = fullfile(outputDir, [name, '.md']);
    
    % Convert .mlx to .md
    % Method 1: Using MATLAB Live Script export (recommended)
    matlab.internal.liveeditor.openAndConvert(mlxFile, mdFile);
    
    fprintf('Converted %s -> %s\n', mlxFile, mdFile);
end