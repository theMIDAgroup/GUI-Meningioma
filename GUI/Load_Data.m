%% Load_Data()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% Once the subject has been selected, this function:
% - initializes the ROIs with Initialize_ROI_brain()
% - creates the paths for MAT and DICOM output
% - preprocesses the data with Preprocessing_Files()
% - saves the file Info.mat 
% - load the file ROI.mat (if existing)
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain()
%%%% call:  Save_All()
%%%%        Gui_Initialization()
%%%%        Initialize_ROI_brain()
%%%%        Preprocessing_Files()
%%%%        Select_MR_Series()

function Load_Data()
global gui_ROI;
global ROI;
global Info;

%% Check if ROIs have already been created
if iscell(ROI)
    temp_empty = 0;
    for itROI = 1 : length(ROI)
        temp_empty = temp_empty+ROI{itROI}.RoiEmpty;
    end
    
    if temp_empty      
        choice = questdlg('Do you want to SAVE ALL the existing ROI?', ...
            '!!Warning!!','Yes','No','Yes');
        switch choice
            case 'Yes'
                Save_All;
            case 'No'
        end
    end
    clear temp_empty;
end

set(gui_ROI.PANELload.TXTload,'string','');

% Set the inital parameters for the gui, enabling buttons and panels.
Gui_Initialization;

%% Selection of the subject
if isfield(gui_ROI,'InputPath')
    InputPath = uigetdir(gui_ROI.InputPath, 'Choose patient path');
else
    start_path = pwd;
    InputPath = uigetdir(start_path, 'Choose patient path');
end

if InputPath ==  0
else
    gui_ROI.InputPath = InputPath;
    gui_ROI.PANELroi.ROIName;
    for it = 1 : length(gui_ROI.PANELroi.ROIName)-1 
        Initialize_ROI_brain(it);
    end
    
    Info_mat_file = [InputPath '_MAT' gui_ROI.slash_pc_mac, 'Info.mat'];
    
    if ~exist([InputPath '_MAT'],'dir'), mkdir([InputPath '_MAT']); end
    
    Info.InputPath = InputPath;
    Info.InputPathMAT = [InputPath '_MAT'];
    Info.OutputPathDICOM = [InputPath '_OUTPUT_DICOM'];
    Info.OutputPathMASK = [InputPath '_OUTPUT_MASK'];
    Info.OutputPathRadiomics= [InputPath '_RADIOMICS_OUTPUT']; 

    set(gui_ROI.PANELload.TXTload,'string',strtrim(InputPath));
    if exist(Info_mat_file,'file')
        load(Info_mat_file);
        
        Info.InputPath = InputPath;
        Info.InputPathMAT = [InputPath '_MAT'];
        Info.OutputPathDICOM = [InputPath '_OUTPUT_DICOM'];
        Info.OutputPathMASK = [InputPath '_OUTPUT_MASK'];
        Info.OutputPathRadiomics = [InputPath '_RADIOMICS_OUTPUT']; 
    else
        
        % With Preprocessing_Files, Dicom files are read and information
        % about the acquisition, the slice location, patients data are 
        % stored in "Info.mat" (if it does not exist yet).
        Preprocessing_Files;   
        
    end

    %% Save and show the MR images

    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'Info.mat'],'Info','-mat');
    
    % Select_MR_Series enables some commands in the GUI, load the existing 
    % ROI.mat file and shows the first dicom image with the function 
    % Show_Image().
    Select_MR_Series;
end

end
