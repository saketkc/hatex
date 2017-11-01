import numpy as np


""" Super Class """
class Optimizer(object):
	""" 
	This is a template for implementing the classes of optimizers
	"""
	def __init__(self, net, lr=1e-4):
		self.net = net  # the model
		self.lr = lr    # learning rate
		
	def update(self, layer):
		pass

	""" Make a step and update all parameters """
	def step(self):
		if self.net.preprocess is not None:
			self.update(self.net.preprocess)
		if self.net.rnn is not None:
			self.update(self.net.rnn)
		if self.net.postprocess is not None:
			self.update(self.net.postprocess)

""" Classes """
class SGD(Optimizer):
	""" Some comments """
	def __init__(self, net, lr=1e-4):
		self.net = net
		self.lr = lr
		
	def update(self, layer):
		for n, v in layer.params.items():
			dv = layer.grads[n]
			layer.params[n] -= self.lr * dv

	def step(self):
		if self.net.preprocess is not None:
			self.update(self.net.preprocess)
		if self.net.rnn is not None:
			self.update(self.net.rnn)
		if self.net.postprocess is not None:
			self.update(self.net.postprocess)

class SGDM(Optimizer):
	def __init__(self, net, lr=1e-4, momentum=0.0):
		self.net = net
		self.lr = lr
		self.momentum = momentum
		self.velocity = {}
		
	def update(self, layer):
		for n, v in layer.params.items():
			dv = layer.grads[n]
			if n not in self.velocity:
				self.velocity[n] = np.zeros(v.shape)
			v_new = self.momentum * self.velocity[n] - self.lr * dv
			layer.params[n] += v_new
			self.velocity[n] = v_new

	def step(self):
		if self.net.preprocess is not None:
			self.update(self.net.preprocess)
		if self.net.rnn is not None:
			self.update(self.net.rnn)
		if self.net.postprocess is not None:
			self.update(self.net.postprocess)

class RMSProp(Optimizer):
	def __init__(self, net, lr=1e-2, decay=0.99, eps=1e-8):
		self.net = net
		self.lr = lr
		self.decay = decay
		self.eps = eps
		self.cache = {}  # decaying average of past squared gradients
		
	def update(self, layer):
		for n, v in layer.params.items():
			dv = layer.grads[n]
			if n not in self.cache:
				self.cache[n] = np.zeros(v.shape)
			self.cache[n] = self.decay * self.cache[n] + (1-self.decay) * dv**2
			layer.params[n] -= self.lr * dv / np.sqrt(self.cache[n] + self.eps)

	def step(self):
		if self.net.preprocess is not None:
			self.update(self.net.preprocess)
		if self.net.rnn is not None:
			self.update(self.net.rnn)
		if self.net.postprocess is not None:
			self.update(self.net.postprocess)

class Adam(Optimizer):
	def __init__(self, net, lr=1e-3, beta1=0.9, beta2=0.999, t=0, eps=1e-8):
		self.net = net
		self.lr = lr
		self.beta1, self.beta2 = beta1, beta2
		self.eps = eps
		self.mt = {}
		self.vt = {}
		self.t = t

	def update(self, layer):
		for n, v in layer.params.items():
			dv = layer.grads[n]
			self.t += 1
			if n not in self.mt:
				self.mt[n] = np.zeros(v.shape)
			if n not in self.vt:
				self.vt[n] = np.zeros(v.shape)
			mt = self.beta1 * self.mt[n] + (1-self.beta1)*dv
			vt = self.beta2 * self.vt[n] + (1-self.beta2)*dv**2	
			mt_bi = mt / (1 - self.beta1**self.t)
			vt_bi = vt / (1 - self.beta2**self.t)
			self.mt[n] = mt
			self.vt[n] = vt
			
			layer.params[n] -= self.lr * mt_bi / np.sqrt(vt_bi + self.eps)
	
	def step(self):	
		if self.net.preprocess is not None:
			self.update(self.net.preprocess)
		if self.net.rnn is not None:
			self.update(self.net.rnn)
		if self.net.postprocess is not None:
			self.update(self.net.postprocess)