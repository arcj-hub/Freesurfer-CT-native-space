# Freesurfer-CT-native-space

This repository contains a script designed to estimate cortical thickness (CT) values based on masks, to be used after the "recon -all" process and data visualization in the Freesurfer software. The script was initially created by Jessica Archibald in April 2023 and has been subsequently edited by Alex Weber in May 2023.

# Code Description
The main script is named "loop_CT.sh" and is written in Bash. It performs the following steps:

Defines a list of subject IDs (SUBJECTS) and a list of regions of interest (LOCS).
Iterates over each subject ID and region of interest combination.
Converts the thickness surface to a volume for both hemispheres using the mri_surf2vol command.
Reorients the thickness volume and the brain MRI volume to a standard orientation using fslreorient2std and mri_convert.
Registers the mask to the reoriented thickness volume using flirt.
Thresholds and binarizes the registered mask using fslmaths.
Calculates the mean and standard deviation of the cortical thickness within the region of interest using fslstats.
Appends the result to a subject-specific text file.
Optionally, it suggests using Freeview to visualize the registered mask on the brain volume.

savedata.sh
The script savedata.sh, created by Jess Archibald in July 2022, is meant to be run after the loop_CT.sh script. It saves the output data from each subject in a master file named "Cortical_thickness_results_May2023.txt". The script performs the following steps:

Loops through all the folders in the subjects' FreeSurfer directory.
Appends the contents of each subject's CT results file (${subID}_results-new.txt) to the master file.

# Usage
To use this script:

Ensure that you have the necessary dependencies installed, such as Freesurfer and FSL.
Modify the SUBJECTS and LOCS variables in the script to match your subject IDs and regions of interest.
Run the script by executing the loop_CT.sh file.
It is recommended to review the resulting text files and visualize the registered mask on the brain volume to verify the accuracy of placement.
After running loop_CT.sh, run the savedata.sh script by executing the savedata.sh file.
Review the resulting master file "Cortical_thickness_results.txt" for the combined CT results of all subjects.


Please note that the paths to the subject data directories (SUBJECTS_DIR) and other dependencies may need to be modified according to your specific setup.

Feel free to contribute to this repository and provide any feedback or suggestions.
