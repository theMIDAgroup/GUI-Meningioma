%% Save_segmentation()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% Auxiliary function that:
% - saves the changes of the current mask
% - saves global variables ROI and Info (useful if the segmentation is 
% not finished but one closes the GUI and wants to save all the changes
% in ROI and Info withouth pushing "DONE" at the end)
% -------------------------------------------------------------------------

function Save_segmentation()
global ROI;
global Info;
global gui_T1;
global gui_ROI;

% save ROIs modified in Show_ROI
aux = gui_T1.ROI_ls(gui_T1.it2show);
ROI{gui_T1.val}.aux_pos_ls(gui_T1.it2show).row = aux.Position(:,1);
ROI{gui_T1.val}.aux_pos_ls(gui_T1.it2show).col = aux.Position(:,2);

if ROI{gui_T1.val}.AlternativeSegmentationList(gui_T1.it2show) ~= 0 
    aux = gui_T1.ROI_fwd(gui_T1.it2show);
    ROI{gui_T1.val}.aux_pos_fwd(gui_T1.it2show).row = aux.Position(:,1);
    ROI{gui_T1.val}.aux_pos_fwd(gui_T1.it2show).col = aux.Position(:,2);
end

if ROI{gui_T1.val}.first_next(gui_T1.it2show) == 0
    ROI{gui_T1.val}.first_next(gui_T1.it2show) = 1;
end

% check radio button and substitute
ix_ls = get(gui_T1.rb_ls,'value');
ix_fwd = get(gui_T1.rb_fwd,'value');

if ix_ls == 1 && ix_fwd == 0
    ROI{gui_T1.val}.SliceChoice(gui_T1.it2show) = 1;   
elseif ix_ls == 0 && ix_fwd == 1
    ROI{gui_T1.val}.SliceChoice(gui_T1.it2show) = 2;
end
    
Nval = length(ROI);

for val = 1 : Nval
    if ROI{val}.Enable

        Nit = length(ROI{val}.RoiSlice);

        for it = 1 : Nit
            if ROI{val}.SliceChoice(it) == 1
                ROI_pos = [ROI{val}.aux_pos_ls(it).row,...
                    ROI{val}.aux_pos_ls(it).col];

                bw_ls = poly2mask(ROI_pos(:,1),ROI_pos(:,2),Info.SizeMR(1),Info.SizeMR(2));
                ROI{val}.RoiSegmentationPixelIdxList{it} = find(bw_ls);

            elseif ROI{val}.SliceChoice(it) == 2
                ROI_pos = [ROI{val}.aux_pos_fwd(it).row,...
                    ROI{val}.aux_pos_fwd(it).col];

                bw_fwd = poly2mask(ROI_pos(:,1),ROI_pos(:,2),Info.SizeMR(1),Info.SizeMR(2));
                ROI{val}.RoiSegmentationPixelIdxList{it} = find(bw_fwd);
            end
        end
    end  
end

% Save ROI and Info in the folder T1_MAT
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');    
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');
end

