import os
import numpy as np
import tensorflow as tf


PIXEL_MEANS = np.array([[[103.939, 116.779, 123.68]]])


class Vgg16(object):
    def __init__(self, batch_size=3, num_classes=1000, model_path=None, trainable=True):
        # Input place holders
        self.trainable = trainable
        self.num_classes = num_classes
        self.batch_size = batch_size
        self.inputs = tf.placeholder("float", [self.batch_size, 224, 224, 3])
        self.labels = tf.placeholder(tf.float32, [self.batch_size, num_classes])
        self.pretrained = None

    def load(self, model_path=None):
        model_path = None
        if model_path is None:
            curr_dir = os.path.dirname(os.path.abspath(__file__))
            model_path = os.path.join(curr_dir, "vgg16.npy")
            print("Model from {}".format(model_path))
        self.pretrained = np.load(model_path, encoding='latin1').item()
        print("Pretrained VGG16 successfully loaded!")

    def setup(self):
        """
        VGG16 Implementations
        input images should be scaled to 0 to 255, RGB reversed to BGR
        """
        inputs_scaled = self.inputs * 255.0
        inputs_scaled -= PIXEL_MEANS
        inputs = tf.reverse(inputs_scaled, axis=[-1])

        # conv1 family
        self.conv1_1 = self.conv(inputs, name="conv1_1")
        self.conv1_2 = self.conv(self.conv1_1, name="conv1_2")
        self.pool1 = self.max_pool(self.conv1_2, name="pool1")

        # conv2 family
        self.conv2_1 = self.conv(self.pool1, name="conv2_1")
        self.conv2_2 = self.conv(self.conv2_1, name="conv2_2")
        self.pool2 = self.max_pool(self.conv2_2, name="pool2")

        # conv3 family
        self.conv3_1 = self.conv(self.pool2, name="conv3_1")
        self.conv3_2 = self.conv(self.conv3_1, name="conv3_2")
        self.conv3_3 = self.conv(self.conv3_2, name="conv3_3")
        self.pool3 = self.max_pool(self.conv3_3, name="pool3")

        # conv4 family
        self.conv4_1 = self.conv(self.pool3, name="conv4_1")
        self.conv4_2 = self.conv(self.conv4_1, name="conv4_2")
        self.conv4_3 = self.conv(self.conv4_2, name="conv4_3")
        self.pool4 = self.max_pool(self.conv4_3, name="pool4")

        # conv5 family
        self.conv5_1 = self.conv(self.pool4, name="conv5_1")
        self.conv5_2 = self.conv(self.conv5_1, name="conv5_2")
        self.conv5_3 = self.conv(self.conv5_2, name="conv5_3")
        self.pool5 = self.max_pool(self.conv5_3, name="pool5")

        # fc layers
        self.fc6 = self.fc(self.pool5, name="fc6")
        self.fc7 = self.fc(self.fc6, name="fc7")
        self.fc8 = self.fc(self.fc7, activation=None, name="fc8")

        # scores
        self.prob = tf.nn.softmax(self.fc8, name="prob")

    def conv(self, input, s=1, activation=tf.nn.relu, name="conv"):
        with tf.variable_scope(name):
            weights = self.get_conv_weight(name)
            conv = tf.nn.conv2d(input, weights, [1, s, s, 1], padding='SAME')
            bias = self.get_bias(name)
            bias = tf.nn.bias_add(conv, bias)
            if activation is not None:
                output = activation(bias)
            return output

    def fc(self, input, activation=tf.nn.relu, name="fc"):
        with tf.variable_scope(name):
            num_feats = np.prod(input.get_shape().as_list()[1:])
            x = tf.reshape(input, [-1, num_feats])
            weights = self.get_fc_weight(name)
            bias = self.get_bias(name)
            output = tf.nn.bias_add(tf.matmul(x, weights), bias)
            if activation is not None:
                output = activation(output)
            return output

    def max_pool(self, input, k=2, s=2, name=None):
        return tf.nn.max_pool(input, ksize=[1, k, k, 1], strides=[1, s, s, 1], padding='SAME', name=name)

    def get_conv_weight(self, name):
        return tf.Variable(self.pretrained[name][0], name="filter")

    def get_fc_weight(self, name):
        return tf.Variable(self.pretrained[name][0], name="weights")

    def get_bias(self, name):
        return tf.Variable(self.pretrained[name][1], name="biases")