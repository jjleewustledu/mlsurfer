% +MLSURFER
%
% Files
%   AbstractColorLUT                  - 
%   ADCSegstatsBuilder                - 
%   affine                            - Using 2D or 3D affine matrix to rotate, translate, scale, reflect and
%   affine3d                          - Using 3D affine matrix to rotate, translate, scale, reflect and
%   AparcA2009sColorLUT               - 
%   Aparcstats2tableOptions           - accumulates options for aparcstats2table which:
%   BBRegisterOptions                 - defines options for bbregister which performs within-subject, cross-modal registration using a
%   bipolar                           - returns an M-by-3 matrix containing a blue-red colormap, in
%   bresenham_line3d                  - Generate X Y Z coordinates of a 3D Bresenham's line between
%   collapse_nii_scan                 - Collapse multiple single-scan NIFTI files into a multiple-scan NIFTI file
%   ColorLUTInterface                 - 
%   DatasetMap                        - has a containers.Map and makes accessible:  isKey, keys, length, size, values
%   expand_nii_scan                   - Expand a multiple-scan NIFTI file into multiple single-scan NIFTI files
%   extra_nii_hdr                     - Decode extra NIFTI header information into hdr.extra
%   flip_lr                           - When you load any ANALYZE or NIfTI file with 'load_nii.m', and view
%   FreeviewOptions                   - 
%   FslregisterOptions                - 
%   get_nii_frame                     - Return time frame of a NIFTI dataset. Support both *.nii and 
%   LabelAnnotationBuilder            - ... 
%   load_nii                          - Load NIFTI or ANALYZE dataset. Support both *.nii and *.hdr/*.img
%   load_nii_ext                      - Load NIFTI header extension after its header is loaded using load_nii_hdr.
%   load_nii_hdr                      - Load NIFTI dataset header. Support both *.nii and *.hdr/*.img file
%   load_nii_img                      - internal function
%   load_untouch0_nii_hdr             - internal function
%   load_untouch_header_only          - Load NIfTI / Analyze header without applying any appropriate affine
%   load_untouch_nii                  - Load NIFTI or ANALYZE dataset, but not applying any appropriate affine
%   load_untouch_nii_hdr              - internal function
%   load_untouch_nii_img              - internal function
%   make_ana                          - Make ANALYZE 7.5 data structure specified by a 3D matrix. For RGB24 
%   make_nii                          - Make NIfTI structure specified by an N-D matrix. Usually, N is 3 for 
%   mat_into_hdr                      - The old versions of SPM (any version before SPM5) store
%   MGH                               - has-an mlfourd.NIfTI by composition
%   Mri_label2volOptions              - 
%   Mri_segstatsOptions               - 
%   Mri_surf2surfOptions              - 
%   Mri_vol2surfOptions               - 
%   Mri_vol2volOptions                - 
%   Parcellations                     - slices, dices and presents data from Freesurfer in formats useful for Matlab
%   ParcellationSegments              - 
%   PerfusionSegstatsBuilder          - 
%   PETControlsSegstatsBuilder        - ... 
%   PETSegstatsBuilder                - 
%   RegisteredNIfTI                   - 
%   reslice_nii                       - The basic application of the 'reslice_nii.m' program is to perform
%   rri_file_menu                     - Imbed a file menu to any figure. If file menu exist, it will append
%   rri_orient                        - Convert image of different orientations to standard Analyze orientation
%   rri_orient_ui                     - Return orientation of the current image:
%   rri_xhair                         - rri_xhair: create a pair of full_cross_hair at point [x y] in
%   rri_zoom_menu                     - Imbed a zoom menu to any figure.
%   save_nii                          - Save NIFTI dataset. Support both *.nii and *.hdr/*.img file extension.
%   save_nii_ext                      - Save NIFTI header extension.
%   save_nii_hdr                      - Save NIFTI dataset header. Support both *.nii and *.hdr/*.img file
%   save_untouch0_nii_hdr             - internal function
%   save_untouch_nii                  - Save NIFTI or ANALYZE dataset that is loaded by "load_untouch_nii.m".
%   save_untouch_nii_hdr              - internal function
%   save_untouch_slice                - Save back to the back to the original image a portion of slices that
%   SegstatsBuilder                   - 
%   SubjectId                         - ...
%   SurferBuilder                     - is the interface for freesurfer workflows.
%   SurferBuilderPrototype            - 
%   SurferData                        - contains and manages cortical thickness and surface data 
%   SurferDicomConverter              - is a concrete strategy for interfaces DicomConverter, AbstractConverter;
%   SurferDirector                    - is the highest level of abstraction for a builder pattern for Freesurfer
%   SurferDirectorComponent           - 
%   SurferDirectorDecorator           - 
%   SurferOptions                     - 
%   SurferRois                        - generates freesurfer data based on user-defined ROIs
%   SurferVisitor                     - 
%   TkmeditOptions                    - 
%   Tkregister2Options                - 
%   TksurferOptions                   - 
%   unxform_nii                       - Undo the flipping and rotations performed by xform_nii; spit back only
%   VascularTerritories               - VASCULARTERRITORIES
%   verify_nii_ext                    - Verify NIFTI header extension to make sure that each extension section
%   view_nii                          - VIEW_NII: Create or update a 3-View (Front, Top, Side) of the 
%   view_nii_menu                     - Imbed Zoom, Interp, and Info menu to view_nii window.
%   VolumeRoiCorticalThicknessBuilder - 
%   xform_nii                         - internal function
