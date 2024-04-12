

INPUT_FILE = 'data_navi_mxwtime_spPres.csv';
DEP_VAR_NAME = 'spatialPresence';
OUT_TABLE_COLUMNS = {'navigationscore','mxwtime','spatialPresence'};
OUTPUT_FILE = 'output.csv';

table = readtable(INPUT_FILE);

disp('head of table is:')
head(table)

disp('Fitting model...')

model = fitrauto(table, DEP_VAR_NAME);

%%%%%%%%% ezt a reszt at kellhet meg irni...
navigation_scores = [0 : 0.5 : 10];
VRtime = [1,2];
[grid_1, grid_2] = ndgrid(navigation_scores, VRtime);
full_grid = [grid_1(:), grid_2(:)];
%%%%%%%%%

full_predictions = predict(model, full_grid);
full_full = [full_grid, full_predictions];

out_table = array2table(full_full);
out_table.Properties.VariableNames = OUT_TABLE_COLUMNS;
disp('a few predictions:')
head(out_table)

writetable(out_table, OUTPUT_FILE);