%% Delete_maskADC
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function deletes the ADC mask currently showing on the GUI ADC.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC(), button 'Delete current mask'
%%%% call: Show_ROI_ADC() 

global ROI
global gui_ADC

ROI{gui_ADC.val}.RoiSegmentationPixelIdxListADC{gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)} = []; 
ROI{gui_ADC.val}.FinalMasksADC{gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)} = zeros(size(ROI{gui_ADC.val}.MasksADC,1)); 
ROI{gui_ADC.val}.MasksADC(:,:,gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)) = zeros(size(ROI{gui_ADC.val}.MasksADC,1)); 
ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)} = 0;  
ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)).row = [];  
ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k)).column = [];  

% Show the current slice with the modified mask
Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show);

