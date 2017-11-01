from lib.layer_utils import *
from lib.grad_check import *
from lib.optim import *
import numpy as np

class DataLoader(object):
	"""
	Data loader class.

	Arguments:
	- data: Array of input data, of shape (batch_size, d_1, ..., d_k)
	- labels: Array of labels, of shape (batch_size,)
	- batch_size: The size of each returned minibatch
	"""
	def __init__(self, data, labels, batch_size, timesteps):
		self.data = data
		self.labels = labels
		self.batch_size = batch_size
		self.timesteps = timesteps
		self.indices = np.asarray(range(data.shape[0]-self.timesteps))

	# reset the indices to be full length
	def _reset(self):
		self.indices = np.asarray(range(self.data.shape[0]-self.timesteps))

	# Call this shuffle function after the last batch for each epoch
	def _shuffle(self):
		np.random.shuffle(self.indices)

	# Get the next batch of data
	def get_batch(self):
		if len(self.indices) < self.batch_size:
			self._reset()
			self._shuffle()
		
		indices_curr = self.indices[0:self.batch_size]
		data_batch = []
		labels_batch = []
		for i in indices_curr:
			data_batch.append(self.data[i:(i+self.timesteps)])
			labels_batch.append(self.labels[i:(i+self.timesteps)])
		data_batch = np.stack(data_batch, axis=0)
		labels_batch = np.stack(labels_batch, axis=0)
		self.indices = np.delete(self.indices, range(self.batch_size))
		return data_batch, labels_batch

def compute_acc(model, data, labels, num_samples=None, batch_size=100):
	"""
	Compute the accuracy of given data and labels

	Arguments:
	- data: Array of input data, of shape (batch_size, d_1, ..., d_k)
	- labels: Array of labels, of shape (batch_size,)
	- num_samples: If not None, subsample the data and only test the model
	  on these sampled datapoints.
	- batch_size: Split data and labels into batches of this size to avoid using
	  too much memory.

	Returns:
	- accuracy: Scalar indicating fraction of inputs that were correctly
	  classified by the model.
	"""
	N = 1
	if num_samples is not None and N > num_samples:
		indices = np.random.choice(N, num_samples)
		N = num_samples
		data = data[indices]
		labels = labels[indices]

	preds = []

	output = model.forward(data.reshape(1,-1), np.zeros((1, model.hidden_dim)))
	T = output.shape[1]
	V = output.shape[2]
	feat_flat = output.reshape(N * T, V)
	label_flat = labels.reshape(N * T)
	
	scores = np.exp(feat_flat - np.max(feat_flat, axis=1, keepdims=True))
	scores /= np.sum(scores, axis=1, keepdims=True)
	pred = np.argmax(scores, axis=1)
	preds.append(pred)

	preds = np.hstack(preds)
	accuracy = np.mean(preds == label_flat)
	return accuracy

""" Some comments """
def train_net(data, model, loss_func, optimizer, timesteps, batch_size, max_epochs,
			  lr_decay=1.0, lr_decay_every=1000, show_every=100, verbose=False):
	"""
	Train a network with this function, parameters of the network are updated
	using stochastic gradient descent methods defined in optim.py. 

	The parameters which achive the best performance after training for given epochs
	will be returned as a param dict. The training history is returned for post analysis. 

	Arguments:
	- data: Fata instance should look like the followings:
	- data_dict = {
		"data_train": (# Training data,   # Training GT Labels),
	  }

	- model: An instance defined in the rnn.py

	- loss_func: An instance defined in the layer_utils.py, we only introduce cross-entropy
	  classification loss for this part of assignment

	- batch_size: Batch size of the input data

	- max_epochs: The total number of epochs to train the model

	- lr_decay: The amount to decay the learning rate

	- lr_decay_every: Decay the learning rate every given epochs

	- show_every: Show the training information every given iterations

	- verbose: To show the information or not

	Returns:
	- opt_params: optimal parameters
	- loss_hist: Loss recorded during training
	- train_acc_hist: Training accuracy recorded during training
	"""

	# Initialize the variables
	data_train, labels_train = data["data_train"], data["labels_train"]
	dataloader = DataLoader(data_train, labels_train, batch_size, timesteps)
	opt_train_acc = 0.0
	opt_params = None
	loss_hist = []
	train_acc_hist = []
	
	# Compute the maximum iterations and iterations per epoch
	iters_per_epoch = max(data_train.shape[0] // batch_size, 1)
	max_iters = iters_per_epoch  * max_epochs

	# Start the training
	for epoch in xrange(max_epochs):
		# Compute the starting iteration and ending iteration for current epoch
		iter_start = epoch * iters_per_epoch
		iter_end   = (epoch + 1) * iters_per_epoch

		# Decay the learning rate every specified epochs
		if epoch % lr_decay_every == 0 and epoch > 0:
			optimizer.lr = optimizer.lr * lr_decay
			print("Decaying learning rate of the optimizer to {}".format(optimizer.lr))

		# Main training loop
		pred = np.zeros((1,model.hidden_dim))
		for iter in xrange(iter_start, iter_end):
			data_batch, labels_batch = dataloader.get_batch()
			
			# You'll need this
			mask = np.ones((data_batch.shape[0], data_batch.shape[1]))
			h0 = np.zeros((data_batch.shape[0], model.hidden_dim))
			pred, loss, dLoss, dX, dh0 = None, None, None, None, None
			#############################################################################
			# TODO: Update the parameters by a forward pass for the network, a backward #
			# pass to the network, and make a step for the optimizer					#
			#############################################################################
						
			#############################################################################
			#							 END OF YOUR CODE							  #
			#############################################################################
			loss_hist.append(loss)

			# Show the training loss
			if verbose and iter % show_every == 0:
				print("(Iteration {} / {}) loss: {}".format(iter+1, max_iters, loss_hist[-1]))

		# End of epoch, compute the accuracies
		train_acc = 0
		train_acc = compute_acc(model, data_train, labels_train, num_samples=10000)
		train_acc_hist.append(train_acc)

		# Save the best params for the model
		if train_acc > opt_train_acc:
			if verbose:
				print('bast performance {}%'.format(train_acc*100))
			opt_train_acc = train_acc
			opt_params = {}
			model.gather_params()
			for n, v in model.params.items():
				opt_params[n] = v.copy()

		# Show the training accuracies
		if verbose:
			print("(Epoch {} / {}) Training Accuracy: {}".format(
			epoch+1, max_epochs, train_acc))

	return opt_params, loss_hist, train_acc_hist
