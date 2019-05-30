# How to setup Random Dialogue

Due to current limitations in the game and mod launcher, we can not redirect directly to other files inside an RCF archive.  
This means we are required to load the RSD files from a separate source. This was the cause of the 50MB file size of a previous version, where we added every conversation dialogue RSD in order for the old character randomisation method.  
To do a full randomised dialogue in this way, it'd increase the mod size by about 137MB. We've instead done this another way to keep the file size smaller.  

## Step 1
Download the RandomiserDialogue.zip from the github release, and save it to any location.
## Step 2
Extract the RandomiserDialogue.zip to the same Mods folder you placed the Randomiser.lmlm file.  
![Step 2](Screenshots/Dialogue/Step2a.png)
## Step 3
Next, if you do not already have the RFC Explorer, download [Lucas RCF Explorer](https://donutteam.com/downloads/RCFExplorer/).  
This is a tool written by the same guy who wrote the mod launcher, in order to browse and extract from RCF archives.
## Step 4
Once downloaded (if needed), open the executable, and then open the file named "dialog.rcf" in the root of your SHAR install:  
![Step 4](Screenshots/Dialogue/Step4a.png)  
![Step 4](Screenshots/Dialogue/Step4b.png)  
![Step 4](Screenshots/Dialogue/Step4c.png)
## Step 5
Right click "dialog.rcf" in the top left, then choose "Extract Contents...". Extract to the "RandomiserDialogue\CustomFiles\RandomDialogue" folder inside the mods folder:  
*The current version of the RCF explorer does not have a progress bar at the time of writing this. To know that all files are extracted, wait for a folder called "zombie4" to appear in the folder*  
![Step 5](Screenshots/Dialogue/Step5a.png)  
![Step 5](Screenshots/Dialogue/Step5b.png)  
![Step 5](Screenshots/Dialogue/Step5c.png) 
## Step 6
Setup complete. If the mod launcher is open, press Reload in the top right.  
Now you can enable the "Random Dialogue" setting in mod settings.  
![Step 6](Screenshots/Dialogue/Step6a.png)  
![Step 6](Screenshots/Dialogue/Step6b.png)  
![Step 6](Screenshots/Dialogue/Step6c.png)  
![Step 6](Screenshots/Dialogue/Step6d.png)  
![Step 6](Screenshots/Dialogue/Step6e.png)  

*Because of how this loads, you can actually add custom dialogue lines if you know how to setup dialogue RSD files, simply by putting them into that folder.*
