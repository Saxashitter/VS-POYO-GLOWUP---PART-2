import os
from PIL import Image
import gc

def searchFolder(path):
	for (dirPath, dirNames, fileNames) in os.walk(path):
		for i in fileNames:
			if i.endswith(".png"):
				image = Image.open(dirPath+"/"+i)
				x,y,w,h = image.getbbox()
				image.crop((0,0,w+x,y+h)).save(dirPath+"/"+i)
				print(image.getbbox())
				gc.collect()

		for i in dirNames:
			searchFolder(dirPath+i)

searchFolder("assets/images")