import numpy as np


""" Super Class """
class Optimizer(object):
    """
    This is a template for implementing the classes of optimizers
    """
    def __init__(self, net, lr=1e-4):
        self.net = net  # the model
        self.lr = lr    # learning rate

    """ Make a step and update all parameters """
    def step(self):
        for layer in self.net.layers:
            for n, v in layer.params.iteritems():
                pass


""" Classes """
class SGD(Optimizer):
    """ Some comments """
    def __init__(self, net, lr=1e-4):
        self.net = net
        self.lr = lr

    def step(self):
        for layer in self.net.layers:
            for n, v in layer.params.iteritems():
                dv = layer.grads[n]
                layer.params[n] -= self.lr * dv


class SGDM(Optimizer):
    def __init__(self, net, lr=1e-4, momentum=0.0):
        self.net = net
        self.lr = lr
        self.momentum = momentum
        self.velocity = {}

    def step(self):
        #############################################################################
        # TODO: Implement the SGD + Momentum                                        #
        #############################################################################
        for layer in self.net.layers:
            for n, v in layer.params.iteritems():
                vprev = self.velocity.get(n, np.zeros_like((layer.params[n])))
                dv = layer.grads[n]
                vnew = self.momentum * vprev - self.lr*dv
                self.velocity[n] = vnew
                layer.params[n] += vnew
        #############################################################################
        #                             END OF YOUR CODE                              #
        #############################################################################


class RMSProp(Optimizer):
    def __init__(self, net, lr=1e-2, decay=0.99, eps=1e-8):
        self.net = net
        self.lr = lr
        self.decay = decay
        self.eps = eps
        self.cache = {}  # decaying average of past squared gradients

    def step(self):
        #############################################################################
        # TODO: Implement the RMSProp                                               #
        #############################################################################
        for layer in self.net.layers:
            for n, v in layer.params.iteritems():
                eg2prev = self.cache.get(n, 0)
                dv = layer.grads[n]
                g2 = dv**2
                eg2new = self.decay*eg2prev + (1-self.decay)*g2
                self.cache[n] = eg2new
                layer.params[n] -= self.lr*dv/(np.sqrt(eg2new+self.eps))

        #############################################################################
        #                             END OF YOUR CODE                              #
        #############################################################################


class Adam(Optimizer):
    def __init__(self, net, lr=1e-3, beta1=0.9, beta2=0.999, t=0, eps=1e-8):
        self.net = net
        self.lr = lr
        self.beta1, self.beta2 = beta1, beta2
        self.eps = eps
        self.mt = {}
        self.vt = {}
        self.t = t

    def step(self):
        #############################################################################
        # TODO: Implement the Adam                                                  #
        #############################################################################
        self.t += 1
        for layer in self.net.layers:
            for n, v in layer.params.iteritems():
                dv = layer.grads[n]
                mtprev = self.mt.get(n, np.zeros_like((layer.params[n])))
                vtprev = self.vt.get(n, np.zeros_like((layer.params[n])))
                mtnew = self.beta1 * mtprev + (1-self.beta1) * dv
                vtnew = self.beta2 * vtprev + (1-self.beta2) * (dv**2)
                self.vt[n] = vtnew
                self.mt[n] = mtnew
                layer.params[n] -= self.lr*(mtnew/(1-self.beta1**self.t)) /(np.sqrt(vtnew/(1-self.beta2**self.t))+self.eps)

        #############################################################################
        #                             END OF YOUR CODE                              #
        #############################################################################
