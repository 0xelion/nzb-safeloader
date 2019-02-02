#!/bin/bash

source config.sh

echo "--- Checking ---"

mkdir -p $UPL
mkdir -p $TMP
mkdir -p $CPL

$NYUU --help &> /dev/null
if [ "$?" != 0 ] ; then
    echo "Error : check your Nyuu installation."
    exit 1 ; fi

$PARPAR --help &> /dev/null
if [ "$?" != 0 ] ; then
    echo "Error : check your ParPar installation."
    exit 1 ; fi

CHKDIR=$(ls -l $UPL)
if [ "$CHKDIR" = "total 0" ] ; then
    echo "Error : You don't have any files in your upload folder."
    exit 1 ; elif [ "$?" == 0 ]; then
    echo "Error : You don't have any files in your upload folder."
    exit 1 ; fi

echo "--- Step 1 - Preparing ---"

HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DATE=`date '+%Y.%m.%d | %H:%M:%S'`

if [ $ENCR = "true" ] ; then
  KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) ; fi

if [ $OBFS = "true" ] ; then
  NAME="$HASH" ; else
  NAME=$(ls $UPL | head -1) ; fi

if [ $LOG = "true" ] ; then
  echo -------------------------------------------------------- >> $DIR/safeloader.log
  echo Date : $DATE >> $DIR/safeloader.log
  echo Original "Filename(s)" : >> $DIR/safeloader.log
  ls $UPL >> $DIR/safeloader.log
  echo Archive "Filename" : $HASH >> $DIR/safeloader.log
  echo Password : $KEY >> $DIR/safeloader.log ; fi

echo "--- Step 2 - Packing ---"

ZARG="-mx0 -mhe=on"

if [ $ENC = "true" ] ; then
  ZARG="$ZARG -p$KEY" ; fi

if [ $SPLIT = "true" ] ; then
  ZARG="$ZARG -v$SIZE" ; fi

7z a $ZARG "$TMP/$HASH.7z" "$UPL/*"

echo "--- Step 3 - Parchiving ---"

PARG="-s 400k -r $REDUN"

if [ $SPLIT = "true" ] ; then
  PARG="$PARG -p $SIZE" ; fi

if [ $USEPAR = "true" ] ; then
  $PARPAR $PARG -o "$TMP/$HASH.par2" "$TMP/"*7z* ; else
  echo "(SKIPPED)" ; fi

echo "--- Step 4 - Uploading ---"

if [ $SSL = "true" ] ; then
  SSLF="-S" ; else
  SSLF="" ; fi

if [ $DEBUG = "false" ] ; then
  $NYUU -h "$HOST" -P "$PORT" "$SSLF" -u "$USER" -p "$PASS" -n "$MAXCO" -a "$ASIZE" -f "$POSTER" -g "$GROUP" -o "$CPL/$NAME.nzb" $TMP/* ; else
  echo "(SKIPPED)" ; fi

echo "--- Step 5 - Cleaning Up ---"

if [ $DEBUG = "false" ] ; then
  rm -r $TMP/* ; else
  echo "(SKIPPED)" ; fi

echo "--- Done ---"
