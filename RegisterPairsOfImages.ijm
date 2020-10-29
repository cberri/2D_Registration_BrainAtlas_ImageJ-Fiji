/*
 * Project: Template for Macro
 * 
 * Developed by Dr. Carlo A. Beretta 
 * Department for Anatomy and Cell Biology @ Heidelberg University
 * Email: carlo.beretta@uni-heidelberg.de
 * Tel.: +49 (0) 6221 54 8682
 * Tel.: +49 (0) 6221 54 51435
 * 
 * Description: In this project I included what I think is frequently usefull
 * for deveopping a macro. Any suggestion is very much usefull!
 * 
 * Created: 2018-10-12
 * Last update: 2019-11-15
 */

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// # 0 
// Contact Information
function ContactInformation() {

	print("##############################################################");	
 	print("Developed by Dr. Carlo A. Beretta"); 
 	print("Department for Anatomy and Cell Biology @ Heidelberg University");
 	print("Email: carlo.beretta@uni-heidelberg.de");
 	print("Tel.: +49 (0) 6221 54 8682");
 	print("Tel.: +49 (0) 6221 54 51435");
 	print("##############################################################\n");	
 	
}

// # 1 General setting
function Setting() {
	
	// Set the Measurments parameters
	run("Set Measurements...", "area mean standard min perimeter integrated limit redirect=None decimal=8");

	// Set binary background to 0 
	run("Options...", "iterations=1 count=1 black");

	// General color setting
	run("Colors...", "foreground=white background=black selection=yellow");

}

// # 2
function CloseAllWindows() {
	
	while(nImages > 0) {
		
		selectImage(nImages);
		close();
		
	}
}

// # 3
// Choose the input directories (Raw)
function InputDirectory() {

	dirIn = getDirectory("Please choose the RAW input root directory");

	// The macro check that you choose a directory and output the input path
	if (lengthOf(dirIn) == 0) {
		print("Exit!");
		exit();
			
	} else {

		// Output the path
		text = "Input row path:\t" + dirIn;
		print(text);
		return dirIn;
			
	}
	
}

//  # 4
// Output directory
function OutputDirectory(outputPath, year, month, dayOfMonth, second) {

	// Use the dirIn path to create the output path directory
	dirOutRoot = outputPath;

	// Change the path 
	lastSeparator = lastIndexOf(dirOutRoot, File.separator);
	dirOutRoot = substring(dirOutRoot, 0, lastSeparator);
	
	// Split the string by file separtor
	splitString = split(dirOutRoot, File.separator); 
	for(i=0; i<splitString.length; i++) {

		lastString = splitString[i];
		
	} 

	// Remove the end part of the string
	indexLastSeparator = lastIndexOf(dirOutRoot, lastString);
	dirOutRoot = substring(dirOutRoot, 0, indexLastSeparator);

	// Use the new string as a path to create the OUTPUT directory.
	dirOutRoot = dirOutRoot + "MacroResults_" + year + "-" + month + "-" + dayOfMonth + "_0" + second + File.separator;
	return dirOutRoot;
	
}

// # 5
// Save and close Log window
function CloseLogWindow(dirOutRoot) {
	
	if (isOpen("Log")) {
		
		selectWindow("Log");
		saveAs("Text", dirOutRoot + "Log.txt"); 
		run("Close");
		
	} else {

		print("Log window has not been found");
		
	}
	
}

// # 6
// Close Memory window
function CloseMemoryWindow() {
	
	if (isOpen("Memory")) {
		
		selectWindow("Memory");
		run("Close", "Memory");
		
	} else {
		
		print("Memory window has not been found!");
	
	}
	
}

// # 7
// Print summary function (Modified from ImageJ/Fiji Macro Documentation)
function printSummary(textSummary) {

	titleSummaryWindow = "Summary Window";
	titleSummaryOutput = "["+titleSummaryWindow+"]";
	outputSummaryText = titleSummaryOutput;
	
	if (!isOpen(titleSummaryWindow)) {

		// Create the results window
		run("Text Window...", "name="+titleSummaryOutput+" width=90 height=20 menu");
		
		// Print the header and output the first line of text
		print(outputSummaryText, "% Input File Name\t" + "% Area\t" + "\n");
		print(outputSummaryText, textSummary +"\n");
	
	} else {

		print(outputSummaryText, textSummary +"\n");
		
	}

}

// # 8
function SaveStatisticWindow(dirOutRoot) {

	// Save the SummaryWindow and close it
	selectWindow("Summary Window");
	saveAs("Text",  dirOutRoot + "SummaryIntensityMeasurements"+ ".xls");
	run("Close");
	
}

// # 9
// Check the memory avaible to ImageJ/Fiji
function MaxMemory() {

	// Max memory avaible
	memory = IJ.maxMemory();

	if (memory > 4000000000) {
		print("Max Memory (RAM) Avaible for Fiji/ImageJ is:", memory); 
		print("Please change the amount of memory avaible to Fiji/ImageJ to 70% of your total memory");
		print("Edit >> Options >> Memory % Threads...");
		run("Memory & Threads...");
		exit();
		
	}

}

// # 10
// Copy the atlas file in the Fiji.app directory
function CopyFile2FijiInstallation() {

	path2Macro = getDir("downloads");
	path2Image = path2Macro + "atlas" + File.separator;
	fileListImg = getFileList(path2Image);
	path2Fiji = getDirectory("imagej");

	if (File.exists(path2Image) && fileListImg.length != 0) {

		// Copy the image to the Fiji installation path
		File.copy(path2Image + "Coronal_AtlasSeq.tif", path2Fiji + "Coronal_AtlasSeq.tif");
	
		// Delete the temp file from img folder after copying it in the Fiji installation directroy
		File.delete(path2Image + "Coronal_AtlasSeq.tif");
		File.delete(path2Image);
		
		// Clear the Log
		print("\\Clear");
	
	} 

	return path2Fiji;
	
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%% Macro %%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Register 2D brain slices with atlas map
macro RegisterPairsOfImages {

	
    // TBD: Problem with the input instead of having 3 channels has 3 slices!
    channels = 3;

	// Start functions
	// 1.
	path2Fiji = CopyFile2FijiInstallation();
	Setting();
	
	// 2.
	CloseAllWindows();

	// Display memory usage
	doCommand("Monitor Memory...");

	// Get the starting time
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);

	// 4. Function choose the input root directory
	dirIn = InputDirectory();
	outputPath = dirIn;

	// Get the list of subfolder in the input directory
	folderList = getFileList(dirIn);

	// 5. Create the output root directory in the input path
	dirOutRoot = OutputDirectory(outputPath, year, month, dayOfMonth, second);

	if (!File.exists(dirOutRoot)) {	
		File.makeDirectory(dirOutRoot);
		text = "Output path:\t" + dirOutRoot;
		print(text);
	
	} 

	// Do not display the images
	setBatchMode(true);

	// Loop through the folders in the input directory
	for (i=0; i<folderList.length; i++) {
				
		// Get the list of images in the subsubfolder
		fileList = getFileList(dirIn + folderList[i]);

		// Check if the output directory already exist
		if (File.exists(dirOutRoot)) {
						
			// Create the image and analysis directory inside each subdirectory
			dirOut = dirOutRoot + folderList[i] + File.separator;
			File.makeDirectory(dirOut);
	
		}

		// Open the file located in the input directory
		for (k=0; k<fileList.length; k++) {

			// Check the input file format .nd2
			if (endsWith(fileList[k], '.tiff') || endsWith(fileList[k], '.tif')) {

				// Update the user
				print("Processing file:\t\t" +(k+1));

				// Open the input raw image
				open(dirIn + folderList[i] + fileList[k]);
				inputTitle = getTitle();
				//getDimensions(width, height, channels, slices, frames);
				x = 0;
				y = 0;
				setLocation(0, 0,  getHeight()/10,   getWidth()/10);
				width = getWidth();
				height = getHeight();
				getLocationAndSize(x, y, width, height);
				print("Opening:\t" + inputTitle);

				// Remove file extension .somthing
            	dotIndex = indexOf(inputTitle, ".");
            	title = substring(inputTitle, 0, dotIndex);

            	// User can open the atlas stack and look for the right section
            	setBatchMode("show");
            	open(path2Fiji + "Coronal_AtlasSeq.tif");
            	setBatchMode("show");
            	atlastStack = getTitle();
            	setLocation(width,  0);
            	waitForUser("Please trasform the raw image and choose\nthe right section from the atlas!");
            	setBatchMode("hide");
            	selectedSlice = getSliceNumber();
            	run("Make Substack...", "delete slices=[" + selectedSlice + "]");
            	atlasImage = getTitle();
            	selectImage(atlastStack);
            	close(atlastStack);
            	
				// Pre-steps
				selectImage(inputTitle);
				run("Make Composite", "display=Composite");
				run("RGB Color");
				rawImage = getTitle();

				// Registration (to check, Big Warp doesn't support Imagej 1 macro language)
				selectImage(atlasImage);
				setBatchMode("show");
				selectImage(rawImage);
				setBatchMode("show");	
				run("bUnwarpJ");

				// Post registration
				selectWindow("Registered Target Image");
				regTarImg = getTitle();
				close(regTarImg);
				selectWindow("Registered Source Image");
				regSourceImg = getTitle();
				run("Make Substack...", "delete slices=1");
				run("Invert");
				regAtlasImg = getTitle();

				// Close all the windows are not used
				selectImage(regSourceImg);
				close(regSourceImg);
				selectImage(atlasImage);
            	close(atlasImage);
            	selectImage(rawImage);
            	close(rawImage);

            	// Fuse the registered images
            	selectImage(regAtlasImg);
            	setAutoThreshold("Otsu dark");
            	run("Convert to Mask");
            	run("16-bit");
            	selectImage(inputTitle);
            	run("Split Channels");

				if (channels == 3) {

					run("Merge Channels...", "c1=[C1-" + inputTitle + "] c2=[C2-" + inputTitle + "] c3=[C3-" + inputTitle + "] c4=[" + regAtlasImg + "] create");
					mergeTitle = getTitle();
					
				} else if (channels == 2) {

					run("Merge Channels...", "c2=[C2-" + inputTitle + "] c3=[C3-" + inputTitle + "] c4=[" + regAtlasImg + "] create");
					mergeTitle = getTitle();
				}
            	
				// Save the overaly
				saveAs("Tiff", dirOut + title + "Atlas_Figure_" + (selectedSlice +1));
				mergeTitle = getTitle();
				close(mergeTitle);
            		
			
			} else {

				// Update the user
				print("Skypped: Input file format not supported: " + fileList[k]);

			}

		}

		// Update the user 
		text = "\nNumber of file processed:\t\t" + fileList.length;
		print(text);

	}

	
	text = "\n%%% Congratulation your file have been successfully processed %%%";
	print(text);
	
	// End functions
	//SaveStatisticWindow(dirOutRoot);
	CloseLogWindow(dirOutRoot);
	CloseMemoryWindow();
	
	// Display the images
	setBatchMode(false);
	showStatus("Completed");
	
}