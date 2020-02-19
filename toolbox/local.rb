require 'atk_toolbox'

# 
# setup variables
# 
$info = Info.new # load the info.yaml
$paths = $info.paths

project_dir = nil
containerizer_info = nil
folder_for_executables = nil
folder_with_dockerfiles = nil
command_info = nil
begin
    project_dir = $info.folder
    containerizer_info = $info['containerizer']
    folder_for_executables = project_dir/containerizer_info['folder_for_executables']
    folder_with_dockerfiles = project_dir/containerizer_info['folder_with_dockerfiles']
    command_info = containerizer_info['commands']
rescue => exception
    
end

if !( project_dir && containerizer_info && folder_for_executables && folder_with_dockerfiles && command_info )
    raise <<-HEREDOC.remove_indent
        
        
        I think the containerizer_info inside the yaml file isn't formatted correctly
        Here's an example of how it should be formatted:
        
        containerizer:
            folder_for_executables: ./project_bin
            folder_with_dockerfiles: ./project_bin/dockerfiles
            commands:
                python:
                    - use_dockerfile: main
                    - --entrypoint: /usr/bin/python3
    HEREDOC
end



# 
# todo:
# 
    # build
    # destroy
    # run
    # stop
    # edit
    # export
    # import