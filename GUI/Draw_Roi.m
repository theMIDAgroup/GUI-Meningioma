%% Draw_Roi()
% LISCOMP Lab 2021 - 2022, https://liscomp.dima.unige.it
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function draws a rectangular ROI and stores RoiRegion in the struct 
% ROI thorugh the functions Store_roiRemove(q,varargin) and 
% Store_roi(q,varargin).
% -------------------------------------------------------------------------
%%%% called by: Slider_Image_brain()
%%%%            Put_Roi()
%%%%            PopUp_Districts()
%%%% call:  Store_roi()                (included in this file)
%%%%        Store_roiRemove()          (included in this file)
%%%%        Region_Mod4()

function Draw_Roi(RoiKind,RoiPosition,idx_ic,color,RoiRemoveKind,RoiRemovePosition,colorRemove)
global gui_ROI;
global ROI;

if nargin<4, color='green'; end
h = feval(RoiKind,gui_ROI.PANELax.ax,RoiPosition);
setColor(h,color);
fcn = makeConstrainToRectFcn(RoiKind,[0.5 300.5],[0.5 300.5]);
setPositionConstraintFcn(h,fcn);
api = iptgetapi(h);

it = gui_ROI.PopupValue;
ROI{it}.RoiSlice(idx_ic) = gui_ROI.SliceNumber;
ROI{it}.RoiKind{idx_ic} = RoiKind;

Store_roi(RoiPosition);

if nargin>=6
    if nargin==6, colorRemove='red'; end
    hRemove = feval(RoiRemoveKind,gui_ROI.PANELax.ax,RoiRemovePosition);
    setColor(hRemove,colorRemove);
    fcnRemove = makeConstrainToRectFcn(RoiRemoveKind,[0.5 512.5],[0.5 512.5]);
    setPositionConstraintFcn(hRemove,fcnRemove);
    apiRemove = iptgetapi(hRemove);
    ROI{it}.RoiRemoveKind{idx_ic}=RoiRemoveKind;
    ROI{it}.RoiRemovePosition{idx_ic}=RoiRemovePosition;
    
    apiRemove.addNewPositionCallback(@(q) Store_roiRemove(q));
end

api.addNewPositionCallback(@(p) Store_roi(p));

    function Store_roiRemove(q,varargin)
        ROI{it}.RoiRemovePosition{idx_ic}=q;
    end

    function Store_roi(p,varargin)
        banda_bordo = 10; 
        ROI{it}.RoiPosition{idx_ic}=p;
        if ~strcmp(RoiKind,'impoly')
            aux1=max([ceil(p(1))-banda_bordo,1]);
            aux3=max([ceil(p(2))-banda_bordo,1]);
            aux2=min([floor(p(1)+p(3))+banda_bordo,512]);
            aux4=min([floor(p(2)+p(4))+banda_bordo,512]);
        else
            aux1=max([ceil(min(p(:,1)))-banda_bordo,1]);
            aux3=max([ceil(min(p(:,2)))-banda_bordo,1]);
            aux2=min([floor(max(p(:,1)))+banda_bordo,512]);
            aux4=min([floor(max(p(:,2)))+banda_bordo,512]);
        end
        [aux1,aux2,aux3,aux4]=Region_Mod4(aux1,aux2,aux3,aux4);
        ROI{it}.RoiRegion(idx_ic,:)=[aux1,aux2,aux3,aux4];
    end
end
