%%  correlation_coefficients
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function:
% 1) computes radiomics feature's relative errors with the function 
%    create_df_error_csv.m
% 2) creates the 4 coefficients matrices Quality, Consistency, Robustness,
%    Instability with the function create_correlation_matrix.m
% 3) compute correlation coefficients with the function 
%    compute_correlation_coefficients.m 
% 4) creates a scatter plot for each radiomics feature
% -------------------------------------------------------------------------
% Reference: 
% 2022 I. Cama, V. Candiani, L. Roccatagliata, P. Fiaschi, G. Rebella, 
% M. Resaz, M. Piana and C. Campi, "Segmentation accuracy and the 
% reliability of radiomics features", submitted.


% id can be omitted, in that case the function takes all the analyzed
% patients from their respective folders
id={'M002';'M003';'M004';
    'M005';'M006';'M008';
    'M009';'M010';'M011';
    'M013';'M014';'M017';
    'M018';'M019';'M021';
    'M022';'M025';'M026';
    'M027';'M028';'M029';
    'M030';'M031';'M032';
    'M033';'M034';'M035';
    'M037';'M038';'M039';
    'M040';'M043';'M044';
    'M045';'M046';'M048';};

% Here: change the path to the folder where data_true and data_auto are stored  
str = '/~/GUI_Meningioma/Data';
[folder_relative_error,patients,subj_names, radiomics_files2D_auto, radiomics_files2D_true] = create_df_error_csv(str,id);

T_all_patients = create_table_all_patients(str,folder_relative_error,patients,subj_names,radiomics_files2D_true);

%% QUALITY MATRIX
M_quality = create_correlation_matrix('quality');

%% CONSISTENCY MATRIX
M = create_correlation_matrix('consistency');

%% ROBUSTNESS MATRIX
M_robustness = create_correlation_matrix('robustness');

%% INSTABILITY MATRIX
M_instability = create_correlation_matrix('instability');

%%
T_metrics = compute_correlation_coefficients(T_all_patients,M_quality,M,M_robustness,M_instability);

%%
scatter_plots_features(T_all_patients)

