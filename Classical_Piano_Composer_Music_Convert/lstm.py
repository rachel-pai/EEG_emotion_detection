""" This module prepares midi file data and feeds it to the neural
    network for training """

import random, os
import sys
import pickle
import numpy
from music21 import converter, instrument, note, chord
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import LSTM
from keras.layers import Activation
from keras.utils import np_utils
from keras.callbacks import ModelCheckpoint
def train_network(emotion,numbers):
    """ Train a Neural Network to generate music """
    notes = get_notes(emotion,numbers)

    # get amount of pitch names
    n_vocab = len(set(notes))

    network_input, network_output = prepare_sequences(notes, n_vocab)

    model = create_network(network_input, n_vocab)

    train(model, network_input, network_output,emotion)

def get_notes(emotion,numbers):
    """ Get all the notes and chords from the midi files in the ./midi_songs directory """
    notes = []
    if emotion == 'happy':
        filenames = random.sample(os.listdir("midi_songs/happy/"), numbers)
    elif emotion == 'sad':
        filenames = random.sample(os.listdir("midi_songs/sad/"), numbers)
    elif emotion == 'anger':
        filenames = random.sample(os.listdir("midi_songs/anger/"), numbers)
    elif emotion == "surprise":
        filenames = random.sample(os.listdir("midi_songs/surprise/"), numbers)
    else:
        raise Exception("emotion can only be happy,sad, anger or surprise.")


    for file in filenames:
        midi = converter.parse("midi_songs/"+emotion+"/"+file)

        print("Parsing %s" % file)

        notes_to_parse = None

        try: # file has instrument parts
            s2 = instrument.partitionByInstrument(midi)
            notes_to_parse = s2.parts[0].recurse() 
        except: # file has notes in a flat structure
            notes_to_parse = midi.flat.notes

        for element in notes_to_parse:
            if isinstance(element, note.Note):
                notes.append(str(element.pitch))
            elif isinstance(element, chord.Chord):
                notes.append('.'.join(str(n) for n in element.normalOrder))

    with open('data/notes_'+emotion, 'wb') as filepath:
        pickle.dump(notes, filepath)

    return notes

def prepare_sequences(notes, n_vocab):
    """ Prepare the sequences used by the Neural Network """
    sequence_length = 100

    # get all pitch names
    pitchnames = sorted(set(item for item in notes))

     # create a dictionary to map pitches to integers
    note_to_int = dict((note, number) for number, note in enumerate(pitchnames))

    network_input = []
    network_output = []

    # create input sequences and the corresponding outputs
    for i in range(0, len(notes) - sequence_length, 1):
        sequence_in = notes[i:i + sequence_length]
        sequence_out = notes[i + sequence_length]
        network_input.append([note_to_int[char] for char in sequence_in])
        network_output.append(note_to_int[sequence_out])

    n_patterns = len(network_input)

    # reshape the input into a format compatible with LSTM layers
    network_input = numpy.reshape(network_input, (n_patterns, sequence_length, 1))
    # normalize input
    network_input = network_input / float(n_vocab)

    network_output = np_utils.to_categorical(network_output)

    return (network_input, network_output)

def create_network(network_input, n_vocab):
    """ create the structure of the neural network """
    model = Sequential()
    model.add(LSTM(
        512,
        input_shape=(network_input.shape[1], network_input.shape[2]),
        return_sequences=True
    ))
    model.add(Dropout(0.3))
    model.add(LSTM(512, return_sequences=True))
    model.add(Dropout(0.3))
    model.add(LSTM(512))
    model.add(Dense(256))
    model.add(Dropout(0.3))
    model.add(Dense(n_vocab))
    model.add(Activation('softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')
    return model

def train(model, network_input, network_output,emotion):
    """ train the neural network """
    filepath = "weights_"+emotion+".hdf5"
    checkpoint = ModelCheckpoint(
        filepath,
        monitor='loss',
        verbose=0,
        save_best_only=True,
        mode='min'
    )
    callbacks_list = [checkpoint,earlystopping]
    # 200 batch, 64 batch size
    model.fit(network_input, network_output, epochs=50, batch_size=64, callbacks=callbacks_list)
if __name__ == '__main__':
    emotion = sys.argv[1]
    numbers = int(sys.argv[2])
    train_network(emotion,numbers)
