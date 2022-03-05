import picamera
import numpy as np
from picamera.array import PiRGBAnalysis
from picamera.color import Color
import time
import math

dims = (160,160)
targetCenter = (80,80)
targetPixelsPerMm = 2
targetDistance = 10


# Standard biathlon target apaprent diameters in milliradians
standing_mrad = 115./50.
prone_mrad = 45./50.

scaledProne = targetDistance * prone_mrad/2.0
scaledStanding = targetDistance * standing_mrad/2.0


# Detect a hit when at least one pixel's red channel changes by more
# than a threshold amount from one frame to the next
# Then, wait one more frame (helps deal with rolling shutter),
# find all of the pixels which have changed, calculate the centroid of that
# area, and report according to how far off-center it is

class TargetAnalyzer(PiRGBAnalysis):
    def __init__(self, camera):
        super(TargetAnalyzer, self).__init__(camera)
        self.lastRed = 255*np.ones(dims)
        self.triggered = False
        self.threshold = 32
        self.lastTrigTime = 0
        self.lockout = 0.5

    def analyze(self, a):
        diffs = a[:,:,0].astype('i')-self.lastRed.astype('i')
        inds = np.nonzero(diffs>self.threshold) 
        if (self.triggered>0):
            self.triggered=self.triggered+1
            msd = np.min(diffs)
            if (self.triggered==2):
                x =  (np.mean(inds[0])-center[0])/targetPixelsPerMm
                y = -(np.mean(inds[1])-center[1])/targetPixelsPerMm
                radius = math.sqrt(x*x+y*y)
                # beep once for a standing hit, twice for a prone
                if (radius < scaledProne):
                    print('\a')
                if (radius < scaledStanding):
                    print('\a')
                result = "$.1f: (%.1f,%.1f)"%(radius,x,y)
                print(result)
            else:
                if (msd<-self.threshold):
                    self.triggered=0
            self.lastRed=a[:,:,0].copy()
        else:
            currTime = time.time()
            if (len(inds[0])>0 and (currTime-self.lastTrigTime)>self.lockout):
                self.triggered=1
                self.count = self.count+1
                self.lastTrigTime=currTime
            else:
                self.lastRed=a[:,:,0].copy()

startTime=time.time()        
with open("data","w") as ofile:
    with picamera.PiCamera(resolution='%dx%d'%(dims[1],dims[0]), framerate=60) as camera:
    # Fix the camera's white-balance gains
        camera.awb_mode = 'off'
        camera.awb_gains = (1.4, 1.5)
        with TargetAnalyzer(camera) as analyzer:
            camera.start_recording(analyzer, 'rgb')
            try:
                while True:
                    camera.wait_recording(1)
            finally:
                camera.stop_recording()
