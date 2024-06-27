import os
from PIL import Image
import gc

def searchFolder(path):
	for (dirPath, dirNames, fileNames) in os.walk(path):
		for i in fileNames:
			if i.endswith(".png") and not i.endswith("-dsb2.png") and not os.path.isfile(dirPath+"/"+i.replace(".png", "-dsb2.png")):
				image = Image.open(dirPath+"/"+i)
				image.resize((int(image.width/2), int(image.height/2))).save(dirPath+"/"+i.replace(".png", "-dsb2.png"))
				print("Downsized "+i)
				gc.collect()

		for i in dirNames:
			searchFolder(dirPath+i)

searchFolder("assets/images")