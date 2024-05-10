%%
%Make sure that Matlab's current folder is set to the path where the data file is located or that the full path is entered correctly into the readtable and writable functions before running this code. Also, make sure you check that the directory path exists before saving the data, or you may get an error.Create by lcy
% Step 1: Read CSV file
data = readtable('/media/lcy/数据集NGSIM数据集/I-80-Emeryville-CA/vehicle-trajectory-data/0400pm-0415pm/trajectories-0400-0415.csv');

% Step 2: Extract specific columns and calculate position changes and velocities
x = [NaN; diff(data.Local_X)];  % NaN for the first entry to align with Python's 'none'
y = [NaN; diff(data.Local_Y)];  % Same here
vehicleIdChanges = [false; diff(data.Vehicle_ID) ~= 0];  % Detect changes in vehicle ID

% Calculate velocities assuming a timestep of 0.1 seconds
x_v = [NaN; diff(data.Local_X) / 0.1];
y_v = [NaN; diff(data.Local_Y) / 0.1];

% Handling the cases where vehicle ID changes (set to NaN instead of 'none')
x(vehicleIdChanges) = NaN;
x_v(vehicleIdChanges) = NaN;
y(vehicleIdChanges) = NaN;
y_v(vehicleIdChanges) = NaN;

% Step 3: Create a new table including original data and new columns
data.x = x;
data.x_v = x_v;
data.y = y;
data.y_v = y_v;

% Step 4: Clean the data (remove rows with NaN in 'x_v')
data = data(~isnan(data.x_v), :);

% Rename column 'x_v' to 'x_a'
data.Properties.VariableNames{'x_v'} = 'x_a';

% Step 5: Save the new CSV file
writetable(data, '/media/lcy/数据集NGSIM数据集/I-80-Emeryville-CA/vehicle-trajectory-data/0400pm-0415pm/trajectories-0400-0415-addfeature.csv');

% Step 6: Prepare the training data subset
train_data = data(:, {'Vehicle_ID', 'Local_X', 'Local_Y', 'v_Class', 'v_Vel', 'v_Acc', 'x_a', 'Lane_ID'});

% Optionally, display the first few rows of train_data
head(train_data);
