## fsl2matlab
## LiscompLAB - 2021
####
#### This file uses FSL to coregister T1 and ADC images and save the transformation matrix.
#### Instructions:
#### - CHANGE SUBJECT ID NUMBER: "inizio" (line 15)
#### - PRESS RUN

from nipype.interfaces import fsl
import os

if __name__ == '__main__':

    # Pazienti da coregistrare
    inizio = 90
    fine =  inizio + 1

    for num in range(inizio, fine):       

        flt = fsl.FLIRT(bins=256, cost='corratio', interp='trilinear',
                    dof=12, \
                    searchr_x=[-90, 90], searchr_y=[-90, 90],
                    searchr_z=[-90, 90])

        parent_folder = f'/Users/valentina/Documents/PostDoc/Radiomics/NEW_GUI_Meningioma/Data/data_auto'

        if num<10:
            run_folder = f'M00{num}'
        else:
            run_folder = f'M0{num}'

        result_folder = f'T1_OUTPUT_MASK'
        path = os.path.join(parent_folder, run_folder, result_folder)
        flt.inputs.in_file = os.path.join(path, f"T1.nii.gz")
        flt.inputs.reference = os.path.join(path, f"ADC.nii.gz")
        flt.inputs.out_file = os.path.join(path, f"coregistration_T1_ADC.nii.gz")
        flt.inputs.out_matrix_file = os.path.join(path, f"coregistration_matrix.mat")
        
        flt.inputs.output_type = "NIFTI_GZ"
        flt.cmdline
        print(flt.cmdline)
        flt.run()
