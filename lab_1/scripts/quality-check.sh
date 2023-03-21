#!/bin/bash

typeset appDir=../shop-angular-cloudfront

echo ">>>>> Starting quality check process: "

cd $appDir

echo "Running linting script: "
npm run lint
if [ $? == 1 ];then
  echo "" 
  echo ">>>>>>>>>>> Failed while running linting process"
else
  echo ""
  echo ">>>>>>>>>>> Linting process ran successfully"
fi

echo ""
echo "------------------------------"
echo "Running test script: "
npm run test
if [ $? == 1 ];then
  echo ""
  echo ">>>>>>>>>>> Failed while running the tests process"
else
  echo ""
  echo ">>>>>>>>>>> Test suite passed successfully"
fi

echo ""
echo "------------------------------"
echo "Running audit process: "
echo ""
npm audit



# echo "Stopping process id " $pid && kill -15 $pid
