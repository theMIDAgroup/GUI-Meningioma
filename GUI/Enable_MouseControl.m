%% Enable_MouseControl()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function enables some commands for zooming with scrollwheel and 
% panning with mouseclicks.
% -------------------------------------------------------------------------
%%%% called by: Show_Image()
%%%% call:  Slider_Image_brain()
%%%%        Drag_Off()

function Enable_MouseControl()

global gui_ROI;
global Info;

MainFig = gui_ROI.fig;
axs = gui_ROI.PANELax.ax;
status = '';  previous_point = [];

% define zooming with scrollwheel, and panning with mouseclicks
set(MainFig, ...
    'WindowScrollWheelFcn' , @scroll_slice,...
    'WindowButtonDownFcn'  , @pan_click,...
    'WindowButtonUpFcn'    , @pan_release,...
    'WindowButtonMotionFcn', @pan_motion);

% zoom in to the current point with the mouse wheel
    function scroll_zoom(varargin)
        scrolls = varargin{2}.VerticalScrollCount;
        % get the axes' x- and y-limits
        xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');
        
        xlim_new = [xlim(1)+scrolls*5 , xlim(2)-scrolls*5];
        ylim_new = [ylim(1)+scrolls*5 , ylim(2)-scrolls*5];
        if xlim_new(2) - xlim_new(1) <=  1, return, end
        if ylim_new(2) - ylim_new(1) <=  1, return, end
        if xlim_new(2) - xlim_new(1) > 512, return, end
        if ylim_new(2) - ylim_new(1) > 512, return, end
        
        set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
        
    end % scroll_zoom



    function scroll_slice(varargin)
        scrolls = -varargin{2}.VerticalScrollCount;
        SliceNumber = round(get(gui_ROI.PANELax.SLIDERimage, 'Value')*(Info.NumberFileMR-1)+1);
        
        if scrolls>0
            if SliceNumber + scrolls < Info.NumberFileMR 
                gui_ROI.SliceNumber = SliceNumber+scrolls;
                set(gui_ROI.PANELax.SLIDERimage, 'Value',(gui_ROI.SliceNumber-1)/(Info.NumberFileMR-1));
            else
                gui_ROI.SliceNumber = Info.NumberFileMR;
                set(gui_ROI.PANELax.SLIDERimage, 'Value',(gui_ROI.SliceNumber-1)/(Info.NumberFileMR-1));
            end
            Slider_Image_brain();
        else
            if SliceNumber+scrolls > 1
                gui_ROI.SliceNumber = SliceNumber+scrolls;
                set(gui_ROI.PANELax.SLIDERimage, 'Value',(gui_ROI.SliceNumber-1)/(Info.NumberFileMR-1));
            else
                gui_ROI.SliceNumber = 1;
                set(gui_ROI.PANELax.SLIDERimage, 'Value',(gui_ROI.SliceNumber-1)/(Info.NumberFileMR-1));
            end
            Slider_Image_brain();
        end
        
        
    end % scroll_slice





% pan upon mouse click
    function pan_click(varargin)
        switch lower(get(MainFig, 'selectiontype'))
            % start panning on right click
            case 'alt'
                status = 'down';
                previous_point = get(axs, 'CurrentPoint');
                
                % start panning on left click
            case 'normal'
                Drag_Off;
                % reset view on double click
            case 'open' % double click (left or right)
                set(axs, 'xlim', [0.5 512.5], 'ylim',[0.5 512.5]);
        end
    end

    function pan_release(varargin)
        % just reset status
        status = '';
        
        % Callback_DragOn;

    end

% move the mouse (with button clicked)
    function pan_motion(varargin)
        
        % return if there isn't a previous point
        if isempty(previous_point), return, end
        % return if mouse hasn't been clicked
        if isempty(status), return, end
        % get current location (in pixels)
        current_point = get(axs, 'CurrentPoint');
        % get current XY-limits
        xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');
        % find change in position
        delta_points = current_point - previous_point;
        % adjust limits
        xlim_new = xlim - delta_points(1);
        ylim_new = ylim - delta_points(3);
        % set new limits
        if (xlim_new(2)>512 ||  xlim_new(1) <=  0), return, end
        if (ylim_new(2)>512 ||  ylim_new(1) <=  0), return, end
        set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
        % save new position
        previous_point = get(axs, 'CurrentPoint');
    end
end
%%
