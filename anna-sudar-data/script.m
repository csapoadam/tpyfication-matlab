
INPUT_FILE = 'data/inputs_only_web.csv'; %'inputs_only_pdfs.csv';
INPUT_TABLE_COLS = {'web'}; %{'pdf'};

INPUT_FILE_OUTS = 'data/outputs.csv'; %% KEEP THIS, this is fixed
DEP_VAR_NAME = 'web_within_space'; %'pdf_within_space'; % or video, image, ppt, web

GRID_FROM_TO_STEPS = [0, 10, 1];
OUT_TABLE_COLUMNS = [INPUT_TABLE_COLS DEP_VAR_NAME];
OUTPUT_FILE = 'generated_web_to_web2.csv'; %'generated_pdf_to_pdf.csv';

function grid = create_grid (inputs_froms_tos_steps, input_cols)
    %% inputs_froms_tos_steps should either have format:
    %% [[from1, to1, step1]; ...; [fromN, toN, stepN]]
    %% ... with N rows and 3 columns
    %% ... if input_cols is a 1-by-N cell; or
    %% [from, to, step] - in which case the same from, to and step
    %% ... values will be applied to all columns
    [num_fromtosteps, ~] = size(inputs_froms_tos_steps);
    [~, num_cols] = size(input_cols);
    
    froms_tos = repmat(inputs_froms_tos_steps, max(num_cols, num_fromtosteps) / num_fromtosteps, 1);

    coordinates = cell(1, num_cols);
    for col = 1:num_cols
        from_to = froms_tos(col, :);
        coordinates{col} = from_to(1) : from_to(3) : from_to(2);
    end

    outputs_cell = cell(1, num_cols);
    [outputs_cell{:}] = ndgrid(coordinates{:});

    % Convert each grid to a column vector and concatenate them horizontally
    grid = cell2mat(cellfun(@(x) x(:), outputs_cell, 'UniformOutput', false));
end


table_inputs = readtable(INPUT_FILE);
table_outputs = readtable(INPUT_FILE_OUTS);

table = [table_inputs array2table(table_outputs.(DEP_VAR_NAME))];
table.Properties.VariableNames = OUT_TABLE_COLUMNS;

disp('head of table is:')
head(table)

disp('Fitting model...')
model = fitrauto(table, DEP_VAR_NAME);

full_grid = create_grid(GRID_FROM_TO_STEPS, INPUT_TABLE_COLS);

full_predictions = predict(model, full_grid);
full_full = [full_grid, full_predictions];

out_table = array2table(full_full);
out_table.Properties.VariableNames = OUT_TABLE_COLUMNS;
disp('a few predictions:')
head(out_table)

writetable(out_table, OUTPUT_FILE);



