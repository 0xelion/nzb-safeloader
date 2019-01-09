##////////////////////////////////////////
#///          CONFIGURATION            ///
##////////////////////////////////////////

# Work directory:
DIR=$(pwd)

# Nyuu path:
NYUU="nyuu"
# ParPar path:
PARPAR="parpar"

# Encryption password:
KEY="PlaceYourEncryptionKeyHere"

# Obfuscate nzb filename?
OBFS="true"
# Create log file? (include password)
LOG="true"

# Split archives?
SPIT="true"
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

echo "--- Step 1 - Preparing ---"

HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DATE=`date '+%Y.%m.%d | %H:%M:%S'`

mkdir -p $DIR/Upload
mkdir -p $DIR/Temp
mkdir -p $DIR/Completed

if [ $OBFS = "true" ] ; then
  NAME="$HASH" ; else
  NAME=$(ls $DIR/Upload/ | head -1) ; fi

if [ $LOG = "true" ] ; then
  echo -------------------------------------------------------- >> $DIR/safeloader.log
  echo Date : $DATE >> $DIR/safeloader.log
  echo Original "Filename(s)" : >> $DIR/safeloader.log
  ls $DIR/Upload >> $DIR/safeloader.log
  echo Archive "Filename" : $HASH >> $DIR/safeloader.log
  echo Password : $KEY >> $DIR/safeloader.log ; fi

echo "--- Step 2 - Packing ---"

ZARG="-mx0 -mhe=on -p$KEY"

if [ $SPLIT = "true" ] ; then
  ZARG="$ZARG -v$SIZE" ; fi

7z a $ZARG "$DIR/Temp/$HASH.7z" "$DIR/Upload/*"

echo "--- Step 3 - Parchiving ---"

PARG="-s 400k -r $REDUN"

if [ $SPLIT = "true" ] ; then
  PARG="$PARG -p $SIZE" ; fi

if [ $USEPAR = "true" ] ; then
  $PARPAR $PARG -o "$DIR/Temp/$HASH.par2" "$DIR/Temp/"*7z* ; else
  echo "(SKIPPED)" ; fi

echo "--- Step 4 - Uploading ---"

if [ $SSL = "true" ] ; then
  SSLF="-S" ; else
  SSLF="" ; fi

if [ $DEBUG = "false" ] ; then
  $NYUU -h "$HOST" -P "$PORT" "$SSLF" -u "$USER" -p "$PASS" -n "$MAXCO" -a "$ASIZE" -f "$POSTER" -g "$GROUP" -o "$DIR/Completed/$NAME.nzb" $DIR/Temp/* ; fi

echo "--- Step 5 - Cleaning Up ---"

if [ $DEBUG = "false" ] ; then
  rm -r $DIR/Temp/* ; fi

echo "--- Done ---"
