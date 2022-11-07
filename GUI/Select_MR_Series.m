%% Select_MR_Series()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function manages the data series loaded with Load_Data():
% first, it deals with MR images, enabling some commands in the gui and
% showing the first dicom image with the function Show_Image(). 
% This function shows also existing ROIs, if any.
% -------------------------------------------------------------------------
%%%% called by: Load_Data()
%%%% call: Show_Image()

function Select_MR_Series()

global gui_ROI;
global Info;
global ROI;

% enable some panels in the GUI
set(gui_ROI.PANELroi.popup,'enable','on');
set(gui_ROI.PANELquantAlgo.popup,'enable','on');   
set(gui_ROI.PANELroi.PANEL5.PB2,'enable','on');
set(gui_ROI.PANELroi.PANEL5.PB3,'enable','on');
set(gui_ROI.PBstart,'enable','on');
set(gui_ROI.PANELax.SLIDERimage,'SliderStep',[1/(Info.NumberFileMR-1) 10/(Info.NumberFileMR-1)]);
set(gui_ROI.PANELax.panel,'visible','on');
set(gui_ROI.PANELgui_check.gui_check_T1,'enable','on'); 
set(gui_ROI.PANELgui_check.gui_check_ADC,'enable','on'); 

% load the existing ROI
idcs   = strfind(Info.InputPath,gui_ROI.slash_pc_mac);
newInputPath = Info.InputPath(1:idcs(end)-1);
ROI_mat_file = [newInputPath gui_ROI.slash_pc_mac 'MAT_FILES' gui_ROI.slash_pc_mac, 'ROI.mat'];  
if exist(ROI_mat_file,'file')
    load(ROI_mat_file);

    gui_ROI.PANELroi.ROIName = [];
    gui_ROI.PANELroi.ROIId = [];
    NitROI = length(ROI);
    gui_ROI.PANELroi.ROIName{1} = '-----------------';
    gui_ROI.PANELroi.ROIId(1) = 0;
    for itROI = 1:NitROI
        gui_ROI.PANELroi.ROIName{itROI+1} = ROI{itROI}.Name;
        gui_ROI.PANELroi.ROIId(itROI+1) = ROI{itROI}.Id;
    end
    set(gui_ROI.PANELroi.popup,'string',gui_ROI.PANELroi.ROIName);
end


Show_Image;

end



