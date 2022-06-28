%% Gui_Initialization()
% LISCOMP Lab 2021- 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function sets the inital parameters for the gui, enabling buttons 
% and panels.
% -------------------------------------------------------------------------
%%%% called by: Load_Data()

function Gui_Initialization()
global gui_ROI;

set(gui_ROI.PANELax.panel,'visible','off');
set(gui_ROI.PANELax.SLIDERimage,'value',0);
set(gui_ROI.PANELax.TXT,'string','');

set(gui_ROI.PANELroi.popup,'value',1,'enable','off');

set(gui_ROI.PANELroi.PANEL2.PB1,'enable','off');
set(gui_ROI.PANELroi.PANEL2.PB2,'enable','off');
set(gui_ROI.PANELroi.PANEL2.PB3,'enable','off');

set(gui_ROI.PANELroi.PANEL3.TXT1a,'enable','off');
set(gui_ROI.PANELroi.PANEL3.PB2,'enable','off');
set(gui_ROI.PANELroi.PANEL3.TXT3a,'enable','off');
set(gui_ROI.PANELroi.PANEL3.TXT1b,'string','');
set(gui_ROI.PANELroi.PANEL3.TXT2b,'string','');
set(gui_ROI.PANELroi.PANEL3.TXT3b,'string','');

set(gui_ROI.PANELroi.PANEL4.CKBOX1,'value',0,'enable','off');
set(gui_ROI.PANELroi.PANEL4.CKBOX2,'value',0,'enable','off');

set(gui_ROI.PANELroi.PANEL5.PB1,'enable','off');
set(gui_ROI.PANELroi.PANEL5.PB2,'enable','off');
set(gui_ROI.PANELroi.PANEL5.PB3,'enable','off');

set(gui_ROI.PBstart,'enable','off');

end

