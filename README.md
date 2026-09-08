# Audio Transmission Through BPSK Technique

## Overview

This project demonstrates the transmission of an audio signal using Binary Phase Shift Keying (BPSK) in MATLAB.

The audio signal is converted into a digital representation, modulated using BPSK, passed through a simulated communication channel, and then recovered at the receiver. The project also analyzes the system performance using BER and SNR measurements.

## Objectives

- Convert an audio signal into digital data.
- Perform BPSK modulation.
- Simulate a communication channel with noise.
- Recover the transmitted data using BPSK demodulation.
- Reconstruct the received audio signal.
- Analyze system performance using BER and SNR.
- Visualize different stages of the transmission process.

## Technologies Used

- MATLAB
- Digital Communication
- BPSK Modulation
- PCM Encoding
- AWGN Channel
- Signal Processing

## Project Structure

```text
Audio-Transmission-through-BPSK-technique/
│
├── main_transmission.m
│
└── Audio/
    ├── audio_input.m
    ├── audio_test.m
    ├── ber_analysis.m
    ├── ber_vs_snr.m
    ├── binary.m
    ├── bpsk_channel.m
    ├── bpsk_constellation.m
    ├── bpsk_modulation.m
    ├── bpsk_receiver.m
    ├── bpsk_waveform.m
    ├── pcm_encoding.m
    ├── snr_audio_comparison.m

How to Run
Download or clone this repository.
Open MATLAB.
Set the project folder as the MATLAB Current Folder.
Make sure the Audio folder is present inside the project folder.
Run:
main_transmission.m
The program will perform the audio transmission and display the corresponding results.
    ├── untitled2.m
    └── voice sample1.wav
