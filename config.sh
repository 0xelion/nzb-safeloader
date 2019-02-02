#!/bin/bash

##////////////////////////////////////////
#///          CONFIGURATION            ///
##////////////////////////////////////////

# Work directory:
DIR=$(pwd)
# Upload directory:
UPL="$DIR/Upload"
# Temporary directory
TMP="$DIR/Temp"
# Output directory
CPL="$DIR/Completed"

# Nyuu path:
NYUU="nyuu"
# ParPar path:
PARPAR="parpar"

# Use encryption?
ENC="true"
# Random encryption password?
ENCR="false"
# If false, custom password:
KEY="PlaceYourEncryptionKeyHere"

# Obfuscate nzb filename?
OBFS="true"
# Create log file? (include password)
LOG="true"

# Split archives?
SPLIT="true"
# Max archive size:
SIZE="50m"

# Use parchive?
USEPAR="true"
# Parchive redundancy:
REDUN="10%"

# Server url:
HOST="my.usenetserver.com"
# Server port:
PORT="563"
# Server encryption:
SSL="true"
# Server username
USER="MyUsername"
# Server password:
PASS="MyPassword"
# Server max connections:
MAXCO="10"

# Article size:
ASIZE="700K"
# Article poster:
POSTER="YourName <YourName@local>"
# Article group:
GROUP="alt.binaries.backup"

# Debug mode (Upload and cleanup disabled)
DEBUG="false"

#////////////////////////////////////////
