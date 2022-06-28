%% Put_Roi()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function plots a ROI and removes existing ROIs using ResetRoi().
% -------------------------------------------------------------------------
%%%% called by: Roi_Rectangle()  
%%%%            Roi_Ellipse()
%%%%            Roi_Poly()
%%%% call: Show_Image()
%%%%       Draw_Roi()
%%%%       Reset_Roi()


function Put_Roi(RoiKind,RoiPosition)
global gui_ROI;
global ROI;

val = gui_ROI.PopupValue;
% RoiRemoveKind = 'imellipse';
% RoiRemovePosition = [246,246,20,20];

if ROI{val}.RoiEmpty
    aux_position = 1;
    set(gui_ROI.PANELroi.PANEL3.PB2,'enable','on');
    ROI{val}.RoiEmpty = false;
    ROI{val}.StartMR = gui_ROI.SliceNumber;
    ROI{val}.CenterMR = [];
    ROI{val}.RoiKind{1} = RoiKind;
    ROI{val}.RoiPosition{1} = RoiPosition;
    ROI{val}.RoiSlice(1) = gui_ROI.SliceNumber;
    
    set(gui_ROI.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartMR));    
   
    Draw_Roi(RoiKind,RoiPosition,aux_position,'green');
    disp('here1')
    
else
    if ~ROI{val}.RoiEnd
        Show_Image;
        [~,aux_position] = ismember(gui_ROI.SliceNumber,ROI{val}.RoiSlice);
        Draw_Roi(RoiKind,RoiPosition,aux_position,'green');
        disp('here2')
    else
        choice = questdlg('A ROI already exists. Do you want to clear the existing ROI?', ...
            '!!Warning!!', 'Yes','No','No');
        switch choice
            case 'Yes'
                Reset_Roi;
                aux_position = 1;
                set(gui_ROI.PANELroi.PANEL3.PB2,'enable','on');
                ROI{val}.RoiEmpty = false;
                ROI{val}.StartMR = gui_ROI.SliceNumber;
                ROI{val}.CenterMR = [];
                ROI{val}.RoiKind{1} = RoiKind;
                ROI{val}.RoiPosition{1} = RoiPosition;
                ROI{val}.RoiSlice(1) = gui_ROI.SliceNumber;
                
                set(gui_ROI.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartMR));

                Draw_Roi(RoiKind,RoiPosition,aux_position,'green');
       
            case 'No'
                return;
        end
    end
    
end
end
