# CSCI-599 Assignment 2

## The objective of this assignment
* Implement a simple recurrent neural network.
* Implement the a deep convolutional generative adversarial networks (DCGAN) proposed in [Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks](https://arxiv.org/abs/1511.06434).
* **\[BONUS\]** Implement the vanilla style transfer algorithm proposed in [Image Style Transfer Using Convolutional Neural Networks](https://www.cv-foundation.org/openaccess/content_cvpr_2016/html/Gatys_Image_Style_Transfer_CVPR_2016_paper.html).

## Work on the assignment
Working on the assignment in a virtual environment is highly encouraged.
Please see below for executing a virtual environment.
```shell
cd assignment2
sudo pip install virtualenv # If you didn't install it
virtualenv -p python3 /your/path/to/the/virtual/env
source  /your/path/to/the/virtual/env/bin/activate
pip install -r requirements.txt  # Install dependencies
# Note that this does NOT install TensorFlow,
# which you need to do yourself.
# Work on the assignment
deactivate # Exit the virtual environment
```

Please clone or download as .zip file of this repository.

## Work with IPython Notebook
To start working on the assignment, simply run the following command to start an ipython kernel.
```shell
# port is only needed if you want to work on more than one notebooks
jupyter notebook --port=/your/port/
```
and then work on each problem with their corresponding ```.ipynb``` notebooks.

In this assignment, please use Python `3.5`. You will need to make sure that your virtualenv setup is of the correct version of python is used. 

## Problems

### Problem 1: Language Modeling with RNNs (50 points)

The IPython Notebook `Problem_1.ipynb` will walk you through implementing simple recurrent neural network.

### Problem 2: Generative Adversarial Networks (50 points)

The IPython Notebook `Problem_2.ipynb` will help you have a better understanding of implementing a generative adversarial network.

### [BONUS] Problem 3: Style Transfer (20 points)

This problem is a BONUS problem which is not required.

The IPython Notebook `Problem_3.ipynb` will walk you through implementing the neural style transfer algorithm.

## How to submit

Run the following command to zip all the necessary files for submitting your assignment.

```shell
sh collectSubmission.sh
```

This will create a file named `assignment2.zip`, please submit this file through the [Google form](https://goo.gl/forms/6MMgxPWmQRuKp7I82).
Do NOT create your own .zip file, you might accidentally include non-necessary
materials for grading. We will deduct points if you don't follow the above
submission guideline.

## Questions?
If you have any question or find a bug in this assignment (or even any suggestions), we are
more than welcome to assist.

Again, NO INDIVIDUAL EMAILS WILL BE RESPONDED.

PLEASE USE **PIAZZA** TO POST QUESTIONS (under folder assignment2).
