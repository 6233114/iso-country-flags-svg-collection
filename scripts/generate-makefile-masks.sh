#!/bin/bash
DIR=$1
STYLE=$2
./scripts/generate-makefile-headers.sh

FILES=`cat $DIR/index`

COUNT=0
for FILE in $FILES
do
	# two encoded files per source
	((COUNT++))
	((COUNT++))
done

MESSAGE="Building $DIR-$STYLE/web button templates (step 2/4) ..."

printf "T := $COUNT\n\n"

printf "all: finish\n\n"

printf "folders:\n"
printf "\t@mkdir -p $DIR-$STYLE/web\n"
printf "\t@mkdir -p $DIR-$STYLE/web-noshadow\n\n"

printf "finish: sources\n"
printf "\t@\$(DONE)\n\t@printf \" $MESSAGE\\\\n\"\n\n"

echo -n "sources: folders"


for FILE in $FILES
do
	# relative path from Makefile folder to build folder
	printf " $DIR-$STYLE/web/$FILE"
	printf " $DIR-$STYLE/web-noshadow/$FILE"
done
printf "\n\n"

INDEX=0
for FILE in $FILES
do
	# relative path from Makefile folder to build folder
	printf "$DIR-$STYLE/web/$FILE: $DIR/orig/$FILE\n"
	printf "\t@\$(ECHO)\n\t@printf \" $MESSAGE\\r\"\n\t@convert \$< -alpha set -gravity center -scale 403x403 -extent 512x512 artwork/common/mask.png -compose DstIn -composite artwork/styles/$STYLE/fore.png -compose Over -gravity South-East -composite \( -scale 512 artwork/common/logo.png \) -compose Over -composite artwork/common/back-shadow.png -compose DstOver -composite \$@\n\n"
	((INDEX++))
done

for FILE in $FILES
do
	# relative path from Makefile folder to build folder
	printf "$DIR-$STYLE/web-noshadow/$FILE: $DIR/orig/$FILE\n"
	printf "\t@\$(ECHO)\n\t@printf \" $MESSAGE\\r\"\n\t@convert \$< -alpha set -gravity center -scale 403x403 -extent 512x512 artwork/common/mask.png -compose DstIn -composite artwork/styles/$STYLE/fore.png -compose Over -gravity South-East -composite \( -scale 512 artwork/common/logo.png \) -compose Over -composite artwork/common/back-empty.png -compose DstOver -composite \$@\n\n"
	((INDEX++))
done
