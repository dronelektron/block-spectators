#!/bin/bash

PLUGIN_NAME="block-spectators"

cd scripting
spcomp $PLUGIN_NAME.sp -o ../plugins/$PLUGIN_NAME.smx
