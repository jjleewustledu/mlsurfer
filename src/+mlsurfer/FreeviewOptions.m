classdef FreeviewOptions < mlsurfer.SurferOptions 
	%% FREEVIEWOPTIONS  
    %  Usage: freeview [OPTION <ARGUMENT:SUB-OPTION>]...
    %  Volume and surface viewer and editor for freesurfer.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
        volume  % <FILE>...
                %        Load one or multiple volume files. Available sub-options are: 
                %        
                %        ':colormap=name' Set colormap for display. Valid names are
                %        grayscale/lut/heat/jet/gecolor/nih. 
                %        
                %        ':grayscale=min,max' Set grayscale window values.
                %        
                %        ':heatscale=min,mid,max' Set heat scale values.
                %        
                %        ':heatscaleoptions=option1[,option2]' Set heat scale options. Options
                %        can be 'truncate','invert', or both.
                %        
                %        ':colorscale=min,max' Set generic colorscale values for
                %        jet/gecolor/nih.
                %        
                %        ':lut=name' Set lookup table to the given name. Name can be the name of
                %        a stock color table or the filename of a color table file.
                %        
                %        ':vector=flag' Display 3 frame volume as vectors. flag can be 'yes',
                %        'true' or '1'.
                %        
                %        ':tensor=flag' Display 9 frame volume as tensors. flag can be 'yes',
                %        'true' or '1'.
                %        
                %        ':render=flag' When displaying as vectors or tensors, render the glyph
                %        in the given form. For vector, flag can be 'line' as simple line or
                %        'bar' as 3D bar (might be slow). For tensor, flag can be 'boxoid' or
                %        'ellipsoid' (slow!).
                %        
                %        ':inversion=flag' When displaying as vectors or tensors, invert the
                %        given component of the vectors. Valid flags are 'x', 'y' and 'z'.
                %        
                %        ':outline=flag' Display labels as outline only. flag can be '1', 'yes'
                %        or 'true'.
                %        
                %        ':reg=reg_filename' Set registration file for the volume. reg_filename
                %        can contain relative path to the volume file.
                %        
                %        ':sample=method' Set the sample method when resampling is necessary.
                %        method can be 'nearest' (default) or 'trilinear'.
                %        
                %        ':opacity=value' Set the opacity of the volume layer. value ranges from
                %        0 to 1.
                %        
                %        ':mask=volume_name' Use the given volume to as mask for display. The
                %        maks volume must be loaded first.
                %        
                %        ':isosurface=low_threshold,high_threshold' Set 3D display as
                %        isosurface. High_threshold is optional. If no threshold or simply 'on'
                %        is given, threshold will be either automatically determined or
                %        retrieved from the save previously settings.
                %        
                %        ':surface_region=file' Load isosurface region(s) from the given file.
                %        isosurface display will automatically be turned on.
                %        
                %        ':name=display_name' Set the display name of the volume.
                %        
                %        ':lock=lock_status' Lock the volume layer so it will not be moved in
                %        the layer stack. Status can be '1' or 'true'.
                %        
                %        ':visible=visibility' Set the initial visibility of the volume.
                %        Visibility can be '1' or '0' or 'true' or 'false'.
                %        
                %        ':structure=name_or_value' Move the slice in the main viewport to where
                %        it has the most of the given structure.
                %        
                %        Example:
                %        freeview -v T1.mgz:colormap=heatscale:heatscale=10,100,200

        resample    % Resample oblique data to standard RAS.
        conform     % Conform the volume to the first loaded volume.
        trilinear   % Use trilinear as the default resample method.
        cubic       % Use cubic as the default resample method.
        colormap    % <TYPE>
                    % Use the give colormap type as the default colormap for all the volumes
                    % to be loaded.
        dti         % <VECTOR> <FA>...
                    % Load one or more dti volumes. Need two files for each dti volume. First
                    % one is vector file. Second one is FA (brightness) file.

        track_volume % <FILE>...
                     % Load one or more track volumes.
                
        surface % <FILE>...
                % Load one or multiple surface files. Available sub-options are:
                %        
                %        ':curvature=curvature_filename' Load curvature data from the given
                %        curvature file. By default .curv file will be loaded if available.
                %        
                %        ':overlay=overlay_filename' Load overlay data from file.
                %        
                %        ':overlay_reg=overlay_registration_filename' Apply registration when
                %        loading overlay data.
                %        
                %        ':overlay_method=method_name' Set overlay method. Valid names are
                %        'linear', 'linearopaque' and 'piecewise'.
                %        
                %        ':overlay_threshold=low,(mid,)high' Set overlay threshold values,
                %        separated by comma. When overlay method is linear or linearopaque, only
                %        2 numbers (low and high) are needed. When method is piecewise, 3
                %        numbers are needed.
                %        
                %        ':correlation=correlation_filename' Load correlation data from file.
                %        Correlation data is treated as a special kind of overlay data.
                %        
                %        ':color=colorname' Set the base color of the surface. Color can be a
                %        color name such as 'red' or 3 values as RGB components of the color,
                %        e.g., '255,0,0'.
                %        
                %        ':edgecolor=colorname' Set the color of the slice intersection outline
                %        on the surface. 
                %        
                %        ':edgethickness=thickness' Set the thickness of the slice intersection
                %        outline on the surface. set 0 to hide it.
                %        
                %        ':annot=filenames' Set annotation files to load.
                %        
                %        ':name=display_name' Set the display name of the surface.
                %        
                %        ':offset=x,y,z' Set the position offset of the surface. Useful for
                %        connectivity display.
                %        
                %        ':visible=visibility' Set the initial visibility of the surface.
                %        Visibility can be '1' or '0' or 'true' or 'false'.
                %        
                %        ':vector=filename' Load a vector file for display.
                %        
                %        ':target_surf=filename' Load a target surface file for vectors to
                %        project on for 2D display.
                %        
                %        ':label=filename' Load a surface label file.
                %        
                %        ':label_outline=flag' Show surface labels as outline. flag can be
                %        'true', 'yes' or '1'.
                %        
                %        ':spline=filename' Load a spline file for display.
                %        
                %        ':vertex=flag' Show surface vertices on both 2D and 3D views. flag can
                %        be 'true', 'on' or '1'.
                %        
                %        ':vertexcolor=colorname' Set color of the vertices. Color can be a
                %        color name such as 'red' or 3 values as RGB components of the color,
                %        e.g., '255,0,0'.
                %        
                %        ':all=flag' Indicate to load all available surfaces. flag can be
                %        'true', 'yes' or '1'.
        label   % <FILE>...
                % Load one or multiple label(ROI) files. Available sub-options are:
                %        
                %        ':ref=ref_volume' Enter the name of the reference volume for this label
                %        file. The volume is one of the volumes given by -v option. 
                %        
                %        ':color=name' Set color of the label. Name can be a generic color name
                %        such as 'red' or 'lightgreen', or three integer values as RGB values
                %        ranging from 0 to 255. For example '255,0,0' is the same as 'red'.

        way_points  % <FILE>...
                    %        Load one or multiple way points files. Available sub-options are:
                    %        
                    %        ':color=name' Set color of the way points. Name can be a generic color
                    %        name such as 'red' or 'lightgreen', or three integer values as RGB
                    %        values ranging from 0 to 255. For example '255,0,0' is the same as
                    %        'red'.
                    %        
                    %        ':splinecolor=name' Set color of the spline.
                    %        
                    %        ':radius=value' Set radius of the way points.
                    %        
                    %        ':splineradius=value' Set radius of the spline tube.
                    %        
                    %        ':name=display_name' Set the display name of the way points.
                    %        
                    %        ':visible=visibility' Set the initial visibility of the way points.
                    %        Visibility can be '1' or '0' or 'true' or 'false'.

        control_points  % <FILE>...
                        %        Load one or multiple control points files. Available sub-options are:
                        %        
                        %        ':color=name' Set color of the control points. Name can be a generic
                        %        color name such as 'red' or 'lightgreen', or three integer values as
                        %        RGB values ranging from 0 to 255. For example '255,0,0' is the same as
                        %        'red'.
                        %        
                        %        ':radius=value' Set radius of the control points.
                        %        
                        %        ':name=display_name' Set the display name of the control points.
                        %        
                        %        ':visible=visibility' Set the initial visibility of the control points.
                        %        Visibility can be '1' or '0' or 'true' or 'false'.

        p_labels % <FILES>...
                 % Load multiple p-label volume files.

        p_prefix % <PREFIX>...
                 % Set the file name prefix for p-label volume. program will use this to
                 % figure out label name from file name.

        p_lut    % <NAME>...
                 %        Set the look up table name to use for p-label display. name can be the
                 %        name of a stock lookup table or the file name of a lookup table file.
                 %        default is the default freesurfer look up table.

        connectome_matrix % <CMAT_FILE> <PARCELLATION_FILE>
                          % Load connectome matrix data files. Requires a cmat file and a
                          % parcellation volume file. Available sub-options are:
                          %
                          % 'lut=color_table' Enter the name or file name of the color table to be
                          % used. Default is the FreeSurfer default LUT.

        track      % <FILE>...
                   % Load one or more track files.
        screenshot % <FILE>
                   % Take a screen shot of the main viewport and then quit the program.
        viewport   % <NAME>
                   % Set the main viewport as given. Accepted names are 'sagittal' or 'x',
                   % 'coronal' or 'y', 'axial' or 'z' and '3d'.
        viewsize   % <width> <height>
                   % Set the size of the main viewport. The size of the whole window will be
                   % changed accordingly.
                   
        zoom    % <FACTOR>
                % Set zoom factor of the main viewport.
        camera  % <OPERATION1> <FACTOR1> <OPERATION2> <FACTOR2>...
                %        Set a series of camera operations for the 3D view. Valid operations
                %        are:
                %        
                %        'Azimuth' Rotate the camera about the view up vector centered at the
                %        focal point. The result is a horizontal rotation of the camera.
                %        
                %        'Dolly' Divide the camera's distance from the focal point by the given
                %        dolly value. Use a value greater than one to dolly-in toward the focal
                %        point, and use a value less than one to dolly-out away from the focal
                %        point.
                %        
                %        'Elevation' Rotate the camera about the cross product of the negative
                %        of the direction of projection and the view up vector, using the focal
                %        point as the center of rotation. The result is a vertical rotation of
                %        the scene.
                %        
                %        'Roll' Rotate the camera about the direction of projection. This will
                %        spin the camera about its axis.
                %        
                %        'Zoom' Same as 'Dolly'.
                %        
                %        Note that the order matters!
                %        
                %        For example: '-cam dolly 1.5 azimuth 30' will zoom in the camera by 1.5
                %        times and then rotate it along the view up vector by 30 degrees.
        ras     % <X> <Y> <Z>
                % Set cursor location at the given RAS coordinate.
        slice   % <X> <Y> <Z>
                % Set cursor location at the given slice numbers of the first loaded
                % volume.
                
        colorscale % Show color scale bar on the main view.
        command    % <FILE>
                   % Load freeview commands from a text file.
        hide       % <LAYER_TYPE>
                   % Hide the current layer. This is useful for loading comands by -cmd
                   % option. Valid LAYER_TYPEs are volume, surface, label, etc.
        unload     % <LAYER_TYPE>
                   % Unload/Close the current layer. Useful for loading comands by -cmd
                   % option. Valid LAYER_TYPEs are volume, surface, label, etc.
       
        reverse_order % Load layers in reversed order.
        quit          % Quit freeview. Useful for scripting or loading comands by -cmd option.		 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

