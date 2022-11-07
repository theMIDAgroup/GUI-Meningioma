%% main_gui_brain()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function calls the gui for the software where one can load the
% data, create the ROIs, set the desired outputs and run the
% segmentation analysis.
% -------------------------------------------------------------------------
%%%% call:  Load_Data
%%%%        Slider_Contrast
%%%%        Slider_WindowsUp
%%%%        Slider_WindowsDown
%%%%        Slider_Image_brain
%%%%        PopUp_Districts
%%%%        Roi_Rectangle
%%%%        Roi_Ellipse
%%%%        Roi_Poly
%%%%        Roi_End
%%%%        Enable_Roi
%%%%        Enable_Dicom
%%%%        Reset_Roi
%%%%        Reset_All
%%%%        Save_All
%%%%        DeleteSlices
%%%%        AppendROIs
%%%%        Merge_sameROI
%%%%        CheckT1
%%%%        CheckADC
%%%%        radiomics_T1_and_Continue
%%%%        Start_Analysis_brain

function main_gui_brain(action,varargin)

if nargin<1
    
    action='gui';
    
end
feval(action,varargin{:});
end
%% ************************************************************************
%% ************************************************************************
function gui()
clear global;

global gui_ROI;
global pos;

if ispc==1, gui_ROI.slash_pc_mac='\'; else, gui_ROI.slash_pc_mac='/'; end

screen_x=0.97;
screen_y=0.83;
scrsz = get(0,'ScreenSize');

%%%% gui position
position(1,3)=round(scrsz(1,3)*screen_x); %-x
position(1,4)=round(scrsz(1,4)*screen_y); %-y
position(1,1)=round((scrsz(1,3)*.99-position(1,3)));
position(1,2)=round((scrsz(1,4)-position(1,4))/2);

%%%% scale factor for gui
vect_pixel=[1920 1058 1920 1058];
vect_pixel_screen=[scrsz(1,3),scrsz(1,4),scrsz(1,3),scrsz(1,4)];
pos.scale_factor=(vect_pixel_screen./vect_pixel).*[screen_x/.6 screen_y/.7 screen_x/.6 screen_y/.7];

pos.FIGURE=position;

%%%% PANEL LOAD - position
pos.PANELload.panel=round([15,680,800,60].*pos.scale_factor);
pos.PANELload.PBload=round([15,5,120,25].*pos.scale_factor);
pos.PANELload.TXTload=round([150,5,650,30].*pos.scale_factor);

%%%% PANEL MRI FIGURE - position
pos.PANELax.panel=round([15,15,560,660].*pos.scale_factor);

%%%% PANEL DELETE SLICES - position
pos.PANELdelete_slices.panel=round([820,580,330,160].*pos.scale_factor);

%%%% PANEL APPEND ROI - position
pos.PANELappend_ROI.panel=round([820,410,330,160].*pos.scale_factor);

%%%% PANEL MERGE ROI COMPONENTS - position
pos.PANELsame_roi.panel=round([820,240,330,160].*pos.scale_factor);

%%%% PANEL GUI Check - position
pos.PANELgui_check.panel=round([820,110,330,120].*pos.scale_factor);  

%%%% PANEL radiomics quantization - position  
pos.PANELquantAlgo.panel=round([820,15,330,85].*pos.scale_factor); 

pos.PANELax.ax=round([-70,5,575,575].*pos.scale_factor);
pos.PANELax.SLIDERimage=round([60,580,330,25].*pos.scale_factor);
pos.PANELax.SLIDERcontrast=round([420,5,25,575].*pos.scale_factor);
pos.PANELax.SLIDERwindowUp_edit=round([450,500,80,25].*pos.scale_factor);
pos.PANELax.SLIDERwindowDown_edit=round([450,100,80,25].*pos.scale_factor);
pos.PANELax.SLIDERwindowUp_push=round([450,450,80,25].*pos.scale_factor);
pos.PANELax.SLIDERwindowDown_push=round([450,50,80,25].*pos.scale_factor);
pos.PANELax.ZoomIn=round([450,310,25,25].*pos.scale_factor);
pos.PANELax.ZoomOut=round([450,270,25,25].*pos.scale_factor);
pos.PANELax.TXT=round([-60,605,575,27].*pos.scale_factor);
pos.PANELax.colorbar=round([10,5,25,575].*pos.scale_factor);  

pos.PANELdelete_slices.which_tumour=round([150,85,60,28].*pos.scale_factor);
pos.PANELdelete_slices.new_Start=round([150,50,60,28].*pos.scale_factor);
pos.PANELdelete_slices.new_End=round([150,15,60,28].*pos.scale_factor);
pos.PANELdelete_slices.delete_push=round([230,50,90,28].*pos.scale_factor);
pos.PANELdelete_slices.TXTwhich_tumour=round([5,85,130,28].*pos.scale_factor);
pos.PANELdelete_slices.TXTnew_Start=round([5,50,130,28].*pos.scale_factor);
pos.PANELdelete_slices.TXTnew_End=round([5,15,130,28].*pos.scale_factor);
pos.PANELdelete_slices.PBload = round([230,15,90,28].*pos.scale_factor);

pos.PANELappend_ROI.val_1=round([150,90,60,28].*pos.scale_factor);
pos.PANELappend_ROI.val_2=round([150,50,60,28].*pos.scale_factor);
pos.PANELappend_ROI.append_ROI=round([230,70,90,28].*pos.scale_factor);
pos.PANELappend_ROI.TXTval_1=round([5,90,130,28].*pos.scale_factor);
pos.PANELappend_ROI.TXTval_2=round([5,50,130,28].*pos.scale_factor);

pos.PANELsame_roi.val_part1=round([150,90,60,28].*pos.scale_factor);
pos.PANELsame_roi.val_part2=round([150,50,60,28].*pos.scale_factor);
pos.PANELsame_roi.val_part3=round([150,10,60,28].*pos.scale_factor);  

pos.PANELsame_roi.merge_components=round([230,70,90,25].*pos.scale_factor);
pos.PANELsame_roi.merge_3components=round([230,30,90,25].*pos.scale_factor); 
pos.PANELsame_roi.TXTval_part1=round([5,90,130,28].*pos.scale_factor);
pos.PANELsame_roi.TXTval_part2=round([5,50,130,28].*pos.scale_factor);
pos.PANELsame_roi.TXTval_part3=round([5,10,130,28].*pos.scale_factor);  

pos.PANELsame_roi.radiomics_T1_and_Continue = round([70,10,190,25].*pos.scale_factor);

pos.PANELgui_check.gui_check_T1=round([5,45,290,32].*pos.scale_factor);   
pos.PANELgui_check.gui_check_ADC=round([5,5,290,32].*pos.scale_factor);  
 
pos.PANELquantAlgo.quantAlgo = round([5,10,290,32].*pos.scale_factor);   
pos.PANELquantAlgo.popup=round([5,10,290,32].*pos.scale_factor); 

pos.PANELroi.panel=round([580,60,235,600].*pos.scale_factor);
pos.PANELroi.popup=round([5,550,225,25].*pos.scale_factor);

pos.PANELroi.PANEL1.panel=round([5,475,225,70].*pos.scale_factor);
pos.PANELroi.PANEL1.PB1=round([55,10,40,40].*pos.scale_factor);
pos.PANELroi.PANEL1.PB2=round([130,10,40,40].*pos.scale_factor);

pos.PANELroi.PANEL2.panel=round([5,440,225,80].*pos.scale_factor);
pos.PANELroi.PANEL2.PB1=round([5,10,40,40].*pos.scale_factor);
pos.PANELroi.PANEL2.PB2=round([60,10,40,40].*pos.scale_factor);
pos.PANELroi.PANEL2.PB3=round([115,10,40,40].*pos.scale_factor);

pos.PANELroi.PANEL3.panel=round([5,310,225,105].*pos.scale_factor);
pos.PANELroi.PANEL3.TXT1a=round([10,65,120,25].*pos.scale_factor);
pos.PANELroi.PANEL3.PB2=round([10,35,120,25].*pos.scale_factor);
pos.PANELroi.PANEL3.TXT1b=round([130,65,90,25].*pos.scale_factor);
pos.PANELroi.PANEL3.TXT2b=round([130,35,90,25].*pos.scale_factor);
pos.PANELroi.PANEL3.TXT3b=round([130,5,90,25].*pos.scale_factor);

pos.PANELroi.PANEL4.panel=round([5,160,225,125].*pos.scale_factor);
pos.PANELroi.PANEL4.CKBOX1=round([10,65,205,25].*pos.scale_factor);

pos.PANELroi.PANEL5.panel=round([5,10,225,125].*pos.scale_factor);
pos.PANELroi.PANEL5.PB1=round([10,65,120,25].*pos.scale_factor);
pos.PANELroi.PANEL5.PB2=round([10,35,120,25].*pos.scale_factor);
pos.PANELroi.PANEL5.PB3=round([10,5,120,25].*pos.scale_factor);

%%%% PANEL start - position
pos.PBstart=round([580,15,235,40].*pos.scale_factor);

%%%% GUI colors
gui_ROI.first_opening=0;
gui_ROI.scale4contrast=0.5;
gui_ROI.bgc = [0.6 0.6 0.6] ; 
gui_ROI.bgc_light = [0.4 0.4 0.4];  
gui_ROI.fgc = [1,1,1];
gui_ROI.fs = 16;
gui_ROI.bgc_drop = [0.7 0.7 0.7]; % panel background
gui_ROI.fgc_drop = [0.4 0.4 0.4];
gui_ROI.bgc_ppm = [0.8 0.8 0.8];
gui_ROI.fgc_ppm = [0.4 0.4 0.4];

%% FIGURE
gui_ROI.fig=figure('HandleVisibility','Callback','Menubar','none',...
    'Name','GUI MRI', 'NumberTitle','off', ...
    'Visible','on', 'BackingStore','off',...
    'position',pos.FIGURE,...
    'Color',gui_ROI.bgc);

%% PANEL LOAD
gui_ROI.PANELload.panel=uipanel('parent',gui_ROI.fig,'Title','Input files','units','pixel',...
    'Position',pos.PANELload.panel,'FontWeight','bold','FontSize',gui_ROI.fs,...
    'BackGroundColor',gui_ROI.bgc_drop,'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELload.PBload = uicontrol(gui_ROI.PANELload.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'LOAD',...
    'position',pos.PANELload.PBload,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,... 
    'FontSize',gui_ROI.fs,...
    'callback', 'Load_Data');

gui_ROI.PANELload.TXTload  = uicontrol(gui_ROI.PANELload.panel,'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.PANELload.TXTload);

%% EDIT PANELS

gui_ROI.PANELdelete_slices.panel=uipanel('parent',gui_ROI.fig,'Title','Delete slices from ROI','units','pixel',...
    'Position',pos.PANELdelete_slices.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELappend_ROI.panel=uipanel('parent',gui_ROI.fig,'Title','Append ROI','units','pixel',...
    'Position',pos.PANELappend_ROI.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELsame_roi.panel=uipanel('parent',gui_ROI.fig,'Title','Merge components of the same ROI','units','pixel',...
    'Position',pos.PANELsame_roi.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELquantAlgo.panel = uipanel('parent',gui_ROI.fig,'Title','Quantization algorithm','units','pixel',...
    'Position',pos.PANELquantAlgo.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc);  

%% GUI CHECK PANELS

gui_ROI.PANELgui_check.panel=uipanel('parent',gui_ROI.fig,'Title','Other GUIs','units','pixel',...
    'Position',pos.PANELgui_check.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc); 

% DELETE SLICES
gui_ROI.PANELdelete_slices.TXTwhich_tumour= uicontrol(gui_ROI.PANELdelete_slices.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELdelete_slices.TXTwhich_tumour,...
    'enable','on');

gui_ROI.PANELdelete_slices.TXTnew_Start = uicontrol(gui_ROI.PANELdelete_slices.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'NEW START',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELdelete_slices.TXTnew_Start,...
    'enable','on');

gui_ROI.PANELdelete_slices.TXTnew_End = uicontrol(gui_ROI.PANELdelete_slices.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'NEW END',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELdelete_slices.TXTnew_End,...
    'enable','on');

gui_ROI.PANELdelete_slices.which_tumour=uicontrol(gui_ROI.PANELdelete_slices.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELdelete_slices.which_tumour,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELdelete_slices.new_Start=uicontrol(gui_ROI.PANELdelete_slices.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELdelete_slices.new_Start,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELdelete_slices.new_End=uicontrol(gui_ROI.PANELdelete_slices.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELdelete_slices.new_End,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELdelete_slices.delete_push=uicontrol(gui_ROI.PANELdelete_slices.panel,'Style','pushbutton',...
    'String','DELETE',...
    'units','pixel',...
    'position',pos.PANELdelete_slices.delete_push,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'DeleteSlices;');

% APPEND ROIs
gui_ROI.PANELappend_ROI.TXTval_1 = uicontrol(gui_ROI.PANELappend_ROI.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI head',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELappend_ROI.TXTval_1,...
    'enable','on');

gui_ROI.PANELappend_ROI.TXTval_2= uicontrol(gui_ROI.PANELappend_ROI.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI tail',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELappend_ROI.TXTval_2,...
    'enable','on');

gui_ROI.PANELappend_ROI.val_1=uicontrol(gui_ROI.PANELappend_ROI.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELappend_ROI.val_1,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELappend_ROI.val_2=uicontrol(gui_ROI.PANELappend_ROI.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELappend_ROI.val_2,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELappend_ROI.append_ROI =uicontrol(gui_ROI.PANELappend_ROI.panel,'Style','pushbutton',...
    'String','APPEND',...
    'units','pixel',...
    'position',pos.PANELappend_ROI.append_ROI,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'AppendROIs;');

% SAME ROI
gui_ROI.PANELsame_roi.TXTval_part1 = uicontrol(gui_ROI.PANELsame_roi.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI part 1',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELsame_roi.TXTval_part1,...
    'enable','on');

gui_ROI.PANELsame_roi.TXTval_part2= uicontrol(gui_ROI.PANELsame_roi.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI part 2',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELsame_roi.TXTval_part2,...
    'enable','on');

gui_ROI.PANELsame_roi.TXTval_part3= uicontrol(gui_ROI.PANELsame_roi.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI part 3',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELsame_roi.TXTval_part3,...
    'enable','on');  

gui_ROI.PANELsame_roi.val_part1=uicontrol(gui_ROI.PANELsame_roi.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELsame_roi.val_part1,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELsame_roi.val_part2=uicontrol(gui_ROI.PANELsame_roi.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELsame_roi.val_part2,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ROI.PANELsame_roi.val_part3=uicontrol(gui_ROI.PANELsame_roi.panel,'Style','edit',...
    'string','',...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELsame_roi.val_part3,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on'); 

gui_ROI.PANELsame_roi.merge_components =uicontrol(gui_ROI.PANELsame_roi.panel,'Style','pushbutton',...
    'String','MERGE',...
    'units','pixel',...
    'position',pos.PANELsame_roi.merge_components,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Merge_sameROI;');

gui_ROI.PANELsame_roi.merge_3components =uicontrol(gui_ROI.PANELsame_roi.panel,'Style','pushbutton',...
    'String','MERGE 3',...
    'units','pixel',...
    'position',pos.PANELsame_roi.merge_3components,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Merge_sameROI3;'); 

% GUI Check
gui_ROI.PANELgui_check.gui_check_T1 = uicontrol(gui_ROI.PANELgui_check.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'Check T1 segmentation',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELgui_check.gui_check_T1, ...
    'enable','off',...
    'callback', 'CheckT1;'); 

gui_ROI.PANELgui_check.gui_check_ADC= uicontrol(gui_ROI.PANELgui_check.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'Check ADC segmentation',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELgui_check.gui_check_ADC, ...
    'enable','off',...
    'callback', 'CheckADC;'); 

gui_ROI.PANELquantAlgo.AlgoName={...   
    'Equal  ',...
    'Uniform  ',...
    'Lloyd  ',...
    'noQuant ',...
  };

gui_ROI.PANELquantAlgo.popup=uicontrol(gui_ROI.PANELquantAlgo.panel,'style', 'popup',...  
    'string',gui_ROI.PANELquantAlgo.AlgoName,...
    'units','pixel',...
    'callback','PopUp_Quant',....
    'enable','off',...
    'BackGroundColor',gui_ROI.bgc_ppm,...
    'ForeGroundColor',gui_ROI.fgc_ppm, ...
    'FontSize',gui_ROI.fs,...
    'FontWeight','bold',...
    'position',pos.PANELquantAlgo.popup);

%% PANEL MR FIGURE
gui_ROI.PANELax.panel=uipanel('parent',gui_ROI.fig,'Title','MR image','units','pixel',...
    'Position',pos.PANELax.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'visible','off',...
    'BackGroundColor',gui_ROI.bgc_drop, 'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELax.SLIDERcontrast=uicontrol(gui_ROI.PANELax.panel,'Style','slider','Min',0,'Max',1,...
    'Value',gui_ROI.scale4contrast,'SliderStep',[0.01 0.05],...
    'units','pixel',...
    'position',pos.PANELax.SLIDERcontrast,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'Callback','Slider_Contrast');

gui_ROI.PANELax.SLIDERwindowUp_edit=uicontrol(gui_ROI.PANELax.panel,'Style','edit',...
    'string',0,...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELax.SLIDERwindowUp_edit,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');
gui_ROI.PANELax.SLIDERwindowDown_edit=uicontrol(gui_ROI.PANELax.panel,'Style','edit',...
    'string',0,...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.PANELax.SLIDERwindowDown_edit,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');
gui_ROI.PANELax.SLIDERwindowUp_push=uicontrol(gui_ROI.PANELax.panel,'Style','pushbutton',...
    'String','APPLY',...
    'units','pixel',...
    'position',pos.PANELax.SLIDERwindowUp_push,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Slider_WindowUp;');
gui_ROI.PANELax.SLIDERwindowDown_push=uicontrol(gui_ROI.PANELax.panel,'Style','pushbutton',...
    'String','APPLY',...
    'units','pixel',...
    'position',pos.PANELax.SLIDERwindowDown_push,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Slider_WindowDown;');

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'zoom_in.gif']);
[X, map] = imresize(X,map,1);
icon = ind2rgb(X,map);
gui_ROI.PANELax.ZoomIn=uicontrol(gui_ROI.PANELax.panel,...
    'units','pixel',...
    'CData', icon,...
    'position',pos.PANELax.ZoomIn,...
    'enable','on',...
    'Callback', 'zoom on',...
    'CData',icon,...
    'TooltipString','Zoom',...
    'Tag','zoom');

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'zoom_out.gif']);
[X, map] = imresize(X,map,1);
icon = ind2rgb(X,map);

gui_ROI.PANELax.ZoomOut=uicontrol(gui_ROI.PANELax.panel,...
    'units','pixel',...
    'CData', icon,...
    'position',pos.PANELax.ZoomOut,...
    'enable','on',...
    'Callback', 'zoom off',...
    'CData',icon,...
    'TooltipString','Zoom',...
    'Tag','zoom');

gui_ROI.PANELax.SLIDERimage=uicontrol(gui_ROI.PANELax.panel,'Style','slider','Min',0,'Max',1,...
    'Value',0,...
    'units','pixel',...
    'position',pos.PANELax.SLIDERimage,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'Callback','Slider_Image_brain');

gui_ROI.PANELax.TXT= uicontrol(gui_ROI.PANELax.panel,'style', 'text',...
    'units', 'pixel',...
    'string','',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.PANELax.TXT);
gui_ROI.PANELax.ax=axes('parent',gui_ROI.PANELax.panel,...
    'units','pixel',...
    'Position',pos.PANELax.ax,...
    'xlim',[0.5 300.5],'ylim',[0.5 300.5]);

%% PANEL ROI

%%%%%%%%%%%%%%%%%%%  PANEL 1 SELECTION OF THE ROI  %%%%%%%%%%%%%%%%%%%%%%%%
gui_ROI.PANELroi.ROIName={...   
    '-----------------',...
    'District 1  ',...
    'District 2  ',...
    'District 3  ',...
    'District 4  ',...
    'District 5  ',...
  };

gui_ROI.PANELroi.ROIId=[0,1,2,3,4,5];

gui_ROI.PANELroi.panel=uipanel('parent',gui_ROI.fig,'Title','ROI','units','pixel',...
    'Position',pos.PANELroi.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'BackGroundColor',gui_ROI.bgc_drop,'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELroi.popup=uicontrol(gui_ROI.PANELroi.panel,'style', 'popup',...
    'string',gui_ROI.PANELroi.ROIName,...
    'units','pixel',...
    'callback','PopUp_Districts',...
    'enable','off',...
    'BackGroundColor',gui_ROI.bgc_ppm,...
    'ForeGroundColor',gui_ROI.fgc_ppm, ...
    'FontSize',gui_ROI.fs,...
    'FontWeight','bold',...
    'position',pos.PANELroi.popup);

%%%%%%%%%%%%%%%%%%%   PANEL 2 choice of the ROI kind   %%%%%%%%%%%%%%%%%%%%
gui_ROI.PANELroi.PANEL2.panel=uipanel('parent',gui_ROI.PANELroi.panel,...
    'Title','ROI kind',...
    'units','pixel',...
    'Position',pos.PANELroi.PANEL2.panel,'FontWeight','bold','FontSize',...
    gui_ROI.fs,'BackGroundColor',gui_ROI.bgc,'ForeGroundColor',gui_ROI.fgc);

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'rectangle.ico']);
[X, map] = imresize(X,map,0.5);
icon = ind2rgb(X,map);

gui_ROI.PANELroi.PANEL2.PB1 = uicontrol(gui_ROI.PANELroi.PANEL2.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'CData', icon,...
    'position',pos.PANELroi.PANEL2.PB1,...
    'enable','off',...
    'callback', 'Roi_Rectangle;');

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'ellipse.ico']);
[X, map] = imresize(X,map,0.5);
icon = ind2rgb(X,map);
gui_ROI.PANELroi.PANEL2.PB2 = uicontrol(gui_ROI.PANELroi.PANEL2.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'CData', icon,...
    'position',pos.PANELroi.PANEL2.PB2,...
    'enable','off',...
    'callback', 'Roi_Ellipse;');

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'poly.ico']);
[X, map] = imresize(X,map,0.5);
icon = ind2rgb(X,map);

gui_ROI.PANELroi.PANEL2.PB3 = uicontrol(gui_ROI.PANELroi.PANEL2.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'CData', icon,...
    'position',pos.PANELroi.PANEL2.PB3,...
    'enable','off',...
    'callback', 'Roi_Poly;');

[X, map] = imread(['icon' gui_ROI.slash_pc_mac 'sphere.ico']);
[X, map] = imresize(X,map,0.5);
icon = ind2rgb(X,map);

%%%%%%%%%%%%%%%%%%%%%  PANEL 3  end of the ROI     %%%%%%%%%%%%%%%%%%%%%%%%
gui_ROI.PANELroi.PANEL3.panel=uipanel('parent',gui_ROI.PANELroi.panel,...
    'Title','',...
    'units','pixel',...
    'Position',pos.PANELroi.PANEL3.panel,'FontWeight','bold','BackGroundColor',gui_ROI.bgc,'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELroi.PANEL3.TXT1a = uicontrol(gui_ROI.PANELroi.PANEL3.panel,'style', 'text',...
    'units', 'pixel',...
    'string', 'START',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELroi.PANEL3.TXT1a,...
    'enable','off');%,...
%'callback', ' ;');

gui_ROI.PANELroi.PANEL3.PB2 = uicontrol(gui_ROI.PANELroi.PANEL3.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'END',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position',pos.PANELroi.PANEL3.PB2,...
    'enable','off',...
    'callback', 'Roi_End;');

gui_ROI.PANELroi.PANEL3.TXT1b= uicontrol(gui_ROI.PANELroi.PANEL3.panel,'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.PANELroi.PANEL3.TXT1b);

gui_ROI.PANELroi.PANEL3.TXT2b= uicontrol(gui_ROI.PANELroi.PANEL3.panel,'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.PANELroi.PANEL3.TXT2b);

gui_ROI.PANELroi.PANEL3.TXT3b= uicontrol(gui_ROI.PANELroi.PANEL3.panel,'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.PANELroi.PANEL3.TXT3b);

%%%%%%%%%%%%%%%%%%%  PANEL 4   choice of the output    %%%%%%%%%%%%%%%%%%%%
gui_ROI.PANELroi.PANEL4.panel=uipanel('parent',gui_ROI.PANELroi.panel,...
    'Title','Output',...
    'units','pixel',...
    'Position',pos.PANELroi.PANEL4.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'BackGroundColor',gui_ROI.bgc,'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELroi.PANEL4.CKBOX1 = uicontrol(gui_ROI.PANELroi.PANEL4.panel,'style', 'checkbox',...
    'units', 'pixel',...
    'string', 'ENABLE ROI',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback','Enable_Roi',...
    'position',pos.PANELroi.PANEL4.CKBOX1);

%%%%%%%%%%%%%%%%%%%%   PANEL 5  ROI save options  %%%%%%%%%%%%%%%%%%%%%%%%%
gui_ROI.PANELroi.PANEL5.panel=uipanel('parent',gui_ROI.PANELroi.panel,...
    'Title','Save',...
    'units','pixel',...
    'Position',pos.PANELroi.PANEL5.panel,'FontWeight','bold','FontSize',gui_ROI.fs,'BackGroundColor',gui_ROI.bgc,'ForeGroundColor',gui_ROI.fgc);

gui_ROI.PANELroi.PANEL5.PB1 = uicontrol(gui_ROI.PANELroi.PANEL5.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'RESET ROI',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.PANELroi.PANEL5.PB1,...
    'callback', 'Reset_Roi;');

gui_ROI.PANELroi.PANEL5.PB2 = uicontrol(gui_ROI.PANELroi.PANEL5.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'RESET ALL',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.PANELroi.PANEL5.PB2,...
    'callback', 'Reset_All;');

gui_ROI.PANELroi.PANEL5.PB3 = uicontrol(gui_ROI.PANELroi.PANEL5.panel,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'SAVE ALL',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.PANELroi.PANEL5.PB3,...
    'callback', 'Save_All;');

% START SEGMENTATION
gui_ROI.PBstart = uicontrol('parent',gui_ROI.fig,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'START SEGMENTATION',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.PBstart,...
    'callback', 'Start_Analysis_brain');

gui_ROI.PopupValue=0;
gui_ROI.PopupValueQuant = 'Equal'; % set default quantization algorithm to 'Equal'

gui_ROI.MENU.View.Menu=uimenu(gui_ROI.fig,'label','&View');

gui_ROI.MENU.View.SliceSelect=uimenu(gui_ROI.MENU.View.Menu,'Label','&Select slice',...
    'Accelerator','W','Callback','main_gui(''MenuCallback_SliceSelect'')',...
    'enable','off');

gui_ROI.MENU.View.SlicePlus=uimenu(gui_ROI.MENU.View.Menu,'Label','&Zoom +',...
    'Accelerator','D','Callback','main_gui(''MenuCallback_ZoomIn'')',...
    'enable','off');

gui_ROI.MENU.View.SliceMinus=uimenu(gui_ROI.MENU.View.Menu,'Label','&Zoom -',...
    'Accelerator','A','Callback','main_gui(''MenuCallback_ZoomOut'')',...
    'enable','off');

gui_ROI.MENU.View.HURange=uimenu(gui_ROI.MENU.View.Menu,'Label','&HU range',...
    'Callback','main_gui(''MenuCallback_HURange'')',...
    'enable','off');
end

function MenuCallback_SliceSelect()
global gui_ROI;
global Info;

answer=inputdlg('Set Slice Number:','Slice Number',1);

if ~isempty(answer)
    SliceNumber=str2num(answer{1});    
    if ~isempty(SliceNumber)
        if SliceNumber>=1 && SliceNumber<=Info.NumberFileMR(gui_ROI.SelectedMR)
            set(gui_ROI.PANELax.SLIDERimage, 'Value',(SliceNumber-1)/(Info.NumberFileMR(gui_ROI.SelectedMR)-1));
            Callback_SliderImage();
        end
    end
end


end

function MenuCallback_ZoomIn()
global gui_ROI;

axs = gui_ROI.PANELax.ax;
scrolls = 1;
% get the axes' x- and y-limits
xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');

xlim_new=[xlim(1)+scrolls*5 , xlim(2)-scrolls*5];
ylim_new=[ylim(1)+scrolls*5 , ylim(2)-scrolls*5];
if xlim_new(2) - xlim_new(1) <= 1, return, end
if ylim_new(2) - ylim_new(1) <= 1, return, end
if xlim_new(2) - xlim_new(1) > 300, return, end
if ylim_new(2) - ylim_new(1) > 300, return, end

set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
end

function MenuCallback_ZoomOut()
global gui_ROI;

axs = gui_ROI.PANELax.ax;
scrolls = -1;
% get the axes' x- and y-limits
xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');

xlim_new=[xlim(1)+scrolls*5 , xlim(2)-scrolls*5];
ylim_new=[ylim(1)+scrolls*5 , ylim(2)-scrolls*5];
if xlim_new(2) - xlim_new(1) <= 1, return, end
if ylim_new(2) - ylim_new(1) <= 1, return, end
if xlim_new(2) - xlim_new(1) > 300, return, end
if ylim_new(2) - ylim_new(1) > 300, return, end

set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
end

function MenuCallback_HURange()
global gui_ROI;

prompt = {'From:','To:'};
dlg_title = 'HU Range';
num_lines = 1;
def = {'-110','190'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(answer)
    if ~isempty(answer{1}) && ~isempty(answer{2})
        CLim_min=str2num(answer{1})+1024;
        CLim_max=str2num(answer{2})+1024;
        if ~isempty(CLim_min) || ~isempty(CLim_max)
            if CLim_min<CLim_max
                set(gui_ROI.PANELax.ax, 'CLim', [CLim_min CLim_max]);

                set(gui_ROI.PANELax.colorbar,'xtick',[ceil(CLim_min),floor(CLim_max)]);

                set(gui_ROI.PANELax.colorbar,'xticklabel',{num2str(ceil(CLim_min-1024)),num2str(ceil(CLim_max-1024))});
            end
            
        end
    end

end
end