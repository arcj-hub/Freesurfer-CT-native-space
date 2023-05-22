#!/bin/bash

#set -e

# This script should be run after recon -all and visualization of the data, to estimate CT from masks.
# Jessica Archibald 2023 April with edits by Alex Weber 2023 May
# ~/loop_CT.sh

# List of subject IDs
SUBJECTS="P01 "
# SUBJECTS="sub-Pilot05"
SUBJECTS_DIR=/Users/jessicaarchibald/freesurfer/7.2.0/subjects
# SUBJECTS_DIR=/home/weberam2/Desktop/jesstest/derivatives/FastSurfer
# List of ROI locations
LOCS="ACC HCC MCC PCC"
# LOCS="visual"

# Loop over subject IDs and ROI locations
for SUBJECT in $SUBJECTS; do
  for LOC in $LOCS; do
    echo "Processing $SUBJECT $LOC"

    fol=$SUBJECTS_DIR/$SUBJECT

    # Convert Thickness Surface to Volume (both hemispheres)
    mri_surf2vol --o $fol/thickness.nii.gz --subject $SUBJECT --so $fol/surf/lh.white $fol/surf/lh.thickness --so $fol/surf/rh.white $fol/surf/rh.thickness

    # Reorient thickness to standard orientation
    fslreorient2std $fol/thickness.nii.gz $fol/thickness_reorient.nii.gz

    # Let's also reorient the brain.mgz while we're at it for later visuals
    mri_convert $fol/mri/brain.mgz $fol/mri/brain.nii.gz
    fslreorient2std $fol/mri/brain.nii.gz $fol/mri/brain_reorient.nii.gz

    # Register mask to thickness (should just need to adjust resolution/FOV/etc.)
    # Note, it is assumed the mask is already in T1w scanner space
    flirt -in $fol/$LOC/mask.nii.gz -ref $fol/thickness_reorient.nii.gz -applyxfm -usesqform -out $fol/$LOC-to-thickness.nii.gz

    # After registration, be sure to threshold the mask and binarize (may be unnecessary)
    fslmaths $fol/$LOC-to-thickness.nii.gz -thr 0.5 -bin $fol/$LOC-to-thickness.nii.gz

    # Get mean and standard deviation of cortical thickness in ROI
    meanstd=$(fslstats $fol/thickness_reorient.nii.gz -k $fol/$LOC-to-thickness.nii.gz -M -S)

    # Print the result to a subject-specific text file
    echo $meanstd >> $fol/surf/${SUBJECT}_results.txt
  done
done

# # It is a good idea to view your ROI on the fsaverage surface to ensure that it is located where you expect it to be:
# freeview -v $fol/mri/brain_reorient.nii.gz $fol/thickness_reorient.nii.gz:colormap=heat:opacity=0.8 $fol/visual-to-thickness.nii.gz:colormap=pet
