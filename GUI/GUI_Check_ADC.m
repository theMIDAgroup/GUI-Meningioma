%% GUI_Check_ADC()
% LISCOMP Lab 2021- 2022 https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function creates a GUI. With this GUI one can:
% - visualize the result of the transformation of the T1 mask on the ADC
%   image through coregistration;
% - modify the mask in case it does not correspond exactly to the
%   tumour region.
% It is possible to scroll all the ADC slices using the buttons 'Next
% slice' and 'Previous slice'. Once finished, click 'Done' in order to
% save changes and continue with the radiomics analysis (ADC).
% -------------------------------------------------------------------------
%%%% called by: mask_adc_nii2mat()
%%%%            main_gui_brain(), button "Check segmentation ADC on GUI"
%%%% call:  Show_ROI_ADC()
%%%%        Save_Last_Slice_ADC()
%%%%        Go_Previous_Slice_ADC()
%%%%        Go_Next_Slice_ADC()
%%%%        Slider_WindowDown_GUI_ADC()
%%%%        Slider_WindowUp_GUI_ADC()
%%%%        Slider_ContrastGUI_ADC()
%%%%        Replace_With_Previous_Slice_ADC()
%%%%        Replace_With_Next_Slice_ADC()

function GUI_Check_ADC()

global pos
global gui_ROI
global ROI
global gui_ADC
global Info

pos.FIGURE_test = pos.FIGURE - [10,25,0,0];
pos.PANEL_test = [5,5,pos.FIGURE_test(3)-5,pos.FIGURE_test(4)-5];
pos.TxtROI = [90,590,50,50].*pos.scale_factor;           
pos.TxtROI_val = [130,590,50,50].*pos.scale_factor;     
pos.TxtROIof = [160,590,30,50].*pos.scale_factor;       
pos.TxtROI_num = [180,590,50,50].*pos.scale_factor;      
pos.TxtSlice = [230,590,80,50].*pos.scale_factor;        
pos.TxtSlice_val = [285,590,50,50].*pos.scale_factor;    
pos.TxtSliceof = [320,590,30,50].*pos.scale_factor;      
pos.TxtSlice_num = [340,590,50,50].*pos.scale_factor;    
pos.ax = [20,85,490,490].*pos.scale_factor;
pos.ax_ls = [475,85,490,490].*pos.scale_factor;
pos.SLIDERcontrast = round([10,85,25,490].*pos.scale_factor);
pos.SLIDERwindowUp_edit=round([5,630,80,25].*pos.scale_factor);
pos.SLIDERwindowDown_edit=round([5,50,80,25].*pos.scale_factor);
pos.SLIDERwindowUp_push=round([5,590,80,25].*pos.scale_factor);
pos.SLIDERwindowDown_push=round([5,10,80,25].*pos.scale_factor);

pos.replace_with_previous = [470,650,300,50].*pos.scale_factor;
pos.replace_with_next = [780,650,300,50].*pos.scale_factor;
pos.Previous_slice = [350,15,180,50].*pos.scale_factor;
pos.Next_slice = [555,15,120,50].*pos.scale_factor;
pos.delete_mask = [950,450,170,50].*pos.scale_factor;
pos.Done = [730,15,120,50].*pos.scale_factor;

gui_ADC.fig = figure('Position',pos.FIGURE_test,'Name','CHECK ADC SLICES');
set(gui_ADC.fig,'NumberTitle','off');
set(gui_ADC.fig,'Color',gui_ROI.bgc_light);

gui_ADC.panel=uipanel('parent',gui_ADC.fig,'Title',...
    'check CT images','units','pixel',...
    'Position',pos.PANEL_test,...
    'FontWeight','bold','FontSize',gui_ROI.fs,...
    'visible','on',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc);

gui_ADC.TxtROI = uicontrol('parent',gui_ADC.panel,...
    'style', 'text',...
    'units', 'pixel',...
    'string', 'ROI',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtROI);

gui_ADC.TxtROI_val = uicontrol('parent',gui_ADC.panel,...
    'style', 'text',...
    'units', 'pixel',...
    'string', '1',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtROI_val);

gui_ADC.TxtROIof = uicontrol('parent',gui_ADC.panel,...      
    'style', 'text',...
    'units', 'pixel',...
    'string', 'of',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtROIof);

gui_ADC.TxtROI_num = uicontrol('parent',gui_ADC.panel,...     
    'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtROI_num);

gui_ADC.TxtSlice = uicontrol('parent',gui_ADC.panel,...
    'style', 'text',...
    'units', 'pixel',...
    'string', 'Slice',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtSlice);

gui_ADC.TxtSlice_val = uicontrol('parent',gui_ADC.panel,...
    'style', 'text',...
    'units', 'pixel',...
    'string', '1',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtSlice_val);

gui_ADC.TxtSliceof = uicontrol('parent',gui_ADC.panel,...     
    'style', 'text',...
    'units', 'pixel',...
    'string', 'of',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtSliceof);

gui_ADC.TxtSlice_num = uicontrol('parent',gui_ADC.panel,...    
    'style', 'text',...
    'units', 'pixel',...
    'string', '',...
    'BackGroundColor',gui_ROI.bgc_drop,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'position', pos.TxtSlice_num);

gui_ADC.ax=axes('parent',gui_ADC.panel,...
    'units','pixel',...
    'Title', 'Original',...
    'Position',pos.ax,...
    'xlim',[0.5 300.5],'ylim',[0.5 300.5]);
gui_ADC.ax_ls=axes('parent',gui_ADC.panel,...
    'units','pixel',...
    'Title', 'LS',...
    'Position',pos.ax_ls,...
    'xlim',[0.5 300.5],'ylim',[0.5 300.5]);

gui_ADC.SLIDERcontrast = uicontrol(gui_ADC.panel,...
    'Style','slider','Min',0,'Max',1,...
    'Value',gui_ROI.scale4contrast,'SliderStep',[0.01 0.05],...
    'units','pixel',...
    'position',pos.SLIDERcontrast,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'Callback','Slider_Contrast_GUI_Check_ADC');

gui_ADC.SLIDERwindowUp_edit=uicontrol(gui_ADC.panel,'Style','edit',...
    'string',0,...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.SLIDERwindowUp_edit,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ADC.SLIDERwindowDown_edit=uicontrol(gui_ADC.panel,'Style','edit',...
    'string',0,...
    'units','pixel',...
    'visible', 'on',...
    'position',pos.SLIDERwindowDown_edit,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on');

gui_ADC.SLIDERwindowUp_push=uicontrol(gui_ADC.panel,'Style','pushbutton',...
    'String','APPLY',...
    'units','pixel',...
    'position',pos.SLIDERwindowUp_push,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Slider_WindowUp_GUI_Check_ADC;');

gui_ADC.SLIDERwindowDown_push=uicontrol(gui_ADC.panel,'Style','pushbutton',...
    'String','APPLY',...
    'units','pixel',...
    'position',pos.SLIDERwindowDown_push,...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'callback', 'Slider_WindowDown_GUI_Check_ADC;');

gui_ADC.replace_with_previous = uicontrol(gui_ADC.panel,'style',...  
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Replace with previous slice',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.replace_with_previous,...
    'callback', 'Replace_With_Previous_Slice_ADC;');

gui_ADC.replace_with_next = uicontrol(gui_ADC.panel,'style',...       
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Replace with next slice',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'position',pos.replace_with_next,...
    'callback', 'Replace_With_Next_Slice_ADC;');

gui_ADC.Next_slice = uicontrol(gui_ADC.panel,'style',...
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Next slice',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','on',...
    'position',pos.Next_slice,...
    'callback', 'Go_Next_Slice_ADC;');

gui_ADC.delete_mask = uicontrol(gui_ADC.panel,'style',...
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Delete current mask',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.delete_mask,...
    'callback', 'Delete_maskADC;');

gui_ADC.Previous_slice = uicontrol(gui_ADC.panel,'style',...
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Previous slice',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.Previous_slice,...
    'callback', 'Go_Previous_Slice_ADC;');

gui_ADC.Done = uicontrol(gui_ADC.panel,'style',...
    'pushbutton',...
    'units', 'pixel',...
    'string', 'Done',...
    'BackGroundColor',gui_ROI.bgc,...
    'ForeGroundColor',gui_ROI.fgc,...
    'FontSize',gui_ROI.fs,...
    'enable','off',...
    'position',pos.Done,...
    'callback', 'Save_Last_Slice_ADC;');

gui_ADC.first_opening=0;

gui_ADC.idx_ROI_enabled = [];
for val = 1 : size(ROI,2)
    if ROI{val}.Enable
       gui_ADC.idx_ROI_enabled = [gui_ADC.idx_ROI_enabled, val];
    end
end
gui_ADC.n_ROI = 1;
gui_ADC.val = gui_ADC.idx_ROI_enabled(gui_ADC.n_ROI);
set(gui_ADC.TxtROI_val,'string', num2str(gui_ADC.val));

Nval = length(ROI);

for val = 1 : Nval
    
    if ROI{val}.Enable
        aux_NumSlices = size(ROI{val}.MasksADC);
        gui_ADC.NumSlices{val} = aux_NumSlices(3);
        gui_ADC.SlicesList{val} = linspace(1,gui_ADC.NumSlices{val},gui_ADC.NumSlices{val});
        if ~isfield(ROI{val},'first_next_ADC')      % first time I open ADC
            ROI{val}.first_next_ADC = zeros(1,gui_ADC.NumSlices{val});
            ROI{val}.pos_ADC_masks = cell(1,Info.SizeADC(3));
        end
    end
end

% Set the number of ROIs and slices in the gui panel
set(gui_ADC.TxtROI_num,'string', num2str(length(gui_ADC.idx_ROI_enabled)));   
set(gui_ADC.TxtSlice_num,'string', num2str(length(gui_ADC.SlicesList{gui_ADC.val})));   

gui_ADC.k = 1;
gui_ADC.it2show = gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k);

Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show)
end
