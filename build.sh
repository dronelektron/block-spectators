#!/bin/bash

PLUGIN_NAME="block-spectators"

cd scripting
spcomp $PLUGIN_NAME.sp -i include -o ../plugins/$PLUGIN_NAME.smx
