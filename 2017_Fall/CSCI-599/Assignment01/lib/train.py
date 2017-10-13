from lib.layer_utils import *
from lib.grad_check import *
from lib.optim import *
import numpy as np


class CIFAR10_DataLoader(object):
    """
    Data loader class for CIFAR-10 Data.

    Arguments:
    - data: Array of input data, of shape (batch_size, d_1, ..., d_k)
    - labels: Array of labels, of shape (batch_size,)
    - batch_size: The size of each returned minibatch
    """
    def __init__(self, data, labels, batch_size):
        self.data = data
        self.labels = labels
        self.batch_size = batch_size
        self.indices = np.asarray(range(data.shape[0]))

    # reset the indices to be full length
    def _reset(self):
        self.indices = np.asarray(range(self.data.shape[0]))

    # Call this shuffle function after the last batch for each epoch
    def _shuffle(self):
        np.random.shuffle(self.indices)

    # Get the next batch of data
    def get_batch(self):
        if len(self.indices) < self.batch_size:
            self._reset()
            self._shuffle()
        indices_curr = self.indices[0:self.batch_size]
        data_batch = self.data[indices_curr]
        labels_batch = self.labels[indices_curr]
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
    N = data.shape[0]
    if num_samples is not None and N > num_samples:
        indices = np.random.choice(N, num_samples)
        N = num_samples
        data = data[indices]
        labels = labels[indices]

    num_batches = N // batch_size
    if N % batch_size != 0:
        num_batches += 1
    preds = []
    for i in range(num_batches):
        start = i * batch_size
        end = (i + 1) * batch_size
        output = model.forward(data[start:end], False)
        scores = softmax(output)
        pred = np.argmax(scores, axis=1)
        preds.append(pred)
    preds = np.hstack(preds)
    accuracy = np.mean(preds == labels)
    return accuracy



""" Some comments """
def train_net(data, model, loss_func, optimizer, batch_size, max_epochs,
              lr_decay=1.0, lr_decay_every=1000, show_every=10, verbose=False):
    """
    Train a network with this function, parameters of the network are updated
    using stochastic gradient descent methods defined in optim.py.

    The parameters which achive the best performance after training for given epochs
    will be returned as a param dict. The training history and the validation history
    is returned for post analysis.

    Arguments:
    - data: Fata instance should look like the followings:
    - data_dict = {
        "data_train": (# Training data,   # Training GT Labels),
        "data_val":   (# Validation data, # Validation GT Labels),
        "data_test":  (# Testing data,    # Testing GT Labels),
      }

    - model: An instance defined in the fully_conn.py, with a sequential object as attribute

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
    - val_acc_hist: Validation accuracy recorded during training
    """

    # Initialize the variables
    data_train, labels_train = data["data_train"]
    data_val, labels_val = data["data_val"]
    dataloader = CIFAR10_DataLoader(data_train, labels_train, batch_size)
    opt_val_acc = 0.0
    opt_params = {}
    loss_hist = []
    train_acc_hist = []
    val_acc_hist = []

    # Compute the maximum iterations and iterations per epoch
    iters_per_epoch = max(data_train.shape[0] / batch_size, 1)
    max_iters = iters_per_epoch  * max_epochs

    # Start the training
    for epoch in xrange(max_epochs):
        # Compute the starting iteration and ending iteration for current epoch
        iter_start = epoch * iters_per_epoch
        iter_end   = (epoch + 1) * iters_per_epoch

        # Decay the learning rate every specified epochs
        if epoch % lr_decay_every == 0 and epoch > 0:
            optimizer.lr = optimizer.lr * lr_decay
            print "Decaying learning rate of the optimizer to {}".format(optimizer.lr)

        # Main training loop
        for iter in xrange(iter_start, iter_end):
            data_batch, labels_batch = dataloader.get_batch()

            #############################################################################
            # TODO: Update the parameters by a forward pass for the network, a backward #
            # pass to the network, and make a step for the optimizer                    #
            #############################################################################
            loss = None
            output_batch = model.forward(data_batch, True)
            loss = loss_func.forward(output_batch, labels_batch)
            dLoss = loss_func.backward()
            dX_batch = model.backward(dLoss)
            optimizer.step()

            #############################################################################
            #                             END OF YOUR CODE                              #
            #############################################################################
            loss_hist.append(loss)

            # Show the training loss
            if verbose and iter % show_every == 0:
                print "(Iteration {} / {}) loss: {}".format(iter+1, max_iters, loss_hist[-1])

        # End of epoch, compute the accuracies
        train_acc = 0
        val_acc = 0
        #############################################################################
        # TODO: Compute the training accuracy and validation accuracy, store the    #
        # results to train_acc_hist, and val_acc_hist respectively                  #
        #############################################################################
        """
        output_train_args = np.argmax(model.forward(data_train), axis=0)
        output_val_args = np.argmax(model.forward(data_val), axis=0)

        output_train_encoded = np.zeros(data_train.shape)
        output_train_encoded[np.arange(data_train.shape[0]), output_train_args] = 1

        output_val_encoded = np.zeros(data_train.shape)
        output_val_encoded[np.arange(data_train.shape[0]), output_val_args] = 1

        labels_train_encoded = np.zeros(data_train.shape)
        labels_train_encoded[np.arange(data_train.shape[0]), labels_train] = 1

        labels_val_encoded = np.zeros(data_train.shape)
        labels__encoded[np.arange(data_train.shape[0]), labels_val] = 1
        """
        train_acc = compute_acc(model, data_train, labels_train)
        val_acc = compute_acc(model, data_val, labels_val)




        #############################################################################
        #                             END OF YOUR CODE                              #
        #############################################################################
        train_acc_hist.append(train_acc)
        val_acc_hist.append(val_acc)

        # Save the best params for the model
        if val_acc > opt_val_acc:
            #############################################################################
            # TODO: Save the optimal parameters to opt_params variable by name          #
            #############################################################################
            for layer in model.net.layers:
                for n, v in layer.params.iteritems():
                    opt_params[n] = v
            #############################################################################
            #                             END OF YOUR CODE                              #
            #############################################################################

        # Show the training accuracies
        if verbose:
            print "(Epoch {} / {}) Training Accuracy: {}, Validation Accuracy: {}".format(
            epoch+1, max_epochs, train_acc, val_acc)

    return opt_params, loss_hist, train_acc_hist, val_acc_hist
