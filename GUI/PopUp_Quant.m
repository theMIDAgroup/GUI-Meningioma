%% PopUp_Quant()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function opens a menu for the selection of the quantization for
% radiomics calculations. default is 'Equal'. See radiomics codes and 
% prepareVolume. 
% Quantization types: Equal, Uniform, Lloyd, noQuant.
% -------------------------------------------------------------------------
%%%% called by: main_gui_brain() - panel 'Quantization algorithm'

function PopUp_Quant()
global gui_ROI;

val_quant = get(gui_ROI.PANELquantAlgo.popup,'value');
if val_quant==1; gui_ROI.PopupValueQuant='Equal';
elseif val_quant==2; gui_ROI.PopupValueQuant='Uniform';
elseif val_quant==3; gui_ROI.PopupValueQuant='Lloyd';
elseif val_quant==4; gui_ROI.PopupValueQuant='noQuant';  
end

end
