---
title: "Faster R-CNN Use Caffe Framework"
tags: ["Linux", "MachineLearning"]
date: "2017-08-31 10:00:10 +0800"
---

Install caffe framework and run Faster R-CNN demo on Ubuntu 16.04.  

### Test environment  

CPU: Intel(R) Core(TM) i3-4130 CPU @ 3.40GHz 4-Cores  
GPU: ASUSTeK GeForce GTX 1060 with 6GB Memory  
HD: WDC WD5000AAKX  
OS: Ubuntu 16.04  

![](/images/2017-08-31/GPU_Info.png)

### Test Flow  

* Install software requirement  
* Video pre-processing: get jpeg images from source video  
* Image Labeling  
* Use Faster R-CNN to genrate trained model  
* Run Faster R-CNN demo  

### Requirement  

Hardware:  
Good graphic card with large memory (6GB memory is okay, but it has problem in VGG traing.)  

Software:  

* Nvidia Driver  
* CUDA 8.0  
* Python Packages  
* OpenBLAS  
* Caffe and pycaffe  

### Install Software Requirements  

**Update Nvidia Driver**  
https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa  

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install nvidia-375   #You can use the latest one.  
# reboot system
``` 

Install commands: **[Install.txt](/resource/2017-08-31/FRCNN_InstallCommands.txt)**  

## Training data setup  

### Generate image samples from video  

```python
import cv2
print(cv2.__version__)
vidcap = cv2.VideoCapture('video_file.mp4')
success,image = vidcap.read()
count = 0
success = True
while success:
  success,image = vidcap.read()
  print 'Read a new frame: ', success
  cv2.imwrite("frame%d.jpg" % count, image)     # save frame as JPEG file
  count += 1
```

### Image label tool  

[https://github.com/tzutalin/labelImg](https://github.com/tzutalin/labelImg)  

### Training dataset setup  

* Put all image files in  
py-faster-rcnn/data/VOCdevkit2007/VOC2007/JPEGImages  

* Put all annotation files in  
py-faster-rcnn/data/VOCdevkit2007/VOC2007/Annotations  

* Generate test.txt, train.txt, trainval.txt, val.txt by these rules:  
trainval.txt: ½ of the whole dataset  
test.txt: ½ of the whole dataset  
train.txt: ½ of the trainval.txt 
val.txt: ½ of the trainval.txt  

In my case:  

* Annotation files: 241  
* JPEJImage files: 362  
* test.txt: 116 samples  
* train.txt: 62 samples  
* trainval.txt: 125 samples  
* val.txt: 62 samples  

```shell
py-faster-rcnn/data/VOCdevkit2007/VOC2007/
├── Annotations
│     └── *.xml
├── Annotations-back
├── ImageSets
│     └── Main
│       ├── test.txt
│       ├── train.txt
│       ├── trainval.txt
│       └── val.txt
└── JPEGImages
      └── *.jpg
```

Part of test.txt  

```
frame1230
frame1240
frame1260
frame1370
frame1380
frame1390
frame1400
frame1410
frame1420
frame1430
...
116 lines
```

Part of train.txt  

```
frame1210
frame1250
frame1280
frame1300
frame1320
frame1340
frame1360
frame2040
...
62 lines
```

Part of trainval.txt  

```
frame1200
frame1210
frame1220
frame1250
frame1270
frame1280
frame1290
frame1300
frame1310
...
125 lines
```  

Part of val.txt 

```
frame1200
frame1220
frame1270
frame1290
frame1310
frame1330
frame1350
frame2030
frame2050
...
63 lines
```

### ZF model configure  

My clases number is 6, including the background class:  

* Modify `num_classes` to 6  
* Modify `num_output` in the `cls_score` layer to 6  
* Modify `num_output` in the `bbox_pred` layer to 4 * 6  


```diff
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/faster_rcnn_test.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/faster_rcnn_test.pt
index b24aae4..fc1d677 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/faster_rcnn_test.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/faster_rcnn_test.pt
@@ -303,7 +303,7 @@ layer {
   bottom: "fc7"
   top: "cls_score"
   inner_product_param {
-    num_output: 21
+    num_output: 6
   }
 }
 layer {
@@ -312,7 +312,7 @@ layer {
   bottom: "fc7"
   top: "bbox_pred"
   inner_product_param {
-    num_output: 84
+    num_output: 24
   }
 }
 layer {
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_train.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_train.pt
index 3d98184..d7c7f26 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_train.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_train.pt
@@ -11,7 +11,7 @@ layer {
   python_param {
     module: 'roi_data_layer.layer'
     layer: 'RoIDataLayer'
-    param_str: "'num_classes': 21"
+    param_str: "'num_classes': 6"
   }
 }
 
@@ -244,7 +244,7 @@ layer {
   param { lr_mult: 1.0 }
   param { lr_mult: 2.0 }
   inner_product_param {
-    num_output: 21
+    num_output: 6
     weight_filler {
       type: "gaussian"
       std: 0.01
@@ -263,7 +263,7 @@ layer {
   param { lr_mult: 1.0 }
   param { lr_mult: 2.0 }
   inner_product_param {
-    num_output: 84
+    num_output: 24
     weight_filler {
       type: "gaussian"
       std: 0.001
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_train.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_train.pt
index adf8605..c54e40d 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_train.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_train.pt
@@ -8,7 +8,7 @@ layer {
   python_param {
     module: 'roi_data_layer.layer'
     layer: 'RoIDataLayer'
-    param_str: "'num_classes': 21"
+    param_str: "'num_classes': 6"
   }
 }
 
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_train.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_train.pt
index 262ed65..1a424a2 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_train.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_train.pt
@@ -11,7 +11,7 @@ layer {
   python_param {
     module: 'roi_data_layer.layer'
     layer: 'RoIDataLayer'
-    param_str: "'num_classes': 21"
+    param_str: "'num_classes': 6"
   }
 }
 
@@ -244,7 +244,7 @@ layer {
   param { lr_mult: 1.0 }
   param { lr_mult: 2.0 }
   inner_product_param {
-    num_output: 21
+    num_output: 6
     weight_filler {
       type: "gaussian"
       std: 0.01
@@ -263,7 +263,7 @@ layer {
   param { lr_mult: 1.0 }
   param { lr_mult: 2.0 }
   inner_product_param {
-    num_output: 84
+    num_output: 24
     weight_filler {
       type: "gaussian"
       std: 0.001
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_train.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_train.pt
index 336b05b..bc0db0c 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_train.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_train.pt
@@ -8,7 +8,7 @@ layer {
   python_param {
     module: 'roi_data_layer.layer'
     layer: 'RoIDataLayer'
-    param_str: "'num_classes': 21"
+    param_str: "'num_classes': 6"
   }
 }
 
```

### Dataset Script  

My classes: **kuaikuai**, **lays**, **soda**, **biscuit**, **noodle**  

```diff 
diff --git a/lib/datasets/imdb.py b/lib/datasets/imdb.py
index b56bf0a..93c85a4 100644
--- a/lib/datasets/imdb.py
+++ b/lib/datasets/imdb.py
@@ -108,6 +108,10 @@ class imdb(object):
             oldx2 = boxes[:, 2].copy()
             boxes[:, 0] = widths[i] - oldx2 - 1
             boxes[:, 2] = widths[i] - oldx1 - 1
+            for b in range(len(boxes)):
+                if boxes[b][2] < boxes[b][0]:
+                    boxes[b][0] = 0
+
             assert (boxes[:, 2] >= boxes[:, 0]).all()
             entry = {'boxes' : boxes,
                      'gt_overlaps' : self.roidb[i]['gt_overlaps'],
diff --git a/lib/datasets/pascal_voc.py b/lib/datasets/pascal_voc.py
index b55f2f6..7a3473d 100644
--- a/lib/datasets/pascal_voc.py
+++ b/lib/datasets/pascal_voc.py
@@ -28,11 +28,12 @@ class pascal_voc(imdb):
                             else devkit_path
         self._data_path = os.path.join(self._devkit_path, 'VOC' + self._year)
         self._classes = ('__background__', # always index 0
-                         'aeroplane', 'bicycle', 'bird', 'boat',
-                         'bottle', 'bus', 'car', 'cat', 'chair',
-                         'cow', 'diningtable', 'dog', 'horse',
-                         'motorbike', 'person', 'pottedplant',
-                         'sheep', 'sofa', 'train', 'tvmonitor')
+                         'kuaikuai', 'lays', 'soda', 'biscuit', 'noodle')
+                         # 'aeroplane', 'bicycle', 'bird', 'boat',
+                         # 'bottle', 'bus', 'car', 'cat', 'chair',
+                         # 'cow', 'diningtable', 'dog', 'horse',
+                         # 'motorbike', 'person', 'pottedplant',
+                         # 'sheep', 'sofa', 'train', 'tvmonitor')
         self._class_to_ind = dict(zip(self.classes, xrange(self.num_classes)))
         self._image_ext = '.jpg'
         self._image_index = self._load_image_set_index()

```

**update imdb.py and pascal_voc.py**  

```shell 
cd lib/datasets/
rm imdb.pyc pascal_voc.py

# start python to compile pyc
import py_compile
py_compile.compile(r'imdb.py')
py_compile.compile(r'pascal_voc.py')
```

### Speed up training for test only  

For make sure the training process works properly.  

Modify train_faster_rcnn_alt_opt.py  

```diff
diff --git a/tools/train_faster_rcnn_alt_opt.py b/tools/train_faster_rcnn_alt_opt.py
index e49844a..1dafe3f 100755
--- a/tools/train_faster_rcnn_alt_opt.py
+++ b/tools/train_faster_rcnn_alt_opt.py
@@ -77,8 +77,9 @@ def get_solvers(net_name):
                [net_name, n, 'stage2_fast_rcnn_solver30k40k.pt']]
     solvers = [os.path.join(cfg.MODELS_DIR, *s) for s in solvers]
     # Iterations for each training stage
-    max_iters = [80000, 40000, 80000, 40000]
-    # max_iters = [100, 100, 100, 100]
+    # max_iters = [20000, 10000, 20000, 10000]
+    # max_iters = [80000, 40000, 80000, 40000]
+    max_iters = [100, 100, 100, 100]
     # Test prototxt for the RPN
     rpn_test_prototxt = os.path.join(
         cfg.MODELS_DIR, net_name, n, 'rpn_test.pt')
```

Modify solvers  

```diff
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_solver30k40k.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_solver30k40k.pt
index 0180e7c..40636f0 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_solver30k40k.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_solver30k40k.pt
@@ -3,7 +3,7 @@ train_net: "models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_fast_rcnn_train.pt"
 base_lr: 0.001
 lr_policy: "step"
 gamma: 0.1
-stepsize: 30000
+stepsize: 30
 display: 20
 average_loss: 100
 momentum: 0.9
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_solver60k80k.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_solver60k80k.pt
index 23a7c6a..3f116dd 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_solver60k80k.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_solver60k80k.pt
@@ -3,7 +3,7 @@ train_net: "models/pascal_voc/ZF/faster_rcnn_alt_opt/stage1_rpn_train.pt"
 base_lr: 0.001
 lr_policy: "step"
 gamma: 0.1
-stepsize: 60000
+stepsize: 50
 display: 20
 average_loss: 100
 momentum: 0.9
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_solver30k40k.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_solver30k40k.pt
index a666def..2271d67 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_solver30k40k.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_solver30k40k.pt
@@ -3,7 +3,7 @@ train_net: "models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_fast_rcnn_train.pt"
 base_lr: 0.001
 lr_policy: "step"
 gamma: 0.1
-stepsize: 30000
+stepsize: 30
 display: 20
 average_loss: 100
 momentum: 0.9
diff --git a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_solver60k80k.pt b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_solver60k80k.pt
index 15d3da7..9d57101 100644
--- a/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_solver60k80k.pt
+++ b/models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_solver60k80k.pt
@@ -3,7 +3,7 @@ train_net: "models/pascal_voc/ZF/faster_rcnn_alt_opt/stage2_rpn_train.pt"
 base_lr: 0.001
 lr_policy: "step"
 gamma: 0.1
-stepsize: 60000
+stepsize: 50
 display: 20
 average_loss: 100
 momentum: 0.9
```

## Outupt  

When you try to start a new round of training, you need to delete two cache files generated by last time.  
One is **/py-faster-rcnn/data/cache (delete the folder)**  
The other is **/py-faster-rcnn/data/VOCdevkit2007/annotation_cache (if it exist, delete the folder)**  

```shell
# if retain 
find . -name '*.pyc' | xargs rm
# start training
./experiments/scripts/faster_rcnn_alt_opt.sh 0 ZF pascal_voc

...

VOC07 metric? Yes
Reading annotation for 1/116
Reading annotation for 101/116
Saving cached annotations to /home/dlsummer/RCNN-install/py-faster-rcnn/data/VOCdevkit2007/annotations_cache/annots.pkl
AP for kuaikuai = 0.6687
AP for lays = 0.6286
AP for soda = 0.7081
AP for biscuit = 0.9091
AP for noodle = 0.4354
Mean AP = 0.6700
~~~~~~~~
Results:
0.669
0.629
0.708
0.909
0.435
0.670
~~~~~~~~

--------------------------------------------------------------
Results computed with the **unofficial** Python eval code.
Results should be very close to the official MATLAB eval code.
Recompute with `./tools/reval.py --matlab ...` for your paper.
-- Thanks, The Management
--------------------------------------------------------------

real    344m5.757s
user    298m23.512s
sys     45m38.792s
```

### Demo  

```shell
cp output/faster_rcnn_alt_opt/voc_2007_trainval/*.caffemodel ./data/faster_rcnn_models/
## or 
cp output/faster_rcnn_alt_opt/voc_2007_trainval/zf_fast_rcnn_stage2_iter_100.caffemodel data/faster_rcnn_models/MY_ZF_faster_rcnn_final.caffemodel

## putting test images  
cp data/VOCdevkit2007/VOC2007/JPEGImages/???.jpg data/demo/
## ex
## cp data/VOCdevkit2007/VOC2007/JPEGImages/G25_000?00.jpg data/demo/

## run demo  
./tools/demo_save_im.py --net zf  

```

![](/images/2017-08-31/demo4.jpg)
![](/images/2017-08-31/demo5.jpg)
![](/images/2017-08-31/demo6.jpg)

## Troubleshooting  

### SSH: no display issue  

```shell 
$ ./tool/demo.py

Demo for data/demo/000456.jpg
Detection took 0.198s for 300 object proposals
Traceback (most recent call last):
  File "./tools/demo.py", line 149, in <module>
    demo(net, im_name)
  File "./tools/demo.py", line 98, in demo
    vis_detections(im, cls, dets, thresh=CONF_THRESH)
  File "./tools/demo.py", line 47, in vis_detections
    fig, ax = plt.subplots(figsize=(12, 12))
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/pyplot.py", line 1202, in subplots
    fig = figure(**fig_kw)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/pyplot.py", line 535, in figure
    **kwargs)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/backends/backend_tkagg.py", line 81, in new_figure_manager
    return new_figure_manager_given_figure(num, figure)
  File "/usr/local/lib/python2.7/dist-packages/matplotlib/backends/backend_tkagg.py", line 89, in new_figure_manager_given_figure
    window = Tk.Tk()
  File "/usr/lib/python2.7/lib-tk/Tkinter.py", line 1818, in __init__
    self.tk = _tkinter.create(screenName, baseName, className, interactive, wantobjects, useTk, sync, use)
_tkinter.TclError: no display name and no $DISPLAY environment variable
```

1. Install Xming, Teamviewer or use X11 forwarding `ssh -X`  
   http://blog.csdn.net/j790675692/article/details/52693761  
2. Modify ./tool/demo.py

```diff
diff --git a/tools/demo.py b/tools/demo.py
index 631c68a..5016da5 100755
--- a/tools/demo.py
+++ b/tools/demo.py
@@ -13,6 +13,9 @@ Demo script showing detections in sample images.
 See README.md for installation instructions before running.
 """
 
+import matplotlib
+matplotlib.use('Agg')
+
 import _init_paths
 from fast_rcnn.config import cfg
 from fast_rcnn.test import im_detect
@@ -67,7 +72,9 @@ def vis_detections(im, class_name, dets, thresh=0.5):
                   fontsize=14)
     plt.axis('off')
     plt.tight_layout()
-    plt.draw()
+    #plt.draw()
+    pic_name = class_name + '_' + im_name
+    plt.savefig(pic_name)
 
 def demo(net, image_name):
     """Detect object classes in an image using pre-computed object proposals."""
```


### AttributeError: 'module' object has no attribute 'text_format'   

```shell
$ ./experiments/scripts/faster_rcnn_alt_opt.sh 0 VGG16 pascal_voc

[libprotobuf WARNING google/protobuf/io/coded_stream.cc:78] The total number of bytes read was 553432430
I0804 08:22:22.416573  2399 net.cpp:816] Ignoring source layer pool5
I0804 08:22:22.539361  2399 net.cpp:816] Ignoring source layer relu7
I0804 08:22:22.539386  2399 net.cpp:816] Ignoring source layer drop7
I0804 08:22:22.539389  2399 net.cpp:816] Ignoring source layer fc8
I0804 08:22:22.539392  2399 net.cpp:816] Ignoring source layer prob
Process Process-1:
Traceback (most recent call last):
  File "/usr/lib/python2.7/multiprocessing/process.py", line 258, in _bootstrap
    self.run()
  File "/usr/lib/python2.7/multiprocessing/process.py", line 114, in run
    self._target(*self._args, **self._kwargs)
  File "./tools/train_faster_rcnn_alt_opt.py", line 129, in train_rpn
    max_iters=max_iters)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 157, in train_net
    pretrained_model=pretrained_model)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 51, in __init__
    pb2.text_format.Merge(f.read(), self.solver_param)
AttributeError: 'module' object has no attribute 'text_format'
```

install protobuf==2.6.0
```shell
$ sudo pip install protobuf==2.6.0
```

Ref: [http://blog.csdn.net/qq_32768743/article/details/74639381](http://blog.csdn.net/qq_32768743/article/details/74639381)  

### Out of Memory   

```shell
I0804 08:28:56.610743  2742 net.cpp:270] This network produces output rpn_loss_bbox
I0804 08:28:56.610782  2742 net.cpp:283] Network initialization done.
I0804 08:28:56.610920  2742 solver.cpp:60] Solver scaffolding done.
Loading pretrained model weights from data/imagenet_models/VGG16.v2.caffemodel
[libprotobuf WARNING google/protobuf/io/coded_stream.cc:537] Reading dangerously large protocol message.  If the message turns out to be larger than 2147483647 bytes, parsing will be halted for security reasons.  To increase the limit (or to disable these warnings), see CodedInputStream::SetTotalBytesLimit() in google/protobuf/io/coded_stream.h.
[libprotobuf WARNING google/protobuf/io/coded_stream.cc:78] The total number of bytes read was 553432430
I0804 08:28:56.840101  2742 net.cpp:816] Ignoring source layer pool5
I0804 08:28:56.961663  2742 net.cpp:816] Ignoring source layer relu7
I0804 08:28:56.961685  2742 net.cpp:816] Ignoring source layer drop7
I0804 08:28:56.961688  2742 net.cpp:816] Ignoring source layer fc8
I0804 08:28:56.961689  2742 net.cpp:816] Ignoring source layer prob
Solving...
F0804 08:28:57.365995  2742 syncedmem.cpp:56] Check failed: error == cudaSuccess (2 vs. 0)  out of memory
*** Check failure stack trace: ***
^C
dlsummer@dlsummer-BM1AF-BP1AF-BM6AF:~/RCNN-install/py-faster-rcnn$ free -m
              total        used        free      shared  buff/cache   available
Mem:          11887         237       10480          17        1168       11350
Swap:         12159           0       12159
```

**The graphic car out of memory** 
Tried to train ZF model.
GTX1060 may not have enough memory for VGG16.
(I'm not sure the GPU is 6G ver. or 3G ver.)

In ZF model, you should modify:  

1. stage1_rpn_train.pt  line 11  
2. stage1.fast_rcnn_train.pt line 14, line 247 (In layer "cls_score"), line 266 (In layer "bbox_pred")  
3. stage2_rpn_train.pt  line 11  
4. stage2.fast_rcnn_train.pt line 14, line 247 (In layer "cls_score"), line 266 (In layer "bbox_pred")  
5. faster_rcnn_test.pt line 306 (In layer "cls_score"), line 315 (In layer "bbox_pred")  

### TypeError: 'numpy.float64' object cannot be interpreted as an index

```shell
Process Process-3:
Traceback (most recent call last):
  File "/usr/lib/python2.7/multiprocessing/process.py", line 258, in _bootstrap
    self.run()
  File "/usr/lib/python2.7/multiprocessing/process.py", line 114, in run
    self._target(*self._args, **self._kwargs)
  File "./tools/train_faster_rcnn_alt_opt.py", line 196, in train_fast_rcnn
    max_iters=max_iters)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 160, in train_net
    model_paths = sw.train_model(max_iters)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 101, in train_model
    self.solver.step(1)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/layer.py", line 144, in forward
    blobs = self._get_next_minibatch()
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/layer.py", line 63, in _get_next_minibatch
    return get_minibatch(minibatch_db, self._num_classes)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/minibatch.py", line 55, in get_minibatch
    num_classes)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/minibatch.py", line 100, in _sample_rois
    fg_inds, size=fg_rois_per_this_image, replace=False)
  File "mtrand.pyx", line 1187, in mtrand.RandomState.choice (numpy/random/mtrand/mtrand.c:18864)
TypeError: 'numpy.float64' object cannot be interpreted as an index
```

**Solution:**  
[https://github.com/rbgirshick/py-faster-rcnn/issues/481](https://github.com/rbgirshick/py-faster-rcnn/issues/481)  

>> There seems to be a similar error caused by line 173 in lib/roi_data_layer/minibatch.py.  
>> cls = clss[ind]  
>> This is then used to slice bbox_targets[], however it is not an int and throws an error after hours of training. Change it to,  
>> cls = int(clss[ind])  
>> You will save yourself a headache.  

vi lib/roi_data_layer/minibatch.py  
line 173: cls = int(clss[ind])  

```diff
diff --git a/lib/roi_data_layer/minibatch.py b/lib/roi_data_layer/minibatch.py
index f4535b0..dc15c62 100644
--- a/lib/roi_data_layer/minibatch.py
+++ b/lib/roi_data_layer/minibatch.py
@@ -93,7 +93,7 @@ def _sample_rois(roidb, fg_rois_per_image, rois_per_image, num_classes):
     fg_inds = np.where(overlaps >= cfg.TRAIN.FG_THRESH)[0]
     # Guard against the case when an image has fewer than fg_rois_per_image
     # foreground RoIs
-    fg_rois_per_this_image = np.minimum(fg_rois_per_image, fg_inds.size)
+    fg_rois_per_this_image = int(np.minimum(fg_rois_per_image, fg_inds.size))
     # Sample foreground regions without replacement
     if fg_inds.size > 0:
         fg_inds = npr.choice(
@@ -105,8 +105,8 @@ def _sample_rois(roidb, fg_rois_per_image, rois_per_image, num_classes):
     # Compute number of background RoIs to take from this image (guarding
     # against there being fewer than desired)
     bg_rois_per_this_image = rois_per_image - fg_rois_per_this_image
-    bg_rois_per_this_image = np.minimum(bg_rois_per_this_image,
-                                        bg_inds.size)
+    bg_rois_per_this_image = int(np.minimum(bg_rois_per_this_image,
+                                        bg_inds.size))
     # Sample foreground regions without replacement
     if bg_inds.size > 0:
         bg_inds = npr.choice(
@@ -170,7 +170,7 @@ def _get_bbox_regression_labels(bbox_target_data, num_classes):
     bbox_inside_weights = np.zeros(bbox_targets.shape, dtype=np.float32)
     inds = np.where(clss > 0)[0]
     for ind in inds:
-        cls = clss[ind]
+        cls = int(clss[ind])
         start = 4 * cls
         end = start + 4
         bbox_targets[ind, start:end] = bbox_target_data[ind, 1:]
```

### ImportError: numpy.core.multiarray failed to import

```shell
Traceback (most recent call last):
  File "./tools/train_faster_rcnn_alt_opt.py", line 19, in <module>
    from datasets.factory import get_imdb
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/datasets/factory.py", line 13, in <module>
    from datasets.coco import coco
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/datasets/coco.py", line 20, in <module>
    from pycocotools.coco import COCO
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/pycocotools/coco.py", line 58, in <module>
    import mask
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/pycocotools/mask.py", line 3, in <module>
    import pycocotools._mask as _mask
  File "pycocotools/_mask.pyx", line 20, in init pycocotools._mask
  File "__init__.pxd", line 989, in numpy.import_array
ImportError: numpy.core.multiarray failed to import
```

**Solution:**  

`sudo -H pip install --upgrade numpy`  

### TypeError: only length-1 arrays can be converted to Python scalars  

```shell
Process Process-3:
Traceback (most recent call last):
  File "/usr/lib/python2.7/multiprocessing/process.py", line 258, in _bootstrap
    self.run()
  File "/usr/lib/python2.7/multiprocessing/process.py", line 114, in run
    self._target(*self._args, **self._kwargs)
  File "./tools/train_faster_rcnn_alt_opt.py", line 196, in train_fast_rcnn
    max_iters=max_iters)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 160, in train_net
    model_paths = sw.train_model(max_iters)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/fast_rcnn/train.py", line 101, in train_model
    self.solver.step(1)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/layer.py", line 144, in forward
    blobs = self._get_next_minibatch()
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/layer.py", line 63, in _get_next_minibatch
    return get_minibatch(minibatch_db, self._num_classes)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/minibatch.py", line 55, in get_minibatch
    num_classes)
  File "/home/dlsummer/RCNN-install/py-faster-rcnn/tools/../lib/roi_data_layer/minibatch.py", line 100, in _sample_rois
    int(fg_inds), size=fg_rois_per_this_image, replace=False)
TypeError: only length-1 arrays can be converted to Python scalars
```

**Solution**  
vi lib/roi_data_layer/minibatch.py  
line 100: size=int(fg_rois_per_this_image)  

