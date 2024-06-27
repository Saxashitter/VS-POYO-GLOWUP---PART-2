from wand import image
import os
import gc

def searchFolder(path):
	for (dirPath, dirNames, fileNames) in os.walk(path):
		for i in fileNames:
			if i.endswith(".png") and not os.path.isfile(dirPath+"/"+i.replace(".png", ".dds")):
				with image.Image(filename=dirPath+"/"+i) as img:
					img.compression = "dxt1"
					img.save(filename=dirPath+"/"+(i.replace(".png", ".dds")))
					print("Converted "+i)

				gc.collect()

		for i in dirNames:
			searchFolder(dirPath+i)

searchFolder("assets/images/characters")