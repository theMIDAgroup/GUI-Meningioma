%% Slider_WindowUp_GUI_ADC()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function changes the CLim of the Hounsfield values in the GUI ADC.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()

function Slider_WindowUp_GUI_ADC()
global gui_ADC;

set(gui_ADC.SLIDERcontrast,'value',0.5);
aux_up = get(gui_ADC.SLIDERwindowUp_edit,'string');
aux_up = str2num(aux_up);
gui_ADC.sup_hu = aux_up;
CLim_max = aux_up;
aux = get(gui_ADC.ax, 'CLim');
CLim_min = aux(1);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_ADC.ax, 'CLim', [CLim_min CLim_max]);
set(gui_ADC.ax_ls, 'CLim', [CLim_min CLim_max]);

end
