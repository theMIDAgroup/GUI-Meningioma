%% Roi_End()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function ends the current ROI and saves it.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain(), button 'END'
%%%% call: Enable_Roi() 
%%%%       Enable_Txt()

function Roi_End()
global Info;
global gui_ROI;
global ROI;

val = gui_ROI.PopupValue;

if gui_ROI.SliceNumber<ROI{val}.StartMR
    errordlg('ROI ends before its beginning!','!! Warning !!')
else
    ROI{val}.RoiEnd = true;
    
    ROI{val}.EndMR = gui_ROI.SliceNumber;
    
    set(gui_ROI.PANELroi.PANEL3.PB2,'enable','off');
    set(gui_ROI.PANELroi.PANEL3.TXT2b,'string',num2str(ROI{val}.EndMR));
    
    [~,aux_position] = ismember(gui_ROI.SliceNumber,ROI{val}.RoiSlice);
    max_position = length(ROI{val}.RoiSlice);
    ROI{val}.RoiSlice(aux_position+1 : max_position) = [];
    ROI{val}.RoiKind(aux_position+1 : max_position) = [];
    ROI{val}.RoiPosition(aux_position+1 : max_position) = [];
    ROI{val}.RoiRegion(aux_position+1 : max_position,:) = [];

    set(gui_ROI.PANELroi.PANEL4.CKBOX1,'value',1); Enable_Roi();
    
    % In order to be able to merge the ROIs without first clicking on 
    % "Start Analysis"
    save([Info.InputPathMAT gui_ROI.slash_pc_mac 'ROI.mat'],'ROI','-mat');    

end
end
