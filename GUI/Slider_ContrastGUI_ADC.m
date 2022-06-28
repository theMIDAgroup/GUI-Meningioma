%% Slider_ContrastGUI_ADC()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION:
% This function sets the CLim values of the contrast, based on the maximum 
% and minimum Hounsfield values in the GUI ADC.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()

function Slider_ContrastGUI_ADC()

global gui_ADC;

t = get(gui_ADC.SLIDERcontrast,'value');
  
CLim_min = double(gui_ADC.sup_hu)*(t-.5)+double(gui_ADC.inf_hu);
CLim_max = double(gui_ADC.sup_hu)*(t-.5)+double(gui_ADC.sup_hu);

if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(gui_ADC.ax, 'CLim', [CLim_min CLim_max]);
set(gui_ADC.ax_ls, 'CLim', [CLim_min CLim_max]);

end
