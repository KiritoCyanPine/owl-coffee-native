#
#  Makefile
#  owl-coffee-native
#
#  Created by Debasish Nandi on 26/06/25.
#

# ---- Configurable App Info ----
APP_NAME = Owl Coffee
APP_BUNDLE = Owl Coffee.app
APP_SCHEME = owl-coffee-native
APP_BUILD_DIR = ./build/Release
DMG_NAME = OwlCoffee.dmg
DIST_DIR = dist

# ---- Paths ----
APP_PATH = $(APP_BUILD_DIR)/$(APP_BUNDLE)
DMG_PATH = $(DIST_DIR)/$(DMG_NAME)

# ---- Default Target ----
all: dmg

# ---- Build the macOS App ----
app:
	xcodebuild -scheme $(APP_SCHEME) -configuration Release -arch x86_64 -arch arm64 CONFIGURATION_BUILD_DIR=$(APP_BUILD_DIR) build

# ---- Create .dmg using create-dmg ----
dmg: app
	mkdir -p $(DIST_DIR)
	
	which create-dmg | grep -o create-dmg > /dev/null &&  echo "create-dmg installed" || brew install create-dmg
	
	create-dmg \
		--volname "$(APP_NAME)" \
		--window-pos 200 120 \
		--window-size 500 300 \
		--icon-size 100 \
		--icon "$(APP_BUNDLE)" 125 150 \
		--hide-extension "$(APP_BUNDLE)" \
		--app-drop-link 375 150 \
		"$(DMG_PATH)" \
		"$(APP_BUILD_DIR)"

# ---- Clean ----
clean:
	rm -rf build
	rm -rf $(DIST_DIR)
