require 'atk_toolbox'

if OS.is?(:mac)
  system("brew cask install xquartz")
  puts "You'll need xQuartz open so I'll open it for you"
  system("open -a XQuartz")
  system("/opt/X11/bin/xhost + $(ipconfig getifaddr en0)")
  
end