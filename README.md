# GUI-Meningioma

Matlab Graphic User Interfaces (GUIs) for image visualization, segmentation and radiomics feature extraction for MRI images (T1 and ADC sequences) of meningioma patients. The feature extraction package has been directly taken from https://github.com/mvallieres/radiomics, with slight modifications for 2D analysis, quantization algorithm and default image resampling.  

The code is based on the following publications:

*2022 I. Cama, V. Candiani, M. Piana and C. Campi, "A comprehensive package for segmentation and radiomics analysis of Magnetic Resonance images", submitted.

*2022 I. Cama, V. Candiani, L. Roccatagliata, P. Fiaschi, G. Rebella, M. Resaz, M. Piana and C. Campi, "Segmentation accuracy and the reliability of radiomics features", preprint available at TechRxiv, doi: 10.36227/techrxiv.21493935.v1.

*2015 M. Vallières, C.R. Freeman, S.R. Skamene, I. El Naqa, “A radiomics model from joint FDG-PET and MRI texture features for the prediction of lung metastases in soft-tissue sarcomas of the extremities”, Phys Med Biol. 2015 Jul 21;60(14):5471-96. doi: 10.1088/0031-9155/60/14/5471.

*2001 T. F. Chan and L. A. Vese, "Active contours without edges," in IEEE Transactions on Image Processing, vol. 10, no. 2, pp. 266-277, Feb. 2001, doi: 10.1109/83.902291.

Usage:

Code is written in Matlab R2022a and tested with versions up to R2019b.
main_gui_brain.m file launches a Matlab GUI for image visualization and ROI definition (GUI 1). It requires standard DICOM data. A second GUI (GUI 2) will open when the segmentation algorithm has finished to check the segmentation results on T1 images (see details on the comprehensive ReadMe_GUI_Meningioma.doc file). ADC coregistration results can be visualized on a third GUI (GUI 3). Test data can be found in the "DATA" folder.

Copyright:

The GUI-Meningioma software is free but copyrighted software, distributed under the terms of the GNU General Public Licence as published by the Free Software Foundation (either version 3, or at your option any later version). See the files Copyright and license for more details.
