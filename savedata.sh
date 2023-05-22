# July - 2022
# Jess Archibald - to save output data in master file

# Loop to put all voxel locations CT results of each subject in one folder.
 # cd into the subjects freesurfer directory... it will loop through all folders in there
#!/bin/bash

for subID in P01 S* ; do
  cat $subID/surf/${subID}_results-new.txt >> Cortical_thickness_results.txt
done


# echo ${subID[2]}
