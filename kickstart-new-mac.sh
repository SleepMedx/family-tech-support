#!/bin/bash
# http://lifehacker.com/how-to-make-your-own-bulk-app-installer-for-os-x-1586252163

#----------VARIABLES---------
	# Change the variables below per your environment
	adminUser=$(whoami)
	orgName="com.jacobsalmela.scripts"
	loginWindowText=$(hostname)
	osVersion=$(sw_vers -productVersion | awk -F. '{print $2}')
    	swVersion=$(sw_vers -productVersion)

#----------FUNCTIONS---------
###############################################
function enableAccessiblityAndInstallXcodeCLT()
	{
	# Add ARDAgent.app to the Accessibility DB, allowing it access to click buttons and type keystrokes
	sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','com.apple.RemoteDesktopAgent',0,1,1,NULL);"
	
	# Trigger the install of Xcode command line tools--required for homebrew stuff
	xcode-select --install
	
	# Click buttons on behalf of the user
	osascript -e <<EOF 'tell application "System Events"
    	tell process "Install Command Line Developer Tools"
        click button "Install" of window 1
    	end tell
	end tell'EOF
	
	#osascript -e <<EOF 'tell application "System Events"
    	#tell process "Install Command Line Developer Tools"
        #click button "Agree" of window "License Agreement"
    	#end tell
	#end tell'
	EOF	
	}
	
###############################
function installEssentialApps()
	{
	# Install homebrew and update
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	brew update
	brew tap caskroom/cask
	brew install caskroom/cask/brew-cask
	
	# Install better browsers
	brew cask install google-chrome
	brew cask install firefox
	
	# Backup and syncing
	brew cask install crashplan
	brew cask install dropbox
	
	# Password and bookmark managements
	brew cask install lastpass-universal
	
	# OS improvements
	brew cask install totalfinder
	brew cask install totalterminal
	brew cask install deathtodsstore
	
	}

###########################
function quickLookPlugins()
	{
	# QuickLook Enhancements
	brew cask install qlcolorcode
	brew cask install qlimagesize
	brew cask install qlmarkdown
	brew cask install qlprettypatch
	brew cask install qlrest
	brew cask install qlstephen
	brew cask install quicklook-csv
	brew cask install quicklook-json
	brew cask install quicklook-pfm
	
	# ScriptQL QuickLook Plugin
	curl -o ~/Downloads/ScriptQL_qlgenerator.zip http://www.kainjow.com/downloads/ScriptQL_qlgenerator.zip 
	unzip ~/Downloads/ScriptQL_qlgenerator.zip
	rm ~/Downloads/ScriptQL_qlgenerator.zip

	# SuspiciousPackage QuickLook Plugin
	curl -o ~/Downloads/SuspiciousPackage.dmg http://www.mothersruin.com/software/downloads/SuspiciousPackage.dmg
	hdiutil mount ì/Downloads/SuspiciousPackage.dmg
	cp -R /Volumes/Suspicious\ Package/Suspicious\ Package.qlgenerator/ ~/Library/QuickLook/Suspicious\ Package.qlgenerator
	umount /Volumes/Suspicious\ Package/
	rm ~/Downloads/SuspiciousPackage.dmg

	# Archive QuickLook Plugin
	curl -o ~/Downloads/Archive.zip http://www.qlplugins.com/sites/default/files/plugins/Archive.zip
	unzip ~/Downloads/Archive.zip
	mv ~/Downloads/Archive/Archive.qlgenerator ~/Library/QuickLook/Archive.qlgenerator
	rm -rf ~/Downloads/Archive
	rm ~/Downloads/Archive.zip

	# QLEnscript QuickLook Plugin
	curl -o ~/Downloads/QLEnscript.qlgenerator-1.0.zip http://www.qlplugins.com/sites/default/files/plugins/QLEnscript.qlgenerator-1.0.zip
	unzip ~/Downloads/QLEnscript.qlgenerator-1.0.zip
	mv ~/Downloads/QLEnscript.qlgenerator ~/Library/QuickLook/
	rm ~/Downloads/QLEnscript.qlgenerator-1.0.zip
	}

##########################
function systemSettings()
	{
    	echo "******Deploying system-wide settings******"
    
	echo -e "\tEnabling access to assistive devices..."
	case ${OSTYPE} in
		darwin10*) touch /private/var/db/.AccessibilityAPIEnabled;;
 		darwin11*) touch /private/var/db/.AccessibilityAPIEnabled;;
 		darwin12*) touch /private/var/db/.AccessibilityAPIEnabled;;
 		darwin13*) sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceAccessibility','/usr/bin/osascript',0,1,1,NULL);";;
 	esac

	echo -e "\tDisabling prompt to use drives for Time Machine..."
    	defaults write /Library/Preferences/com.apple.TimeMachine.plist DoNotOfferNewDisksForBackup -bool true
    
    	echo -e "\tDisabling external accounts..."
    	# Disable external accounts (i.e. accounts stored on drives other than the boot drive.)
    	defaults write /Library/Preferences/com.apple.loginwindow.plist EnableExternalAccounts -bool false

	echo -e "\tAdding information to login window..."
	defaults write /Library/Preferences/com.apple.loginwindow.plist AdminHostInfo HostName

	echo -e "\tSetting a login banner that reads: $loginWindowText..."
	defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText "$loginWindowText"

	echo -e "\tExpanding the print dialog by default..."
	defaults write /Library/Preferences/.GlobalPreferences.plist PMPrintingExpandedStateForPrint -bool true
	defaults write /Library/Preferences/.GlobalPreferences.plist PMPrintingExpandedStateForPrint2 -bool true

	echo -e "\tExpanding the save dialog by default..."
	defaults write /Library/Preferences/.GlobalPreferences.plist NSNavPanelExpandedStateForSaveMode -bool true
	defaults write /Library/Preferences/.GlobalPreferences.plist NSNavPanelExpandedStateForSaveMode2 -bool true

	echo -e "\tEnabling full keyboard access..."
	# Enable full keyboard access (tab through all GUI buttons and fields, not just text boxes and lists)
	defaults write /Library/Preferences/.GlobalPreferences.plist AppleKeyboardUIMode -int 3
	
	echo -e "\tSpeeding up the shutdown delay..."
	defaults write /System/Library/LaunchDaemons/com.apple.coreservices.appleevents.plist ExitTimeOut -int 5
	defaults write /System/Library/LaunchDaemons/com.apple.securityd.plist ExitTimeOut -int 5
	defaults write /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist ExitTimeOut -int 5
	defaults write /System/Library/LaunchDaemons/com.apple.diskarbitrationd.plist ExitTimeOut -int 5
	defaults write /System/Library/LaunchAgents/com.apple.coreservices.appleid.authentication.plist ExitTimeOut -int 5
	
	echo -e "\tDisabling Spotlight indexing on /Volumes..."
	defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
	
	echo -e "\tDisabling smart-quotes and smart-dashes..."
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	
	echo -e "\tMaking scrollbars always visible..."
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
	
	echo -e "\tDisabling crash report dialogs..."
	defaults write com.apple.CrashReporter DialogType none
	
	echo -e "\tEnabling secure virtual memory..."
	sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool yes
	
	echo -e "\tSetting time to 24-hour..."
	defaults write NSGlobalDomain AppleICUForce12HourTime -bool false
	}
	
#########################
function finderSettings()
	{
	# Case is different in finder plist starting in 10.9
	case ${OSTYPE} in
		darwin10*) finderCase="Finder";;
 		darwin11*) finderCase="Finder";;
 		darwin12*) finderCase="Finder";;
 		darwin13*) finderCase="finder";;
 	esac
	
	echo "******Deploying Finder settings******"
		
	echo "**---------------FINDER--------"
			
	echo -e "\tSetting home folder as the default location for new Finder windows..."
	defaults write com.apple.$finderCase NewWindowTarget -string "PfLo"
	defaults write com.apple.$finderCase NewWindowTargetPath -string "file://${HOME}/"

	echo -e "\tShowing Hard Drives on Desktop..."
	defaults -currentHost write com.apple.$finderCase ShowHardDrivesOnDesktop -bool YES
	echo -e "\tShowing External Hard Drives on Desktop..."
	defaults -currentHost write com.apple.$finderCase ShowExternalHardDrivesOnDesktop -bool YES
	echo -e "\tShowing Servers on Desktop..."
	defaults -currentHost write com.apple.$finderCase ShowMountedServersOnDesktop -bool YES
	echo -e "\tShowing removeable media on Desktop..."
	defaults -currentHost write com.apple.$finderCase ShowRemovableMediaOnDesktop -bool YES
	
	echo -e "\tSetting Finder to column view..."
	defaults write com.apple.$finderCase FXPreferredViewStyle -string "clmv"

	echo -e "\tSetting Finder to search the current folder..."
	defaults write com.apple.$finderCase FXDefaultSearchScope -string "SCcf"

	echo -e "\tShowing status bar..."
	defaults write com.apple.$finderCase ShowStatusBar -bool true

	echo -e "\tShowing path bar..."
	defaults write com.apple.$finderCase ShowPathbar -bool true

	echo -e "\tShowing POSIX path bar..."
	defaults write com.apple.$finderCase _FXShowPosixPathInTitle -bool true

	echo -e "\tEnabling QuickLook text-selection..."
	defaults write com.apple.$finderCase QLEnableTextSelection -bool TRUE

	echo -e "\tEnabling QuickLook x-ray vision..."
	defaults write com.apple.$finderCase QLEnableXRayFolders -bool true

	echo -e "\tMaking Finder animations faster..."
	defaults write com.apple.$finderCase DisableAllAnimations -bool true

	echo -e "\tShowing all file extensions..."
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
		
	# Expand the following File Info panes:
	echo -e "\tShowing General, Open with, and Sharing & Permissions on the Get Info window..."
	defaults write com.apple.$finderCase FXInfoPanesExpanded -dict \
		General -bool true \
		OpenWith -bool true \
		Privileges -bool true
	
	echo -e "\tDeath to network .DS_Stores..."
	defaults write com.apple.desktopservices DSDontWriteNetworkStores true
	
	echo -e "\tMaking window animations faster..."
	defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
	defaults write com.apple.finder DisableAllAnimations -bool true

	echo -e "\tMaking QuickLook anitmation faster..."
	defaults write -g QLPanelAnimationDuration -float 0
	
	echo -e "\tMaking the ~/Library folder visible for $adminUser..."
	su "$adminUser" -c "chflags nohidden ~/Library/"
	}
	
#######################	
function dockSettings()
	{
	echo "******Deploying Dock settings******"

	echo "**---------------DOCK--------"
		
	echo -e "\tMaking spaces static..."
	defaults write com.apple.dock mru-spaces -bool false

	echo -e "\tMaking hidden apps translucent..."
	defaults write com.apple.dock showhidden -bool true

	echo -e "\tRemoving dock auto hide delay..."
	defaults write com.apple.dock autohide-delay -float 0
	
	echo -e "\tMaking dock faster..."
	defaults write com.apple.dock autohide-time-modifier -float 0

	echo -e "\tMaking Mission Control faster..."
	defaults write com.apple.dock expose-animation-duration -float 0
	
	echo -e "\tEnabling spring-loading for all dock apps..."
	defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
		
	echo -e "\tMaking maximize/minimize to scale mode..."
	defaults write com.apple.dock mineffect -string "scale"


	echo -e "\tSetting top-left corner to Mission Control..."
	defaults write com.apple.dock wvous-tl-corner -int 2		# Mission Control
	defaults write com.apple.dock wvous-tl-modifier -int 0

	echo -e "\tSetting top-right corner to Notification Center..."
	defaults write com.apple.dock wvous-tr-corner -int 12		# Notification Center
	defaults write com.apple.dock wvous-tr-modifier -int 0

	echo -e "\tSetting bottom-left corner to Show Desktop..."
	defaults write com.apple.dock wvous-bl-corner -int 4		# Show Desktop
	defaults write com.apple.dock wvous-bl-modifier -int 0

	echo -e "\tSetting bottom-right corner to Launchpad..."
	defaults write com.apple.dock wvous-br-corner -int 11		# Launchpad
	defaults write com.apple.dock wvous-br-modifier -int 0
		
	echo -e "\tDisabling Dashboard..."
	defaults write com.apple.dashboard mcx-disabled -boolean YES
	}
		
########################
function otherSettings()
	{
	echo "******Deploying misc. settings******"
	
	echo "**------------MISC---------"

	echo -e "\tIncreasing mouse tracking to 3..."
	defaults write -g com.apple.mouse.scaling -float 3

	echo -e "\tIncreasing trackpad tracking to 3..."
	defaults write -g com.apple.trackpad.scaling -int 3
	
	echo -e "\tDisabling volume change feedback..."
	defaults write -g com.apple.sound.beep.feedback -int 0

	echo -e "\tEnabling Airdrop over Ethernet..."
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

	echo -e "\tImproving bash history..."
	echo "HISTTIMEFORMAT="%Y-%m-%d %T"" > ~/.bash_profile
	echo "HISTFILESIZE=65535" >> ~/.bash_profile
	echo "export PROMPT_COMMAND='history -a'" >> ~/.bash_profile

	echo -e "\tMaking Safari search banners using Contains instead of Starts With..."
	defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
		
	echo -e "\tSetting default Safari Webpage..."
	defaults write com.apple.Safari HomePage -string "http://jacobsalmela.com"
	
	echo -e "\tIncreasing sound quality of Bluetooth and headphones..."
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
	
	echo -e "\tDisabling iCloud as the default save location..."
	defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
	
	echo -e "\tMaking the scroll dragging speed faster..."
	defaults write -g NSAutoscrollResponseMultiplier -float 3
	}

##################################
function activityMonitorSettings()
	{
	echo "******Deploying Activity Monitor settings******"
	
	echo "**------------ACTIVITY MONITOR---------"

	echo -e "\tSetting the Dock icon to show CPU usage..."
	defaults write com.apple.ActivityMonitor IconType -int 5

	echo -e "\tShowing all processes by default..."
	defaults write com.apple.ActivityMonitor ShowCategory -int 100
	
	echo -e "\tMavericks: Adding the % CPU column to the Disk and Network tabs..."
	defaults write com.apple.ActivityMonitor "UserColumnsPerTab v4.0" -dict \
	    '0' '( Command, CPUUsage, CPUTime, Threads, IdleWakeUps, PID, UID )' \
	    '1' '( Command, anonymousMemory, Threads, Ports, PID, UID, ResidentSize )' \
	    '2' '( Command, PowerScore, 12HRPower, AppSleep, graphicCard, UID )' \
	    '3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID, CPUUsage )' \
	    '4' '( Command, txBytes, rxBytes, txPackets, rxPackets, PID, UID, CPUUsage )'

	echo -e "\tMavericks: Sort by CPU usage in Disk and Network tabs..."
	defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
	    '0' '{ direction = 0; sort = CPUUsage; }' \
	    '1' '{ direction = 0; sort = ResidentSize; }' \
	    '2' '{ direction = 0; sort = 12HRPower; }' \
	    '3' '{ direction = 0; sort = CPUUsage; }' \
	    '4' '{ direction = 0; sort = CPUUsage; }'	
	}

#########################	
function safariSettings()
	{
	echo "******Deploying Safari settings******"
	
	echo "**------------SAFARI---------"
	
	echo -e "\tShowing status bar..."	
	defaults write com.apple.Safari ShowStatusBar -bool true

	echo -e "\Enabling favorites bar..."
	defaults write com.apple.Safari ShowFavoritesBar -bool true	
	}
	
######################
function customPlist()
	{
	echo "******Writing to $orgName.plist******"
	
	# Creates a custom plist
	defaults write /Library/Preferences/"$orgName" KickstartDeployed -bool true
	}

#------------------------------		
#-------BEGIN SCRIPT-----------
#------------------------------	
sudo -v
enableAccessiblityAndInstallXcodeCLT
installEssentialApps
quickLookPlugins
systemSettings
finderSettings
dockSettings
activityMonitorSettings
safariSettings
otherSettings
powerSettings
customPlist
echo "******COMPLETE******"
