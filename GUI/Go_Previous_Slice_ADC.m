%% Go_Previous_Slice_ADC()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function saves the changes of the current mask (if it exists) in 
% gui_ADC and sets the previous slice as the new current slice.
% -------------------------------------------------------------------------
%%%% called by: GUI_Check_ADC()
%%%% call: Show_ROI_ADC()

function Go_Previous_Slice_ADC()
global ROI;
global gui_ADC;

if ROI{gui_ADC.val}.first_next_ADC(gui_ADC.it2show) == 0
    ROI{gui_ADC.val}.first_next_ADC(gui_ADC.it2show) = 1;
end

if ROI{gui_ADC.val}.pos_ADC_masks{gui_ADC.it2show} == 1
    aux = gui_ADC.ROI_ls(gui_ADC.it2show);
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).row = aux.Position(:,1);
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).col = aux.Position(:,2);
else  
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).row = [];
    ROI{gui_ADC.val}.aux_pos_ls_ADC(gui_ADC.it2show).col = [];
end

if gui_ADC.k ~= 1
    gui_ADC.k = gui_ADC.k - 1;
    gui_ADC.it2show = gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k);
    set(gui_ADC.TxtSlice_val,'string', num2str(gui_ADC.it2show));
    set(gui_ADC.Next_slice,'enable','on')
    Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show)
else
    
    if gui_ADC.n_ROI ~= 1
        
        gui_ADC.n_ROI = gui_ADC.n_ROI - 1;
        gui_ADC.val = gui_ADC.idx_ROI_enabled(gui_ADC.n_ROI);
        set(gui_ADC.TxtROI_val,'string', num2str(gui_ADC.val));

        gui_ADC.k = gui_ADC.NumSlices{gui_ADC.val};
        gui_ADC.it2show = gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.k);  

        set(gui_ADC.TxtSlice_val,'string', num2str(gui_ADC.it2show));
        set(gui_ADC.TxtSlice_num,'string', num2str(length(gui_ADC.SlicesList{gui_ADC.val})));   
        Show_ROI_ADC(gui_ADC.val,gui_ADC.it2show)
        
        set(gui_ADC.Next_slice,'enable','on')
        set(gui_ADC.Done,'enable','off')
    else
        set(gui_ADC.Previous_slice,'enable','off')
        set(gui_ADC.Next_slice,'enable','on')
    end
    
end

if gui_ADC.n_ROI == 1 && gui_ADC.it2show == 1
    set(gui_ADC.Previous_slice,'enable','off')
else
    set(gui_ADC.Previous_slice,'enable','on')
end

% in order to disable the "replace with previous" button if considering the
% first slice
if gui_ADC.it2show == 1
    set(gui_ADC.replace_with_previous,'enable','off')
else
    set(gui_ADC.replace_with_previous,'enable','on')
end

% in order to disable the "replace with next" button if considering the
% last slice
if gui_ADC.it2show == gui_ADC.SlicesList{gui_ADC.val}(gui_ADC.NumSlices{gui_ADC.val})
    set(gui_ADC.replace_with_next,'enable','off')
else
    set(gui_ADC.replace_with_next,'enable','on')
end

end





