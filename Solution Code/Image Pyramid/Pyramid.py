






import sys
import cv2 as cv
import numpy as np
#  Global Variables

MAX_KERNEL_LENGTH = 15
src = None
dst = None

def main(argv):
    ddepth = cv.CV_16S
    # Load the source image
    imageName = argv[0] if len(argv) > 0 else "../data/lena.jpg"
    global src
    src = cv.imread(imageName, 1)
    if src is None:
        print ('Error opening image')
        print ('Usage: smoothing.py [image_name -- default ../data/lena.jpg] \n')
        return -1

    global dst
    dst = np.copy(src)
    laps = np.copy(dst)
    for i in range(1, MAX_KERNEL_LENGTH, 2):
    	dst = cv.GaussianBlur(src, (i, i), 0)
    	lapdst = cv.Laplacian(dst, ddepth, 3)
    	s = './output/modified' + str(i/2) + '.bmp'
    	laps = './output/laplace' + str(i/2) + '.bmp'
    	cv.imwrite(s, dst)
    	cv.imwrite(laps, lapdst)
    
    return 0

if __name__ == "__main__":
    main(sys.argv[1:])