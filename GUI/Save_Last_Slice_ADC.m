%% Save_Last_Slice_ADC()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function:
% - saves the changes of the current mask
% - saves volume mask in mat format (for each ROI)
% - saves global variables ROI and Info
% - calls the radiomics (for ADC).
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()
%%%% call:  radiomics_general()
%%%%        radiomics_general2D()
%%%%        Write_3D_Masks_general()

function Save_Last_Slice_ADC()
global ROI;
global Info;
global gui_ADC;
global gui_ROI;

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Analysis ADC in progress'];
w = waitbar(0,'Analysis in progress','Name','Analysis ADC');
waitbar(0, w,str_wbar);

if ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.it2show} == 1
    % Save the ROIs modified in Show_ROI
    aux = gui_ADC.ROI_ls(gui_ADC.it2show);
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).row = aux.Position(:,1);
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).col = aux.Position(:,2);
else
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).row = [];
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).col = [];
end

if ROI{gui_ADC.val}.first_next_ADC(gui_ADC.it2show) == 0
    ROI{gui_ADC.val}.first_next_ADC(gui_ADC.it2show) = 1;
end

Nval = length(ROI);

% Check whether there are ROIs with no masks (all deleted by the user), set
% another field in ROI which enables only those ROIs with nonzero masks and
% remove the related ADC field
for val = 1 : Nval
    ROI{val}.EnableADC = ROI{val}.Enable;
    if ROI{val}.Enable
        if numel(find([ROI{val}.pos_ADC_masks{:}]==1)) == 0
            ROI{val}.EnableADC = 0;
            % ADC related
            if isfield(ROI{val},'MasksADC')
                ROI{val} = rmfield(ROI{val},'MasksADC');end
            if isfield(ROI{val},'first_next_ADC')
                ROI{val} = rmfield(ROI{val},'first_next_ADC');
            end
            if isfield(ROI{val},'pos_ADC_masks')
                ROI{val} = rmfield(ROI{val},'pos_ADC_masks');
            end
            if isfield(ROI{val},'aux_pos_ls_ADC')
                ROI{val} = rmfield(ROI{val},'aux_pos_ls_ADC');
            end
            if isfield(ROI{val},'RoiSegmentationPixelIdxListADC')
                ROI{val} = rmfield(ROI{val},'RoiSegmentationPixelIdxListADC');
            end
            if isfield(ROI{val},'FinalMasksADC')
                ROI{val} = rmfield(ROI{val},'FinalMasksADC');
            end
            if isfield(ROI{val},'slices_merged_ADC')
                ROI{val} = rmfield(ROI{val},'slices_merged_ADC');
            end
            if isfield(ROI{val},'number_of_slices_after_resize_ADC')
                ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_ADC');
            end
            if isfield(ROI{val},'segmented_slices_adc')
                ROI{val} = rmfield(ROI{val},'segmented_slices_adc');
            end
            if isfield(ROI{val},'number_of_slices_after_resize_merged_ADC')
                ROI{val} = rmfield(ROI{val},'number_of_slices_after_resize_merged_ADC');
            end

        end
    end
end

waitbar(.25,w,str_wbar);
for val = 1 : Nval

    if ROI{val}.EnableADC
        % save the slices for which we have an ADC mask
        ROI{val}.segmented_slices_adc = find([ROI{val}.pos_ADC_masks{:}]==1);
        ROI{val}.RoiSegmentationPixelIdxListADC = cell(1,Info.SizeADC(3));

        Nit = length(Info.FilesListADC);

        for it = 1 : Nit
            if ROI{val}.pos_ADC_masks{it} == 1
                ROI_pos = [ROI{val}.aux_pos_ls_ADC(it).row,...
                    ROI{val}.aux_pos_ls_ADC(it).col];

                bw_ls = poly2mask(ROI_pos(:,1),ROI_pos(:,2),Info.SizeADC(2),Info.SizeADC(1));
                ROI{val}.RoiSegmentationPixelIdxListADC{it} = find(bw_ls);
            else
                ROI{val}.RoiSegmentationPixelIdxListADC{it} = [];
            end

        end

    end

end

mydir = Info.InputPath;
string_mydir  = strfind(mydir,gui_ROI.slash_pc_mac);
subj = mydir(string_mydir(end)-4:string_mydir(end)-1);

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Preparing volume mask ADC'];
waitbar(0.33,w,str_wbar);

Write_3D_Masks_general(Info.SizeADC(2), Info.SizeADC(1), Info.SizeADC(3),'RoiSegmentationPixelIdxListADC',...
    'FinalMasksADC','volume_mask_adc.mat','StartMR','EndMR','EnableADC');   % careful with flipped sizes

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Radiomics analysis ADC in progress'];
waitbar(0.67, w,str_wbar);

% ADC
% radiomics 2D (slice-wise)
quantAlgo = gui_ROI.PopupValueQuant;

radiomics_general2D('volume_image_adc.mat','volume_image_adc','volume_mask_adc.mat','volume_mask',...
    'number_of_slices_after_resize_ADC','globalTextures_ADC','matrix_based_textures_ADC','nonTexture_ADC',...
    [Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics2D_ADC.csv'],...
    Info.PixelSizeADC(1),Info.PixelSizeADC(3), quantAlgo,'EnableADC');

radiomics_general('volume_image_adc.mat', 'volume_image_adc', 'volume_mask_adc.mat', 'volume_mask',...
    'globalTextures_ADC', 'matrix_based_textures_ADC', 'nonTexture_ADC',...
    [Info.OutputPathRadiomics gui_ROI.slash_pc_mac subj '_radiomics_ADC.csv'],...
    Info.PixelSizeADC(1),Info.PixelSizeADC(3), quantAlgo,'EnableADC');

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Radiomics ADC 2D and 3D done!'];
waitbar(0.8, w,str_wbar);

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');

waitbar(1, w,str_wbar);
close(w);

disp('End of ADC analysis and radiomics')

end