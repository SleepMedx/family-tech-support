#!/bin/bash
# 2014-05-21
# Jacob Salmela

# Sets default apps for common filetypes
defaults delete ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers
	
# PDFS - Preview
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerContentType = "com.adobe.pdf"; LSHandlerRoleAll = "com.apple.Preview";}'
	
# HTTP - Chrome
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerURLScheme = "http"; LSHandlerRoleAll = "com.google.chrome";}'
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerURLScheme = "https"; LSHandlerRoleAll = "com.google.chrome";}'
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerURLScheme = "ftp"; LSHandlerRoleAll = "com.google.chrome";}'
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerContentType = "public.html"; LSHandlerRoleViewer = "com.google.chrome";}'
defaults write ~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerContentType = "public.html"; LSHandlerRoleAll = "com.google.chrome";}'
defaults write /~/Library/Preferences/com.apple.LaunchServices.plist LSHandlers -array-add '{LSHandlerContentType = "public.url"; LSHandlerRoleViewer = "com.google.chrome";}'
	
# Refresh the LaunchServices DB
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
