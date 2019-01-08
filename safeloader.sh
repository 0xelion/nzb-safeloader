##////////////////////////////////////////
#///          CONFIGURATION            ///
##////////////////////////////////////////

# Work directory:
DIR=$(pwd)

# Nyuu location:
NYUU="nyuu"
# ParPar location:
PARPAR="parpar"

# Encryption password:
KEY="PlaceYourEncryptionKeyHere"

# Obfuscated nzb filename?
OBFS="true"
# Create result files?
RESULT="true"

# Use parchive?
USEPAR="true"
# Parchive redundancy
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
SIZE="700K"
# Article poster:
POSTER="YourName <YourName@local>"
# Article group:
GROUP="alt.binaries.backup"

#////////////////////////////////////////

echo "--- Step 1 - Preparing ---"

HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
FILE=$(ls $DIR/Upload)

mkdir -p $DIR/Upload
mkdir -p $DIR/Temp
mkdir -p $DIR/Completed

if [ $SSL = "true" ]
then
  SSLF="-S"
else
  SSLF=""
fi

if [ $OBFS = "true" ]
then
  NAME="$HASH"
else
  NAME=$(ls $DIR/Upload/ | head -1)
fi

if [ $RESULT = "true" ]
then
  echo "Filename(s)" : $FILE >> $DIR/Completed/$NAME.txt
  echo "Filename" Obfuscated : $HASH >> $DIR/Completed/$NAME.txt
  echo Password : $KEY >> $DIR/Completed/$NAME.txt
fi

echo "--- Step 2 - Packing ---"

7z a -mx0 -v50m -mhe=on -p"$KEY" "$DIR/Temp/$HASH.7z" "$DIR/Upload/*"

echo "--- Step 3 - Parchiving ---"

if [ $USEPAR = "true" ]
then
  $PARPAR -s 400k -r $REDUN -o "$DIR/Temp/$HASH.par2" "$DIR/Temp/"*7z*
fi

echo "--- Step 4 - Uploading ---"

$NYUU -h "$HOST" -P "$PORT" "$SSLF" -u "$USER" -p "$PASS" -n "$MAXCO" -a "$SIZE" -f "$POSTER" -g "$GROUP" -o "$DIR/Completed/$NAME.nzb" $DIR/Temp/*

echo "--- Step 5 - Cleaning Up ---"

rm -r $DIR/Temp/*

echo "--- Done ---"
