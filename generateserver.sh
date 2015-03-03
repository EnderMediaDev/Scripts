bold=`tput bold`
normal=`tput sgr0`

echo "#### Welcome to EnderMedia Server Packager version 0.0.1"
echo "#### Since you are a lazy son of a gun, I'm going to do everything for you"
echo "#### If you can pry your fingers up for 2 small questions that would be great"
echo "#### After that you can be lazy while I do the rest, okay here we go!"
echo "#### Let's start easy, what pack slug would you like to generate a server for?"
read packslug
echo "Okay, I will use ${bold}$packslug${normal}, is that correct?"

read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack slug would you like to generate a server for?";read packslug;echo "Okay, I will use ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack slug would you like to generate a server for?";read packslug;echo "Okay, I will use ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack slug would you like to generate a server for?";read packslug;echo "Okay, I will use ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack slug would you like to generate a server for?";read packslug;echo "Okay, I will use ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, ${bold}$packslug${normal} will be used."
else
  echo "#### I gave you 5 tries, we are done here.";exit;
fi
fi
fi
fi
fi

echo "#### What version are we packaging the server for?"
read packversion
echo "Okay, I will create files for version ${bold}$packversion${normal} of ${bold}$packslug${normal}, is that correct?"


read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, version ${bold}$packversion${normal} of ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack version would you like to generate a server for?";read packversion;echo "Okay, I will use ${bold}$packversion${normal} of ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, version ${bold}$packversion${normal} of ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack version would you like to generate a server for?";read packversion;echo "Okay, I will use ${bold}$packversion${normal} of ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, version ${bold}$packversion${normal} of ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack version would you like to generate a server for?";read packversion;echo "Okay, I will use ${bold}$packversion${normal} of ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo "Excellent, version ${bold}$packversion${normal} of ${bold}$packslug${normal} will be used."
else
  echo "#### Let's try again, what pack version would you like to generate a server for?";read packversion;echo "Okay, I will use ${bold}$packversion${normal} of ${bold}$packslug${normal}, is that correct?";read -p " (y/n) " RESP
if [ "$RESP" = "y" ]; then
  echo echo "Excellent, version ${bold}$packversion${normal} of ${bold}$packslug${normal} will be used."
else
  echo "#### I gave you 5 tries, we are done here.";exit;
fi
fi
fi
fi
fi

#Generate environment

mkdir working_directories
mkdir working_directories/$packslug
mkdir working_directories/$packslug/$packversion
mkdir working_directories/forge
mkdir working_directories/packspecific
mkdir working_directories/packspecific/$packslug
mkdir working_directories/downloads
mkdir working_directories/downloads/$packslug

#Copy files from launcher instance

cp -av ~/Library/Application\ Support/technic/modpacks/$packslug/mods working_directories/$packslug/$packversion
cp -av ~/Library/Application\ Support/technic/modpacks/$packslug/config working_directories/$packslug/$packversion

#Cleanup client mods

rm -f working_directories/$packslug/$packversion/mods/*-client*
rm -f working_directories/$packslug/$packversion/mods/1.7.10/*-client*

#Fetch specified cauldron package
SERVERZIP="http://solder.endermedia.com/repository/internal/forgeserver.zip"
SPECIFICZIP="http://solder.endermedia.com/repository/internal/$packslug.zip"
echo "#### Would you like to specify a custom forgeserver.zip URL?"
read -p " (y/n) " RESP
if [ "$RESP" = "n" ]; then
  echo "#### We will use our file instead, consider yourself lucky, we have killer internet.";
else
  read -p "Please specify a server zip URL, forge or cauldron will work." SERVERZIP;
fi


echo "#### Downloading server files..."

cd working_directories/forge
curl -O $SERVERZIP
cd -

cd working_directories/packspecific/$packslug
curl -O $SPECIFICZIP
cd -

echo "#### Download completed!"
echo "#### Installing forge into server build directory..."

packseperator="_"
packboth=$packslug$packseperator$packversion

unzip working_directories/forge/*.zip -d working_directories/$packslug/$packversion
unzip working_directories/packspecific/$packslug/$packslug.zip -d working_directories/$packslug/$packversion

cd working_directories/$packslug/$packversion

zip -r ../../downloads/$packslug/$packboth.zip ./*

cd -

RSYNCURL="root@box.endermedia.com:/var/www/sites/solder.endermedia.com/TechnicSolder/public/repository/"

echo "#### Would you like to specify a custom RSYNC URL? If you don't know what this is, just answer no."
read -p " (y/n) " RESP
if [ "$RESP" = "n" ]; then
  echo "#### Using default RSYNC URL...";
else
  read -p "Please specify an RSYNC URL, you will be asked for the password next." RSYNCURL;
fi

rsync -azvr --progress working_directories/downloads $RSYNCURL