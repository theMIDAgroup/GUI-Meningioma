%% Save_Last_Slice()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function:
% - saves the changes of the current mask
% - saves volume mask in dicom and mat format (for each ROI)
% - saves global variables ROI and Info
% - calls the radiomics (for T1) via radiomics_T1_and_Continue().
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_T1()
%%%% call:  radiomics_T1_and_Continue()
%%%%        Write_Dicom_brain()
%%%%        Write_3D_Masks_general()
    
function Save_Last_Slice()
global ROI;
global Info;
global gui_T1;
global gui_ROI;

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Analysis T1 in progress'];
w = waitbar(0,'Analysis in progress','Name','Analysis T1');
waitbar(0, w,str_wbar);

% Save the ROIs modified in Show_ROI
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

waitbar(.33,w,str_wbar);
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

Write_Dicom_brain;

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' Preparing volume mask T1'];
waitbar(0.67,w,str_wbar);

Write_3D_Masks_general(Info.NumRow, Info.NumCol, Info.NumberFileMR,'RoiSegmentationPixelIdxList',...
    'FinalMasks','volume_mask.mat','StartMR','EndMR');

% Save ROI and Info in the folder T1_MAT
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   
save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');

waitbar(1, w,str_wbar);
close(w);
disp('Analysis Completed!')
 
% From here: start with ADC co-registration or compute radiomics for T1, in
% case ADC is not present
radiomics_T1_and_Continue;

end