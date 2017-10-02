## Code adopted from Stanford CS231N gradient_check.py

import numpy as np
from random import randrange


def rel_error(x, y):
	""" returns relative error """
	return np.max(np.abs(x - y) / (np.maximum(1e-8, np.abs(x) + np.abs(y))))


def eval_numerical_gradient(f, x, verbose=True, h=0.00001):
	""" 
	a naive implementation of numerical gradient of f at x 
	- f should be a function that takes a single argument
	- x is the point (numpy array) to evaluate the gradient at
	"""
	fx = f(x)  # evaluate function value at original point
	grad = np.zeros_like(x)
	it = np.nditer(x, flags=['multi_index'], op_flags=['readwrite'])
	while not it.finished:
		ix = it.multi_index
		oldval = x[ix]
		x[ix] = oldval + h  # increment by h
		fxph = f(x)  # evalute f(x + h)
		x[ix] = oldval - h  # decrese by h
		fxmh = f(x)  # evaluate f(x - h)
		x[ix] = oldval  # restore
		# compute the partial derivative with centered formula
		grad[ix] = (fxph - fxmh) / (2 * h) # the slope
		if verbose:
			print ix, grad[ix]
		it.iternext() # step to next dimension
	return grad


def eval_numerical_gradient_array(f, x, df, h=1e-5):
	"""
	Evaluate a numeric gradient for a function that accepts a numpy
	array and returns a numpy array.
	"""
	grad = np.zeros_like(x)
	it = np.nditer(x, flags=['multi_index'], op_flags=['readwrite'])
	while not it.finished:
		ix = it.multi_index
		oldval = x[ix]
		x[ix] = oldval + h  # increment by h
		pos = f(x).copy()  # evalute f(x + h)
		x[ix] = oldval - h  # decrese by h
		neg = f(x).copy()  # evaluate f(x - h)
		x[ix] = oldval  # restore
		# compute the partial derivative with centered formula
		grad[ix] = np.sum((pos - neg) * df) / (2 * h)
		it.iternext()
	return grad