#!/usr/bin/env bash

echo "Building for $BUILD_TARGET"

set -e
set -x

export BUILD_PATH=./Builds/$BUILD_TARGET/
mkdir -p $BUILD_PATH

# -projectPath ./ \
# -projectPath $(pwd) \

/opt/Unity/Editor/Unity \
    -batchmode \
    -nographics \
    -logFile - \
    -quit \
    -buildTarget $BUILD_TARGET \
    -customBuildTarget $BUILD_TARGET \
    -customBuildName $BUILD_NAME \
    -customBuildPath $BUILD_PATH \
    -customBuildOptions AcceptExternalModificationsToPlayer \
    -executeMethod BuildCommand.PerformBuild \

UNITY_EXIT_CODE=$?

if [ $UNITY_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $UNITY_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $UNITY_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $UNITY_EXIT_CODE";
fi

ls -la $BUILD_PATH
[ -n "$(ls -A $BUILD_PATH)" ] # fail job if build folder is empty
