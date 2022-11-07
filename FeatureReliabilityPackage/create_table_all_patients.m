%% create_table_all_patients()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------

function  T_all_patients = create_table_all_patients(str,folder_relative_error,patients,subj_names,radiomics_files2D_true)

% Load Info and ROI for the desired patient
str_data_true = [str '/Data'];

% Load relative error folder for the desired patient
elements_in_folder = dir([folder_relative_error '/*.csv']);

T_all_patients_Dice = table();
T_resampled_aux = table();
T_all_patients = table();

% set indices = true if you want to plot IoU, Dcoeff and other similarity
% indices for each patient
indices = false;

number_of_slices_per_patient = zeros(1,patients);
number_of_slices_per_patient(1,1)=1;

for p = 1 : patients
    
    T_all_patients_Dice_aux = table();
    
    % patient name
    subj  = subj_names{p};

    % Load from T1_MAT Info.mat and ROI.mat
    load([str_data_true,'/', subj, '/T1_MAT/Info.mat']);
    load([str_data_true,'/', subj, '/T1_MAT/ROI.mat']);
    
    file_name_error = elements_in_folder(p).name;
    T_error = readtable([folder_relative_error '/' file_name_error]);

    if contains(radiomics_files2D_true{p}, "merged") 
        
        [volume_mask_ls_init,volume_mask_fwd_init,volume_mask_bwd_init] = merged_masks();   
        val = Info.district_part1;
        if isfield(Info,'district_part3')
            volume_name = 'volume_mask_merged3.mat';
        else
            volume_name = 'volume_mask_merged.mat';
        end

        % mask true
        output_directory = [Info.OutputPathMASK '/MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];
        volume_mask = load([output_directory '/' volume_name]);
        volume_mask = volume_mask.volume_mask;

        % lesion slices
        Nit = length(ROI{val}.slices_merged);
        number_of_slices_per_patient(1, p+1)=Nit;
        merged = true;
        [IoU, Dcoeff, diff_area, diff_perim, ratio_area, ratio_perim, similarity] =...
                segmentation_error_new(subj,val,volume_mask,volume_mask_ls_init,volume_mask_fwd_init,...
                volume_mask_bwd_init, Nit, merged,indices);
        
        T_resampled = table();
        name_column = cell(Nit, 1);
        name_column(:) = {subj};
        slice_column = (1 : 1 : Nit)';
        T_resampled = addvars(T_resampled,name_column,'NewVariableNames','Subj');
        T_resampled = addvars(T_resampled,slice_column,'NewVariableNames','Slice');

        for i = 1:44
            v = T_error{:,i};
            dim_aux = size(T_error);
            dim_aux = dim_aux(1);
            x = 1:1:dim_aux;  
            xq = linspace(1, dim_aux, Nit);  
            vq1  = interp1(x,v,xq);
            vq1 = vq1';
            column_name = T_error.Properties.VariableNames{i};
            T_resampled = addvars(T_resampled,vq1,'NewVariableNames',column_name);
        end
    else

        Nval = length(ROI);

        for val = 1 : Nval
            if ROI{val}.Enable
                % already modified mask
                output_directory = [Info.OutputPathMASK '/MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];
                volume_mask = load([output_directory '/volume_mask.mat']);
                volume_mask = volume_mask.volume_mask;

                % automatic mask
                volume_mask_ls_init = ROI{val}.MasksSlicesLevelSet;
                volume_mask_fwd_init = ROI{val}.MasksSlicesForward;
                volume_mask_bwd_init = ROI{val}.MasksSlicesBackward;

                % lesion slices
                Nit = length(ROI{val}.RoiSlice);
                number_of_slices_per_patient(1, p+1)=Nit;
                merged = 0;
                [IoU, Dcoeff, diff_area, diff_perim, ratio_area, ratio_perim, similarity] =...
                        segmentation_error_new(subj,val,volume_mask,volume_mask_ls_init,volume_mask_fwd_init,...
                        volume_mask_bwd_init, Nit, merged,indices);

                T_resampled = table();
                name_column = cell(Nit, 1);
                name_column(:)={subj};
                slice_column = (1:1:Nit)';
                T_resampled = addvars(T_resampled, name_column,'NewVariableNames','Subj');
                T_resampled = addvars(T_resampled,slice_column,'NewVariableNames','Slice');

                for i = 1:44
                    v = T_error{:, i};
                    x = 1:1:ROI{val}.number_of_slices_after_resize;
                    xq = linspace(1, ROI{val}.number_of_slices_after_resize, Nit);
                    vq1  = interp1(x, v, xq);
                    vq1 = vq1';
                    column_name = T_error.Properties.VariableNames{i};
                    T_resampled = addvars(T_resampled,vq1,'NewVariableNames',column_name);
                end
            end
        end
    end

    s =size(T_resampled);   
    
    T_resampled_aux = [T_resampled_aux; T_resampled];
    T_all_patients_Dice_aux.Dice = Dcoeff';
    T_all_patients_Dice = [T_all_patients_Dice;T_all_patients_Dice_aux];

    T_all_patients = [T_all_patients_Dice,T_resampled_aux];

end
end