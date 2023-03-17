%% Write_3D_Masks_general()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function saves the volume mask associated to each ROI in .mat 
% format.
% -------------------------------------------------------------------------
%%%% called by: Save_Last_Slice()
%%%%            Save_Last_Slice_ADC()   
%%%% call:      dicom23D()

function Write_3D_Masks_general(row, col, num_slices, pixelIdxList,...
    finalMasks, outputName, initial_slice_mask, last_slice_mask, enable_field_name)

global ROI;
global Info;
global gui_ROI;

warning off;

Nval = length(ROI);

% Save the MR image volume (stacked slices)
[volume_image, ~, ~] = dicom23D(Info.InputPath);

if ~exist(Info.OutputPathMASK,'dir'), mkdir(Info.OutputPathMASK); end

str_save = [Info.OutputPathMASK gui_ROI.slash_pc_mac 'volume_image.mat'];
save(str_save,'volume_image')

for val = 1 : Nval 
    enable = getfield(ROI{val},enable_field_name); 

    if enable
        % Initialize the volume
        volume_mask = zeros(row, col, num_slices);

        output_directory = [Info.OutputPathMASK gui_ROI.slash_pc_mac...
            'MASK_' regexprep(ROI{val}.Name,'[^\w'']','')];
        
        if ~exist(output_directory,'dir'), mkdir(output_directory); end
        if ~contains(outputName,"adc")  % if T1 case
            last_slice = getfield(ROI{val},last_slice_mask);
            initial_slice = getfield(ROI{val},initial_slice_mask);
        else
            initial_slice = 1;
            last_slice = num_slices;
        end
        Nit = last_slice - initial_slice + 1;
        pixel_list = getfield(ROI{val},pixelIdxList);
        cell_aux = {};
        for it = 1 : Nit            
            slice_ls = zeros(row, col);
            slice_ls(pixel_list{it}) = 1;
            % Saving masks in ROI
            cell_aux{it} = slice_ls;
        end
        ROI{val} = setfield(ROI{val},finalMasks,cell_aux);
        final_masks = getfield(ROI{val},finalMasks);
        final_maskss = [final_masks{:}];
        aux_mask = reshape(final_maskss, row, col, last_slice - initial_slice + 1);
        volume_mask(:, :, initial_slice : last_slice) = aux_mask; 
        str_save = [output_directory gui_ROI.slash_pc_mac outputName];
        save(str_save,'volume_mask')
        
    end
    
end

end