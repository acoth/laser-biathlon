import picamera
import numpy as np
from picamera.array import PiRGBAnalysis
from picamera.color import Color
import time
from subprocess import Popen
import math

dims = (160,160)

class MyColorAnalyzer(PiRGBAnalysis):
    def __init__(self, camera):
        super(MyColorAnalyzer, self).__init__(camera)
        self.lastRed = 255*np.ones(dims)
        self.triggered = False
        self.count=0
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
                x = 80*np.mean(inds[0])/dims[0]-40
                y = 40-80*np.mean(inds[1])/dims[1]
                if (math.sqrt(x*x+y*y)<10):
                    print('\a')
                result = "%.1f,%.1f"%(x,y)
                print(result)
                #                Popen(['/usr/bin/espeak',result])
#                print("%d (%.3f): (%.2f,%.2f)"%(self.count,time.time()-startTime,np.mean(inds[0]),np.mean(inds[1])))
                
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
        with MyColorAnalyzer(camera) as analyzer:
            camera.start_recording(analyzer, 'rgb')
            try:
                while True:
                    camera.wait_recording(1)
            finally:
                camera.stop_recording()
