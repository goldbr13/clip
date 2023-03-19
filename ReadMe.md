


# Mobile CLIP
Mobile CLIP is a project undertaken by Robert Helck and Rebecca Goldberg for CSC 380, where the goal is to implement a mobile application using the CLIP vision transformer for object recognition in real time. 

## Notes
This file contains very large .pt files. Please use Git Large File Storage when adding these files to a commit. Otherwise, pushing to the remote repo will fail, and you will have to reset your commit history to get rid of the .pt files.

To add large files (for example .pt files) to a Git commit do:

``` git lfs track "*.pt" ```
```git add .```

I include both a resnet-18 model and a ViT model. The inclusion of the RCNN model may be subject to change, but for now I am keeping it in since it is relatively lightweight and can be useful for testing

## ViT Model

ViT_b_16 is a lightweight implementation of a vision transformer provided with PyTorch. You can find more information here: https://pytorch.org/vision/main/models/vision_transformer.html

## Building and Deploying

This app is meant to be built and installed using Gradle. 
TODO add more.
## USE 
TODO add more.
