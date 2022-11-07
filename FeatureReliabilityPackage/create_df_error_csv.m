function [folder_relative_error,patients,subj_names, radiomics_files2D_auto, radiomics_files2D_true] = create_df_error_csv(str,id)

% this function selects all radiomics files, and favors radiomics files
% "merged" if there are any
[radiomics_files2D_auto,patients,subj_names] = find_files_radiomics('auto',str,id);
[radiomics_files2D_true,patients,subj_names] = find_files_radiomics('true',str,id);

% Make folder to save relative errors for each patient  
folder_relative_error = [str '/df_relative_errors'];
if ~exist(folder_relative_error,'dir'), mkdir(folder_relative_error); end

% first useful feature (in data frames 2D)
init = 9;

% compute df_error_noquant with radiomics files auto and true
for p= 1:patients

    str_true = radiomics_files2D_true{p};
    str_auto = radiomics_files2D_auto{p};
    file_auto = readtable(str_auto);
    file_true = readtable(str_true);
    table_auto = file_auto(:,init:end);
    table_true = file_true(:,init:end);

    err_rel = abs((table_auto{:,:}-table_true{:,:})./table_true{:,:});
    table_err_rel = array2table(err_rel,'VariableNames',string(file_true.Properties.VariableNames(init:end)));

    % save csv files with relative errors of the considered patients  
    writetable(table_err_rel, [folder_relative_error '/df_relative_error_' subj_names{p} '.csv'],'WriteRowNames',true)
end
end