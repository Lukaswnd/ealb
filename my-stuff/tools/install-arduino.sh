#/bin/bash

source ./tools/config.sh

#
# CLONE/UPDATE ARDUINO
#
echo "Updating ESP32 Arduino... from '$AR_REPO_URL'"
if [ ! -d "$AR_COMPS/arduino" ]; then
	git clone $AR_REPO_URL "$AR_COMPS/arduino"
fi

if [ -z $AR_SOURCE_BRANCH ]; then
	if [ -n "$IDF_COMMIT" ]; then
		IDF_REF="$IDF_COMMIT"
	elif [ -n "$IDF_TAG" ]; then
		IDF_REF="$IDF_TAG"
	else
		IDF_REF="$IDF_BRANCH"
	fi
	set_ar_source_branch "git_branch_exists" "$AR_COMPS/arduino" "$IDF_REF"
fi

if [ "$AR_SOURCE_BRANCH" ]; then
	echo "AR_SOURCE_BRANCH='$AR_SOURCE_BRANCH'"
	git -C "$AR_COMPS/arduino" fetch --all && \
	git -C "$AR_COMPS/arduino" checkout -B "$AR_SOURCE_BRANCH" origin/"$AR_SOURCE_BRANCH" && 
	git -C "$AR_COMPS/arduino" pull --ff-only
fi
if [ $? -ne 0 ]; then exit 1; fi



# Remove unwanted directories
rm -rf "$AR_COMPS/arduino/docs" \
       "$AR_COMPS/arduino/idf_component_examples" \
       "$AR_COMPS/arduino/tests" \
       "$AR_COMPS/arduino/libraries/RainMaker" \
       "$AR_COMPS/arduino/libraries/Insights" \
	   "$AR_COMPS/arduino//libraries/PPP" \
	   "$AR_COMPS/arduino//libraries/WiFiProv" \
       "$AR_COMPS/arduino/libraries/ESP_SR" \
       "$AR_COMPS/arduino/libraries/TFLiteMicro"

if [ $? -ne 0 ]; then
    echo "Error removing directories"
    exit 1
fi

# Replace CMakeLists.txt and idf_component.yml
rm -rf "$AR_COMPS/arduino/CMakeLists.txt" "$AR_COMPS/arduino/idf_component.yml"

cp "$AR_ROOT/configs/CMakeLists.txt" "$AR_COMPS/arduino/CMakeLists.txt"
if [ $? -ne 0 ]; then
    echo "Error copying CMakeLists.txt"
    exit 1
fi

cp "$AR_ROOT/configs/idf_component.yml" "$AR_COMPS/arduino/idf_component.yml"
if [ $? -ne 0 ]; then
    echo "Error copying idf_component.yml"
    exit 1
fi
