%% Show_ROI_ADC()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function is used to show the current slice of the MR image (ADC) and
% the segmentation result within the GUI (GUI_Check_ADC).
% -------------------------------------------------------------------------
%%%% called by: Go_Next_Slice_ADC()
%%%%            Go_Previous_Slice_ADC()
%%%%            Replace_With_Previous_slice_ADC()         
%%%%            Replace_With_Next_slice_ADC() 
%%%%            GUI_Check_ADC()

function Show_ROI_ADC(val,it)
global Info;
global gui_ROI;
global ROI;
global gui_ADC;

xlim = get(gui_ADC.ax,'xlim');
ylim = get(gui_ADC.ax,'ylim');

I_MR = ...
   dicomread([Info.ADC_directory, gui_ROI.slash_pc_mac,Info.FilesListADC(it).name]);

% I_MR_zoom = I_MR(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
%         ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
I_MR_zoom = I_MR;

if gui_ADC.first_opening == 0
    gui_ADC.first_opening = 1;
    gui_ADC.sup_hu = max(max(I_MR));
    gui_ADC.inf_hu = min(min(I_MR));
    CLim_max = gui_ADC.sup_hu;
    CLim_min = gui_ADC.inf_hu;
    set(gui_ADC.SLIDERwindowDown_edit,'string',CLim_min);
    set(gui_ADC.SLIDERwindowUp_edit,'string',CLim_max);
    set(gui_ADC.ax, 'CLim', [CLim_min CLim_max]);
    set(gui_ADC.ax_ls, 'CLim', [CLim_min CLim_max]);
    
end
    
imshow(I_MR_zoom,'parent',gui_ADC.ax);
CLim_max = gui_ADC.sup_hu;
CLim_min = gui_ADC.inf_hu;
set(gui_ADC.ax, 'CLim', [CLim_min CLim_max]);

%ls
imshow(I_MR_zoom,'parent',gui_ADC.ax_ls);
set(gui_ADC.ax_ls, 'CLim', [CLim_min CLim_max]);

if ROI{val}.first_next_ADC(it) == 0

    B_ls = bwboundaries(imrotate(ROI{val}.MasksADC(:,:,it),90));
    if ~isempty( B_ls)
        % Create a vector so that it is = 1 if there is a mask, otherwise
        % it is = 0 (vector indicized with it2show)
        ROI{val}.pos_ADC_masks{it} = 1;
        B_ls = [B_ls{1,1}(:,2),B_ls{1,1}(:,1)];
        B_ls = B_ls(1:4:end,:);
        righe = size(B_ls);
        if righe(1)>30
            BW = poly2mask(B_ls(:,1),B_ls(:,2),size(I_MR,1),size(I_MR,2));
            SE = strel(ones(3));
            BW = imerode(BW, ones(3));
            BW = bwboundaries(BW);
            B_ls = [BW{1,1}(:,2),BW{1,1}(:,1)];
            B_ls = B_ls(1:4:end,:);
        end

        gui_ADC.ROI_ls(it) = drawpolygon('Parent',gui_ADC.ax_ls,...
            'Position',B_ls,'Color', 'red', 'FaceAlpha', 0);%, 'MarkerSize',4);
    else
        ROI{val}.pos_ADC_masks{it} = 0;

    end
else

    if ROI{val}.pos_ADC_masks{it} == 1

        ROI_pos = [ROI{val}.aux_pos_ls_ADC(it).row,...
            ROI{val}.aux_pos_ls_ADC(it).col];
        gui_ADC.ROI_ls(it) = drawpolygon('Parent',gui_ADC.ax_ls,...
            'Position',ROI_pos,'Color', 'red', 'FaceAlpha', 0);%, 'MarkerSize',4);

    end

end

% Enable/disable the "delete current mask" button
if ROI{val}.pos_ADC_masks{it} == 1
    set(gui_ADC.delete_mask,'enable','on')
else
    set(gui_ADC.delete_mask,'enable','off')
end

end

