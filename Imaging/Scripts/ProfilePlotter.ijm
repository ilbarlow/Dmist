run ("Clear Results");
//Uses preselection to plot the profile and export as txt file
for (j=1;j<=3; j++){
	Stack.setChannel(j);
	getSelectionCoordinates(x, y);
	run ("Plot Profile");
	Plot.getValues(x,y);
	for (i=0; i<y.length; i++){
		setResult("y", i, x[i]);
		setResult (j, i, y[i]);
		updateResults();
	close("Plot of Composite");
	}
}
path = getDirectory("Choose a Directory") + "Channelprofiles.xls";
saveAs ("measurements", path)

run("Add Selection...");
run("RGB Color");
saveAs("Tiff", File.getParent(path) + "/"+ "ROI.tif");
close();
run("Close");