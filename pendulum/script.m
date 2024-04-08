
INPUT_FILE = 'data.csv';
DEP_VAR_NAME = 'force';
OUT_TABLE_COLUMNS = {'cart_velocity','pendulum_angle','pendulum_angular_velocity','force'};
OUTPUT_FILE = 'output.csv';

table = readtable(INPUT_FILE);

disp('head of table is:')
head(table)

disp('Fitting model...')

model = fitrauto(table, DEP_VAR_NAME);

%%%%%%%%% ezt a reszt at kellhet meg irni...
cart_velocities = [-3.14 : 0.1 : 3.14];
pendulum_angles = [min(table.pendulum_angle) : 0.1 : max(table.pendulum_angle)];
pendulum_angvels = [-3.14 : 0.1 : 3.14 ];
[grid_1, grid_2, grid_3] = ndgrid(cart_velocities, pendulum_angles, pendulum_angvels);
full_grid = [grid_1(:), grid_2(:), grid_3(:)];
%%%%%%%%%

full_predictions = predict(model, full_grid);
full_full = [full_grid, full_predictions];

out_table = array2table(full_full);
out_table.Properties.VariableNames = OUT_TABLE_COLUMNS;
disp('a few predictions:')
head(out_table)

writetable(out_table, OUTPUT_FILE);