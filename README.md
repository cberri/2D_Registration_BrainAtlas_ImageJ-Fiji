## 2D Registration BrainAtlas ImageJ/Fiji
This is part of an on going project of Prof Rohini Kuner lab (Heidelberg University, Germany)



#### Short description

This tool has been developed to register 2D fluorescence image located in an input source directory containing subdirectories of images with brain atlas images

Only supports 2 channels and 3 channels tiff raw images



#### Main steps:

1. Clone the GitHub repository in your favorite local directory
2. Copy the *BrainAtlas* folder in your local *Download* directory
3. Open ImageJ/Fiji
4. Drag and drop the .ijm file on the main ImageJ/Fiji window 
5. The script editor will open and you can press *run* to execute the macro 

**Important:** at the first run the BrainAtlas folder will be copied in your ImageJ/Fiji installation directory and delete it from the Download directory.

	6. Choose an Input directory that contains subdirectories with tiff raw images to register. The macro will guide the user through the registration steps.
 	7. The results are saved in a new folder created in the input path



For the registration we use the **bUnwarpJ ImageJ/Fiji plugin**. Please refer to the bUnwarpJ plugin documentation to learn how it works.

https://imagej.net/BUnwarpJ



Please do not hesitate to contact me in case of issues or any suggestion on how to make the tool more flexible and suitable for your raw data

