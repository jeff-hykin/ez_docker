require 'atk_toolbox'

# TODO: code this: mac display variable: -e DISPLAY=$(ipconfig getifaddr en0):0



if OS.is?(:mac)
    if Console.yes?("Would you like to be able to run graphical tools from docker?\n(for example: matplotlib for python)")
        puts "Okay I'll need to install a few things then"
        if Console.yes?("do you mind if I explain whats happening?")
            puts "Docker creates GUI's using a thing called X11"
            puts "Mac doesn't have X11"
            puts ""
            puts "X11 needs to be installed"
            puts "X11 also needs to be actively running"
            puts "docker also needs to send other "
        end
        
        def start_docker_gui()
            # 
            # ensure xquartz is installed
            # 
            if not FS.is_folder("/Applications/Utilities/XQuartz.app")
                puts "    It appears you don't have XQuartz"
                puts "    (which is needed for docker GUI's)"
                puts "    so I'll install it for you"
                system("brew cask install xquartz")
                
                # TODO: check for error
                if not $?.success?
                    puts "\nWhen installing xquartz it seems there was an error".red
                    puts "Hopefully there is more information above to help figure out what went wrong"
                    exit 1
                end
                # copy over the xquartz settings
                FS.copy(from: Info.paths["xquartz_settings"], to: HOME/"Library/Preferences/", new_name: "org.macosforge.xquartz.X11.plist")
                
                # TODO: tell user to restart/log out
                Console.ok(<<-HEREDOC)
                    
                    
                    Sadly becase this installs a window server
                    #{"you'll need to fully log out and log back in".light_magenta}
                    Otherwise the docker GUI is going to result in errors
                HEREDOC
            end
            
            
            # 
            # ensure XQuartz is running
            # 
            processes_on_6000 = `lsof -i tcp:6000`.sub(/\A.+\n/, "").split("\n")
            # extract the name of the processes
            processes_on_6000.map! do |each|
                each.sub(/\A(\S+).+/,'\1')
            end
            
            # TODO: check if the port is in use for some reason
            has_data_socket_running = processes_on_6000.include?("socat")
            has_xquartz_running = processes_on_6000.include?("X11.bin")
            processes_on_6000.delete("socat")
            processes_on_6000.delete("X11.bin")
            
            starting_a_process_failed = false
            
            if not processes_on_6000.include?("socat")
                log "Starting the socat service (for any docker GUI apps)"
                system("socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\\\"$DISPLAY\\\" &")
                # check for failure
                starting_a_process_failed &&= $?.success?
            end
            
            # if xquartz isnt running
            if `ps aux | grep 'XQuartz\.app'`.size < 5 
                puts "Starting XQuartz, which might take a second but only needs to be done once"
                # copy over the xquartz settings encase they have been overwritten
                FS.copy(from: Info.paths["xquartz_settings"], to: HOME/"Library/Preferences/", new_name: "org.macosforge.xquartz.X11.plist")
                system("open -a XQuartz --hide")
                # check for failure
                starting_a_process_failed &&= $?.success?
            end
            
            # TODO: check if something else already running on that port
            if starting_a_process_failed && processes_on_6000.size > 0
                puts ""
            end
        end
        
    end
    
end