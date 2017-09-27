# CSCI-599 Assignment 1

## The objective of this assignment
* Implement the forward and backward passes as well as the neural network training procedure
* Implement the widely-used optimizers and training tricks including dropout
* Get familiar with TensorFlow by training and designing a network on your own
* Learn how to fine-tune trained networks
* Visualize the learned weights and activation maps of a ConvNet
* Use Grad-CAM to visualize and reason why ConvNet makes certain predictions

## Work on the assignment
Working on the assignment in a virtual environment is highly encouraged.
Please see below for executing a virtual environment.
```shell
cd assignment1
sudo pip install virtualenv # If you didn't install it
virtualenv /your/path/to/the/virtual/env
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

In this assignment, please use Python `2.7`. You will need to make sure that your virtualenv setup is of the correct version of python is used. 

## Problems

### Problem 1: Basics of Neural Networks (35 points)
The IPython Notebook `Problem_1.ipynb` will walk you through implementing the basic neural networks.

### Problem 2: Getting familiar with TensorFlow (25 points)
The IPython Notebook `Problem_2.ipynb` will help you have a better understanding of implementing a simple ConvNet in Tensorflow.

### Problem 3: Training and Fine-tuning on Fashion MNIST and MNIST (15 points)
The IPython Notebook `Problem_3.ipynb` will walk you through training a neural network from scratch on a datase and fine-tuning on another dataset.

### Problem 4: Visualizations and CAM (25 points)
The IPython Notebook `Problem_4.ipynb` will help you have a better understanding of the skills of visualizing neural networks.

## How to submit

Run the following command to zip all the necessary files for submitting your assignment.

```shell
sh collectSubmission.sh
```

This will create a file named `assignment1.zip`, please submit this file through the [Google form](https://goo.gl/forms/tZ4oNSZT55aw7jGD2).
Do NOT create your own .zip file, you might accidentally include non-necessary
materials for grading. We will deduct points if you don't follow the above
submission guideline.

## Questions?
If you have any question or find a bug in this assignment (or even any suggestions), we are
more than welcome to assist.

Again, NO INDIVIDUAL EMAILS WILL BE RESPONDED.

PLEASE USE **PIAZZA** TO POST QUESTIONS (under folder assignment1).
