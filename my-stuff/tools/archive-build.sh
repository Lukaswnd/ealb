#!/bin/bash

source ./tools/config.sh

IDF_COMMIT=$(git -C "$IDF_PATH" rev-parse --short HEAD || echo "")
IDF_BRANCH=$(git -C "$IDF_PATH" symbolic-ref --short HEAD || git -C "$IDF_PATH" tag --points-at HEAD || echo "")
idf_version_string=${IDF_BRANCH//\//_}"-$IDF_COMMIT"

archive_path="dist/arduino-esp32-libs-$1-$idf_version_string.tar.gz"
pio_zip_archive_build_path="/build.zip"
pio_zip_archive_libs_path="/libs.zip"
pio_zip_archive_path="/main.zip"

mkdir -p dist && rm -rf "$archive_path"
if [ -d "out" ]; then
	cd out && tar zcf "../$archive_path" * && cd ..
fi

cd out 
echo "Creating PioArduino framework-arduinoespressif32"
mkdir -p arduino-esp32/cores/esp32
mkdir -p arduino-esp32/tools/partitions
cp -rf ../components/arduino/tools arduino-esp32
cp -rf ../components/arduino/cores arduino-esp32
cp -rf ../components/arduino/libraries arduino-esp32
cp -rf ../components/arduino/variants arduino-esp32
cp -f ../components/arduino/CMa* arduino-esp32
cp -f ../components/arduino/idf* arduino-esp32
cp -f ../components/arduino/Kco* arduino-esp32
cp -f ../components/arduino/pac* arduino-esp32
rm -rf arduino-esp32/docs
rm -rf arduino-esp32/tests
rm -rf arduino-esp32/idf_component_examples
rm -rf arduino-esp32/libraries/RainMaker
rm -rf arduino-esp32/libraries/Insights
rm -rf arduino-esp32/libraries/SPIFFS
rm -rf arduino-esp32/libraries/PPP
rm -rf arduino-esp32/libraries/WiFiProv
rm -rf arduino-esp32/libraries/TFLiteMicro
rm -rf arduino-esp32/libraries/ESP_SR
rm -rf arduino-esp32/tools/esp32-arduino-libs
rm -rf arduino-esp32/tools/gen_insights_package.py
#rm -rf arduino-esp32/package.json

cp "$TOOLS_JSON_OUT/package.json" tools/esp32-arduino-libs/package.json
cp "$AR_ROOT/package.json" arduino-esp32/package.json
cp ../core_version.h arduino-esp32/cores/esp32/core_version.h
#cp -rf arduino-esp32/ main/
cp -rf tools/esp32-arduino-libs libs/
#cp -rf arduino-esp32/ fae32/


#cp -rf tools/esp32-arduino-libs arduino-esp32/tools/
## Use sed to replace the line
#sed -i '/^FRAMEWORK_LIBS_DIR = /c\FRAMEWORK_LIBS_DIR = join(FRAMEWORK_DIR, "tools", "esp32-arduino-libs")' "arduino-esp32/tools/pioarduino-build.py"
## Check if the sed command was successful
#if [ $? -eq 0 ]; then
#  echo "File updated successfully."
#else
#  echo "Failed to update the file."
#fi
#find "arduino-esp32/tools/esp32-arduino-libs" -type f -name "pioarduino-build.py" | while read -r FILE_PATH; do
#  # Use sed to replace the line
#  sed -i -e '/^FRAMEWORK_SDK_DIR = env.PioPlatform().get_package_dir(/,/^)/c\FRAMEWORK_SDK_DIR = join(FRAMEWORK_DIR, "tools", "esp32-arduino-libs")' "$FILE_PATH"

#  # Check if the sed command was successful
#  if [ $? -eq 0 ]; then
#    echo "File $FILE_PATH updated successfully."
#  else
#    echo "Failed to update the file $FILE_PATH."
#    exit 1
#  fi
#done

cp -rf arduino-esp32/ main/


cp -rf tools/esp32-arduino-libs arduino-esp32/tools/
cp -rf arduino-esp32/ build/

# If the framework is needed as tar.gz uncomment next line
# tar --exclude=.* -zcf ../$pio_archive_path framework-arduinoespressif32/
mkdir -p ../../dist
7z a -mx=9 -tzip -xr'!.*' ../../dist/$pio_zip_archive_build_path build/
7z a -mx=9 -tzip -xr'!.*' ../../dist/$pio_zip_archive_libs_path libs/
7z a -mx=9 -tzip -xr'!.*' ../../dist/$pio_zip_archive_path main/