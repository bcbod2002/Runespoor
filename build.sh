#!/bin/bash

# Install Swift
curl -s https://download.swift.org/swift-6.0-release/ubuntu2204/swift-6.0-RELEASE/swift-6.0-RELEASE-ubuntu22.04.tar.gz | tar xz
export PATH=$PATH:$(pwd)/swift-6.0-RELEASE-ubuntu22.04/usr/bin

# Build the Swift project
swift build -c release 