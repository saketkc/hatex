import numpy as np
from layer_utils import *


""" Super Class """
class Module(object):
    def __init__(self):
        self.params = {}
        self.grads = {}

    def forward(self):
        raise ValueError("Not Implemented Error")

    def backward(self):
        raise ValueError("Not Implemented Error")


""" Classes """
class TestFCReLU(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.net = sequential(
            ########## TODO: ##########
            fc(12, 10, name='my_fc'),
            relu(name='my_relu')

            ########### END ###########
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class SmallFullyConnectedNetwork(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.net = sequential(
            ########## TODO: ##########
            fc(4, 30, name='fc1'),
            relu(name='relu1'),
            fc(30, 7, name='fc2'),
            relu(name='relu2')

            ########### END ###########
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class DropoutNet(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.dropout = dropout
        self.seed = seed
        self.net = sequential(
            fc(15, 20, 5e-2, name="fc1"),
            relu(name="relu1"),
            fc(20, 30, 5e-2, name="fc2"),
            relu(name="relu2"),
            fc(30, 10, 5e-2, name="fc3"),
            relu(name="relu3"),
            dropout(dropout_p, seed=seed)
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class TinyNet(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        """ Some comments """
        self.net = sequential(
            ########## TODO: ##########
            fc(3*32*32, 512, 2/(float(3072+512)), name="fc1"),
            relu(name="relu1"),
            fc(512, 10, 2/float(512+10), name="fc2"),
            relu(name="relu2")
            ########### END ###########
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class DropoutNetTest(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.dropout = dropout
        self.seed = seed
        self.net = sequential(
            fc(3072, 500, 1e-2, name="fc1"),
            relu(name="relu1"),
            fc(500, 500, 1e-2, name="fc2"),
            relu(name="relu2"),
            fc(500, 10, 1e-2, name="fc3"),
            dropout(dropout_p, seed=seed)
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class FullyConnectedNetwork_2Layers(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.net = sequential(
            fc(5, 5, name="fc1"),
            relu(name="relu1"),
            fc(5, 5, name="fc2")
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev


class FullyConnectedNetwork(object):
    def __init__(self, dropout_p=0, dtype=np.float32, seed=None):
        self.net = sequential(
            fc(3072, 100, 5e-2, name="fc1"),
            relu(name="relu1"),
            fc(100, 100, 5e-2, name="fc2"),
            relu(name="relu2"),
            fc(100, 100, 5e-2, name="fc3"),
            relu(name="relu3"),
            fc(100, 100, 5e-2, name="fc4"),
            relu(name="relu4"),
            fc(100, 100, 5e-2, name="fc5"),
            relu(name="relu5"),
            fc(100, 10, 5e-2, name="fc6")
        )

    def forward(self, feat, is_Training=True):
        output = feat
        for layer in self.net.layers:
            if isinstance(layer, dropout):
                output = layer.forward(output, is_Training)
            else:
                output = layer.forward(output)
        self.net.gather_params()
        return output

    def backward(self, dprev):
        for layer in self.net.layers[::-1]:
            dprev = layer.backward(dprev)
        self.net.gather_grads()
        return dprev
