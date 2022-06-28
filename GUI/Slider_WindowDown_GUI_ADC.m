%% Slider_WindowDown_GUI_ADC()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function changes the CLim of the Hounsfield values in the GUI ADC.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()

function Slider_WindowDown_GUI_ADC()

global pet_gui;
global gui_ADC;

set(gui_ADC.SLIDERcontrast,'value',0.5);
aux_down = get(gui_ADC.SLIDERwindowDown_edit,'string');
aux_down = str2num(aux_down);
gui_ADC.inf_hu = aux_down;
CLim_min = aux_down;
aux = get(gui_ADC.ax, 'CLim');
CLim_max = aux(2);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_ADC.ax, 'CLim', [CLim_min CLim_max]);
set(gui_ADC.ax_ls, 'CLim', [CLim_min CLim_max]);

end