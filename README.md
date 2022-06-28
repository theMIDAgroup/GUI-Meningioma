# GUI-Meningioma
MATLAB/Python programming tools for image segmentation and radiomics analysis

Matlab Graphic User Interface (GUI) for image visualization, segmentation and radiomics feature extraction for MRI images of meningioma patients. The feature extraction package has been directly taken from https://github.com/mvallieres/radiomics, with slight modifications for 2D analysis.  

The code is based on the following publications:

*2022 I. Cama, V. Candiani, M. Piana and C. Campi, "Impact of segmentation accuracy on features quality and robustness in radiomics", to be submitted.

*2015 M. Vallières, C.R. Freeman, S.R: Skamene, I. El Naqa, “A radiomics model from joint FDG-PET and MRI texture features for the prediction of lung metastases in soft-tissue sarcomas of the extremities”, Phys Med Biol. 2015 Jul 21;60(14):5471-96. doi: 10.1088/0031-9155/60/14/5471.

Usage:

Code is written in Matlab R2021b and tested with versions up to R2019b.
main_gui_brain.m file launches a Matlab GUI for image visualization and ROI definition. It requires standard DICOM data. A second GUI will open when the segmentation algorithm has finished (see details on the comprehensive ReadMe file). Test data can be found in the "data test" folder.
