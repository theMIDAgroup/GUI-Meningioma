%% PopUp_Districts()% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it% -------------------------------------------------------------------------% DESCRIPTION: % This function opens a menu for the selection of the district:% - it enables the ROI kind (rectangle, ellipse or polygon),% - it enables the choice of output through Enable_Roi()% - it draws the ROI calling the function Draw_ROI()% - it automatically selects the Hounsfield value for the segmentation.% -------------------------------------------------------------------------%%%% called by: main_gui_brain() - panel 'ROI 1'%%%%            Reset_Roi()%%%%            Reset_All()%%%%            DeleteSlices()%%%%            AppendROIs()%%%% call: Show_Image()%%%%       Enable_ROI()%%%%       Draw_ROI()function PopUp_Districts()global gui_ROI;global ROI;set(gui_ROI.PANELroi.PANEL2.PB1,'enable','off');      % ROI rectangleset(gui_ROI.PANELroi.PANEL2.PB2,'enable','off');      % ROI ellipseset(gui_ROI.PANELroi.PANEL2.PB3,'enable','off');      % ROI polyset(gui_ROI.PANELroi.PANEL3.TXT1a,'enable','off');    % STARTset(gui_ROI.PANELroi.PANEL3.PB2,'enable','off');      % ENDset(gui_ROI.PANELroi.PANEL3.TXT1b,'string','');set(gui_ROI.PANELroi.PANEL3.TXT2b,'string','');set(gui_ROI.PANELroi.PANEL3.TXT3b,'string','');set(gui_ROI.PANELroi.PANEL4.CKBOX1,'value',0,'enable','off'); % Enable ROIset(gui_ROI.PANELroi.PANEL5.PB1,'enable','off');Show_Image;val = get(gui_ROI.PANELroi.popup,'value')-1;gui_ROI.PopupValue = val;if and(val,val-length(gui_ROI.PANELroi.ROIName))        set(gui_ROI.PANELroi.PANEL4.CKBOX1,'enable','on','value',ROI{val}.Enable);        Enable_Roi;    set(gui_ROI.PANELroi.PANEL5.PB1,'enable','on');        set(gui_ROI.PANELroi.PANEL2.PB1,'enable','on');    set(gui_ROI.PANELroi.PANEL2.PB2,'enable','on');    set(gui_ROI.PANELroi.PANEL2.PB3,'enable','on');            set(gui_ROI.PANELroi.PANEL3.TXT1a,'enable','on');    set(gui_ROI.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartMR));        set(gui_ROI.PANELroi.PANEL3.TXT2b,'string',num2str(ROI{val}.EndMR));    if ~isempty(ROI{val}.RoiSlice) && ~ROI{val}.RoiEnd, set(gui_ROI.PANELroi.PANEL3.PB2,'enable','on'); end        if ~ROI{val}.RoiEmpty                [~,aux_position] = ismember(gui_ROI.SliceNumber,ROI{val}.RoiSlice);        if aux_position            RoiPosition = ROI{val}.RoiPosition{aux_position};            RoiKind = ROI{val}.RoiKind{aux_position};                        Draw_Roi(RoiKind,RoiPosition, aux_position);        end    end            endend