%% Run_GUI_CheckSlices()
% LISCOMP Lab 2021- 2022 https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets all the needed parameters to open a GUI without
% running main_gui_brain. In order to do it: run this file, load the files
% Info.mat and ROI.mat for a selected patient, and run GUI_Check_T1 or
% GUI_Check_ADC if ADC is present.
% -------------------------------------------------------------------------

global pos
global gui_ROI

screen_x=0.97;
screen_y=0.83;
scrsz = get(0,'ScreenSize');

%%%% gui position
position(1,3)=round(scrsz(1,3)*screen_x); %-x
position(1,4)=round(scrsz(1,4)*screen_y); %-y
position(1,1)=round((scrsz(1,3)*.99-position(1,3)));
position(1,2)=round((scrsz(1,4)-position(1,4))/2);

%%%% scale factor for gui
vect_pixel_sambu=[1920 1058 1920 1058];
vect_pixel_screen=[scrsz(1,3),scrsz(1,4),scrsz(1,3),scrsz(1,4)];
pos.scale_factor=(vect_pixel_screen./vect_pixel_sambu).*[screen_x/.6 screen_y/.7 screen_x/.6 screen_y/.7];

pos.FIGURE=position;

if ispc==1, gui_ROI.slash_pc_mac='\'; else gui_ROI.slash_pc_mac='/'; end

gui_ROI.first_opening=0;
gui_ROI.scale4contrast=0.5;

gui_ROI.bgc = [0.4 0.4 0.4]; 
gui_ROI.bgc_light = [0.4 0.4 0.4];
gui_ROI.fgc = [1,1,1]; %[1,0,0];
gui_ROI.fs = 16;
gui_ROI.bgc_drop = [0.5 0.5 0.5];
gui_ROI.fgc_drop = [0.4 0.4 0.4];
gui_ROI.bgc_ppm = [0.8 0.8 0.8];
gui_ROI.fgc_ppm = [0.4 0.4 0.4];
gui_ROI.SelectedMR = 1;

