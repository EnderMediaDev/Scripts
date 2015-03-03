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
mkdir working_directories/cauldron

#Copy files from launcher instance

cp -av ~/Library/Application\ Support/technic/modpacks/$packslug/mods working_directories/$packslug/$packversion
cp -av ~/Library/Application\ Support/technic/modpacks/$packslug/config working_directories/$packslug/$packversion

#Cleanup client mods

rm -f working_directories/$packslug/$packversion/mods/*-client*
rm -f working_directories/$packslug/$packversion/mods/1.7.10/*-client*

#Fetch specified cauldron package
SERVERZIP="http://solder.endermedia.com/repository/internal/cauldron.zip"
echo "#### Would you like to specify a custom cauldron.zip URL?"
read -p " (y/n) " RESP
if [ "$RESP" = "n" ]; then
  echo "#### We will use our file instead, consider yourself lucky, we have killer internet.";
else
  read -p "Please specify a server zip URL, cauldron preferred." SERVERZIP;
fi


echo "#### Downloading server files..."

cd working_directories/cauldron
curl -O $SERVERZIP
cd -

echo "#### Download completed!"
echo "#### Installing cauldron into server build directory..."

