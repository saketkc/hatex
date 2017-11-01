import numpy as np
from lib.layer_utils import *

""" Classes """
class TestRNN(object):
    def __init__(self, input_dim, hidden_dim, cell_type='rnn', dtype=np.float32, seed=None):
        self.params = {}
        self.grads = {}


        if cell_type in 'rnn':
            self.rnn = VanillaRNN(input_dim, hidden_dim)
        ########## TODO: ##########
        if cell_type in 'lstm':
            self.rnn = LSTM(input_dim, hidden_dim)
        ########### END ###########

        self.gather_params()

    def forward(self, feat, h0):
        output = feat
        output = self.rnn.forward(output, h0)
        self.gather_params()
        return output

    def backward(self, dout):
        dout, dh0 = self.rnn.backward(dout)
        self.gather_grads()
        return dout

    def gather_params(self):
        for n, v in self.rnn.params.items():
            self.params[n] = v

    def assign_params(self):
        for n, v in self.rnn.params.items():
            self.rnn.params[n] = self.params[n]

    def gather_grads(self):
        for n, v in self.rnn.grads.items():
                self.grads[n] = v

class LanguageModelRNN(object):
    def __init__(self, word_size, word_vec_dim, hidden_dim, cell_type='rnn', dtype=np.float32, seed=None):
        self.params = {}
        self.grads = {}

        self.word_size = word_size
        self.word_vec_dim = word_vec_dim
        self.hidden_dim = hidden_dim
        self.cell_type = cell_type

        ########## TODO: ##########

        self.preprocess = word_embedding(word_size, word_vec_dim, name="we")
        self.postprocess = temporal_fc(hidden_dim, word_size,  name='test_t_fc')

        if cell_type in 'rnn':
            self.rnn =  VanillaRNN(word_vec_dim, hidden_dim, init_scale=0.02, name="rnn")
        if cell_type in 'lstm':
            self.rnn =  LSTM(word_vec_dim, hidden_dim, init_scale=0.02, name="lstm")
        ########### END ###########

        self.gather_params()

    def forward(self, feat, h0):
        output = feat
        if self.preprocess is not None:
            output = self.preprocess.forward(output)
        if self.rnn is not None:
            output = self.rnn.forward(output, h0)
        if self.postprocess is not None:
            output = self.postprocess.forward(output)
        self.gather_params()
        return output

    def backward(self, dout):
        if self.postprocess is not None:
            dout = self.postprocess.backward(dout)
        if self.rnn is not None:
            dout, dh0 = self.rnn.backward(dout)
        if self.preprocess is not None:
            dout = self.preprocess.backward(dout)
        self.gather_grads()
        return dout, dh0

    def sample(self, word_index, n_text):
        x = np.zeros((1,1), dtype=np.int)
        x[0,0] = word_index
        w_indices = [word_index]
        if self.cell_type in 'rnn':
            h = np.zeros((1,1,self.hidden_dim))
            for i in range(0, n_text):
                output = self.preprocess.forward(x)
                h[:,0,:], _ = self.rnn.step_forward(output[:,0,:], h[:,0,:])
                output = self.postprocess.forward(h)
                x[0,0] = np.argmax(output, axis=2)
                w_indices.append(x[0,0])
        if self.cell_type in 'lstm':
            c = np.zeros((1,1,self.hidden_dim))
            h = np.zeros((1,1,self.hidden_dim))
            for i in range(0, n_text):
                output = self.preprocess.forward(x)
                h[:,0,:], c[:,0,:], _ = self.rnn.step_forward(output[:,0,:], h[:,0,:], c[:,0,:])
                output = self.postprocess.forward(h)
                x[0,0] = np.argmax(output, axis=2)
                w_indices.append(x[0,0])
        return w_indices

    def gather_params(self):
        if self.preprocess is not None:
            for n, v in self.preprocess.params.items():
                self.params[n] = v
        for n, v in self.rnn.params.items():
                self.params[n] = v
        if self.postprocess is not None:
            for n, v in self.postprocess.params.items():
                self.params[n] = v

    def assign_params(self):
        v = None
        if self.preprocess is not None:
            for n, v in self.preprocess.params.items():
                self.preprocess.params[n] = self.params[n]
        for n, v in self.rnn.params.items():
            self.rnn.params[n] = self.params[n]
        if self.postprocess is not None:
            for n, v in self.postprocess.params.items():
                self.postprocess.params[n] = self.params[n]

    def gather_grads(self):
        if self.preprocess is not None:
            for n, v in self.preprocess.grads.items():
                self.grads[n] = v
        for n, v in self.rnn.grads.items():
                self.grads[n] = v
        if self.postprocess is not None:
            for n, v in self.postprocess.grads.items():
                self.grads[n] = v


