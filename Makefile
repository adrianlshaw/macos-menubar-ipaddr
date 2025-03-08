PROJECT_NAME = WiFiStatusBar
SCHEME = WiFiStatusBar
CONFIGURATION = Release
BUILD_DIR = build
XCODE_PROJECT = $(PROJECT_NAME).xcodeproj

.PHONY: all build clean install run

all: build

build:
	swift build -c release
	mkdir -p .build/release/WiFiStatusBar.app/Contents/MacOS
	mkdir -p .build/release/WiFiStatusBar.app/Contents/Resources
	cp .build/release/WiFiStatusBar .build/release/WiFiStatusBar.app/Contents/MacOS/
	cp src/WiFiStatusBar/Info.plist .build/release/WiFiStatusBar.app/Contents/
	@if [ -d "Assets.xcassets" ]; then \
		cp -r Assets.xcassets .build/release/WiFiStatusBar.app/Contents/Resources/; \
	fi

install: build
	@echo "Installing to Applications..."
	@cp -R .build/release/$(SCHEME).app /Applications/

clean:
	swift package clean

run:
	open .build/release/$(SCHEME).app 

