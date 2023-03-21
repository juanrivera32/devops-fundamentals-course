#!/bin/bash

# typeset packageJson=package.json
typeset appDir=../shop-angular-cloudfront
# typeset filePath=$appDir/$packageJson

clientZip=$appDir/dist/client-app.zip
if [ -f "$clientZip" ];then
  rm -rf $clientZip
  echo ">>>>>>>>> $clientZip removed"
fi

cd $appDir

echo "Installing dependencies ..."
npm install
echo "Dependencies installed"


echo "--------------------------"
echo "Starting the building process"
export ENV_CONFIGURATION=""
npm run build --configuration=$ENV_CONFIGURATION
echo "Build finished"

cd $appDir/dist

echo "--------------------------"
echo "Starting to compress the built content:"
tar -zcvf client-app.zip ./
echo "Content compressed successfully"

# number of files in dist
echo "---------------------------"
file_count=$(find . -type f | wc -l)
echo "The number of files availabe is: $file_count"
