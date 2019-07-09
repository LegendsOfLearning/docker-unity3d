#!/bin/sh

IMPORTED_LIC="/tmp/Unity_lic.ulf"
MOUNTED_LIC="/Unity_lic.ulf"

mkdir -p "$HOME/.cache/unity3d"
mkdir -p "$HOME/.local/share/unity3d/Unity/"
if [ x"$UNITY_LICENSE_CONTENT" != x"" ]; then
  # Write $UNITY_LICENSE_CONTENT to license file
  # $HOME/.local/share/unity3d/Unity/Unity_lic.ulf
  #echo "$UNITY_LICENSE_CONTENT" | tr -d '\r' > "$HOME/.local/share/unity3d/Unity/Unity_lic.ulf"

  # Use Unity command line arg to import file
  echo "Loading license from UNITY_LICENSE_CONTENT"

  echo "$UNITY_LICENSE_CONTENT" | base64 -d | tr -d '\r' > ${IMPORTED_LIC}
  /opt/Unity/Editor/Unity -batchmode -nographics -manualLicenseFile ${IMPORTED_LIC}
elif [ -f ${MOUNTED_LIC} ]; then
    echo "Loading license from ${MOUNTED_LIC}"
    /opt/Unity/Editor/Unity -batchmode -nographics -manualLicenseFile ${MOUNTED_LIC}
else
    echo
    echo "UNITY_LICENSE_CONTENT not set. ${MOUNTED_LIC} not found"
    echo "Skipping loading license."
    echo
fi

exec "$@"
