% The purpose of this code is to process and label the vehicle motion data for subsequent analysis and application
% 
% Read the CSV file
f2 = readtable('/media/lcy/数据集NGSIM数据集/I-80-Emeryville-CA/vehicle-trajectory-data/0400pm-0415pm/trajectories-0400-0415-addfeature.csv');

% Calculate the number of CL（change lane） sets
CL_num = floor(height(f2) / 41);

% Calculate object list
obj_list = (41 * (1:CL_num)) - 1;
obj_list = obj_list(2:end);

% Initialize the array used to store the TR (Turn Right) and TL (Turn Left) rows.
TR_row = [];
TL_row = [];

% Calculate TR(turn right) rows
for i = obj_list
    if f2.Vehicle_ID(i) == f2.Vehicle_ID(i-1) && f2.Lane_ID(i) == f2.Lane_ID(i-1) + 1
        TR_row = [TR_row, i-40:i-1];
    end
end

% Calculate TL(turn left) rows
for i = obj_list
    if f2.Vehicle_ID(i) == f2.Vehicle_ID(i-1) && f2.Lane_ID(i) == f2.Lane_ID(i-1) - 1
        TL_row = [TL_row, i-40:i-1];
    end
end

% Extract TR and TL data Add a new column called "label" to the TR and TL data to identify the TR and TL rows.
TR40 = f2(TR_row, :);
TR40.label = 2;
TL40 = f2(TL_row, :);
TL40.label = 1;

% Concatenate TR40 and TL40
df_combine = [TR40; TL40];

% Write to CSV file
writetable(df_combine, '/media/lcy/数据集NGSIM数据集/I-80-Emeryville-CA/vehicle-trajectory-data/0400pm-0415pm/trajectories-0400-0415-addlabel.csv');
