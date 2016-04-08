#!/bin/bash

# #Configurations
# Clearer="###########################################################################################";
ApacheFolder="/var/www/html";
BuildAndDeployGit="https://github.com/bogdy2p/buildanddeploy.git";
BuildAndDeployFolder="buildanddeploy";
AmoranaFolder="amora_sec";
MagentoDeployScriptFolder="magento-deployscripts";
AmoranaGit="http://git.reea.net/reea/amorana.git";
MagentoDeployScriptsGit="https://github.com/AOEpeople/magento-deployscripts.git";
ArtifactsFolder="artifacts";
ApplyPhpPathInVendor="vendor/aoepeople/envsettingstool/apply.php";
InstallSHPathInVendor="vendor/aoepeople/magento-deployscripts/install.sh";

# ##############
#Cd into apache folder
cd $ApacheFolder;
ls;
echo $Clearer;

# ##############
#Grab current git folder for patched files.
git clone $BuildAndDeployGit $BuildAndDeployFolder
echo $Clearer;

# ##############
#Grab magento scripts into specific folder
git clone $MagentoDeployScriptsGit $MagentoDeployScriptFolder;
echo $Clearer;
# ##############
#Grab amorana project into specific folder
git clone $AmoranaGit $AmoranaFolder;
echo $Clearer;
# ##############
#Enter amorana folder
cd $AmoranaFolder;
echo $Clearer;

# ##############
#Install amorana project with composer
composer install;
echo $Clearer;
ls
echo $Clearer;
export BUILD_NUMBER=1 && ../magento-deployscripts/build.sh -f build-${BUILD_NUMBER}.tar.gz -b ${BUILD_NUMBER}
echo $Clearer;

cd $ArtifactsFolder;
echo $Clearer;

mkdir build1;
tar -xvzf build-1.tar.gz -C build1
echo $Clearer;
ls

# #################
# #Copy install.sh 

InstallFrom1=$ApacheFolder/$BuildAndDeployFolder/patched-files/install.sh;
InstallTo1=$ApacheFolder/$AmoranaFolder/$ArtifactsFolder/build1/$InstallSHPathInVendor;
cp $InstallFrom1 $InstallTo1;
echo "Copied Install.sh";

# #################
# #Copy apply.php

ApplyPhpFrom1=$ApacheFolder/$BuildAndDeployFolder/patched-files/apply.php;
ApplyPhpTo1=$ApacheFolder/$AmoranaFolder/$ArtifactsFolder/build1/$ApplyPhpPathInVendor;
cp $ApplyPhpFrom1 $ApplyPhpTo1;
echo "Copied Apply.php (Overwritten)";

# ################
# #Re-add to archives. (Maybe only first archive.)
rm build-1.tar.gz
echo "Removed build1TarGz";
sleep 1;

# #Enter build1 folder;
cd build1;
echo "Re-creating archive:";
sleep 1;

tar -zcvf ../build-1.tar.gz .; 

# ls
echo "Re-added to archive;";
sleep 2;

###################
#REMOVE TEMPORARY FO1LDER BUILD1
cd $ApacheFolder/$AmoranaFolder/$ArtifactsFolder;
rm -R build1;
sleep 1;

# ################
# #SSH To Live Server (Rsync?)
echo "SSH-ing with rsync to live server";
sh ~/deploy/rsyncbuild.sh;
sleep 1;

# ################
#Run export command on live server (Via SSH)
echo "Running export via ssh on live server";
sh ~/deploy/executedeploy.sh;
sleep 1;
echo "OK! ALL DONE !";