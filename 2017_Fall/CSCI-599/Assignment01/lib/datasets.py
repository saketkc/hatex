import cPickle as pickle
import numpy as np
import os
from scipy.misc import imread


def unPickle(filename):
	""" Unpickle a file """
	with open(filename, 'rb') as f:
		d = pickle.load(f)
		return d


def CIFAR10(data_path):
	""" Load every batch of CIFAR-10 binary data """
	all_batches = []
	all_labels = []
	for b in range(1,6):
		f_train_curr = os.path.join(data_path, 'data_batch_%d' % (b, ))
		d = unPickle(f_train_curr)
		batch = d['data'].reshape(10000, 3, 32, 32).transpose(0,2,3,1).astype("float")
		labels = np.array(d['labels'])
		all_batches.append(batch)
		all_labels.append(labels)
	data_train = np.concatenate(all_batches)
	labels_train = np.concatenate(all_labels)
	del batch, labels
	f_test = os.path.join(data_path, 'test_batch')
	d = unPickle(f_test)
	data_test = d['data'].reshape(10000, 3, 32, 32).transpose(0,2,3,1).astype("float")
	labels_test = np.array(d['labels'])
	return data_train, labels_train, data_test, labels_test


def CIFAR10_data(num_training=49000, num_validation=1000, num_test=1000):
	# Load the raw CIFAR-10 data
	cifar10_dir = "data/cifar-10-batches-py"
	data_train, labels_train, data_test, labels_test = CIFAR10(cifar10_dir)
	    
	# Subsample the data
	data_val = data_train[range(num_training, num_training+num_validation)]
	labels_val = labels_train[range(num_training, num_training+num_validation)]
	data_train = data_train[range(num_training)]
	labels_train = labels_train[range(num_training)]
	data_test = data_test[range(num_test)]
	labels_test = labels_test[range(num_test)]

	# Normalize the data: subtract the images mean
	mean_image = np.mean(data_train, axis=0)
	data_train -= mean_image
	data_val -= mean_image
	data_test -= mean_image

	# Transpose from (N, H, W, C) to (N, C, H, W)
	data_train = data_train.transpose(0, 3, 1, 2).copy()
	data_val = data_val.transpose(0, 3, 1, 2).copy()
	data_test = data_test.transpose(0, 3, 1, 2).copy()

	# return a data dict
	return {
	  'data_train': data_train, 'labels_train': labels_train,
	  'data_val': data_val, 'labels_val': labels_val,
	  'data_test': data_test, 'labels_test': labels_test,
	}