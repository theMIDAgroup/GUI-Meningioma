## maskT1_2_maskADC
## LiscompLAB - 2021
####
#### This file uses FSL to apply the coregistration matrix to T1 mask (for each ROI).
#### This procedure produces volume masks on ADC images (one for each ROI).
#### From here, come back to Matlab and run mask_adc_nii2mat.m
#### Instructions:
#### - CHANGE SUBJECT ID NUMBER: "subj" (line 19)
#### - CHANGE ROI NUMBER: "district" (line 20)
#### - PRESS RUN

from nipype.interfaces import fsl
import os

if __name__ == '__main__':

        parent_folder = f'/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_auto'

        subj = 90
        district = 1


        if subj<10:
            run_folder = f'M00{subj}'
        else:
            run_folder = f'M0{subj}'

        flt = fsl.FLIRT(bins=640, cost_func='corratio')
        
        input_folder = f'T1_OUTPUT_MASK/'
        input_path = os.path.join(parent_folder, run_folder, input_folder)
        result_folder = f'T1_OUTPUT_MASK/Mask_District{district}/'
        result_path = os.path.join(parent_folder, run_folder, result_folder)

        flt.inputs.in_file = os.path.join(result_path, f"T1_mask.nii.gz")
        flt.inputs.reference = os.path.join(input_path, f"ADC.nii.gz")
        flt.inputs.out_file = os.path.join(result_path, f"ADC_mask.nii.gz")
        flt.inputs.in_matrix_file = os.path.join(input_path, f"coregistration_matrix.mat")

        flt.inputs.apply_xfm = True
        res = flt.run()
    