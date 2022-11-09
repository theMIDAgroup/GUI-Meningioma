%% Save_All()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function saves all the existing ROIs in file ROI.mat
% -------------------------------------------------------------------------
%%%% called by: Load_Data()
%%%%            main_gui_brain(), button 'SAVE ALL'
%%%%            Start_Analysis_brain()
%%%% call: Roi_PixelIdxList_brain()

function Save_All()
global ROI;
global Info;
global gui_ROI;

h_msg = msgbox('Saving ROI...');

Roi_PixelIdxList_brain;

save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');   

close(h_msg);
end

