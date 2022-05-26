#!/bin/bash

# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# We do not want users to end up with a partially working install, so we exit the script
# instead of continuing the installation with something broken
set -e


viteToolsGitUrl="https://github.com/jaumebosch/vite-tools.git"

VITE_TOOLS_LOCAL_REPO="/root"


# If the color table file exists,
if [[ -f "${coltable}" ]]; then
    # source it
    source "${coltable}"
# Otherwise,
else
    # Set these values so the installer can still run in color
    COL_NC='\e[0m' # No Color
    COL_LIGHT_GREEN='\e[1;32m'
    COL_LIGHT_RED='\e[1;31m'
    TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
    CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
    INFO="[i]"
    # shellcheck disable=SC2034
    DONE="${COL_LIGHT_GREEN} done!${COL_NC}"
    OVER="\\r\\033[K"
fi


# A simple function that just echoes out VITE logo in ASCII format
show_ascii_logo() {
    echo -e "
        ${COL_LIGHT_GREEN}
                                                                                ,
                                                                    ,(@@@@@@@@. 
                                                         .(&@@@@@@@@@@@@@@@@*   
                                               *&@@@@@@@@@@@@@@@@@@@@@@@@@(     
                                     #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%       
                        .     ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&         
             .#&@@@@@@@@@     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&           
  .%@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             
 @@@@@@@@@@@@@@@@@@@@@@@&     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               
  @@@@@@@@@@@@@@@@@@@@@@%    #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
   @@@@@@@@@@@@@@@@@@@@@%    &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   
    @@@@@@@@@@@@@@@@@@@@(    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                    
     @@@@@@@@@@@@@@@@@@@,   ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@/                      
      @@@@@@@@@@@@@@@@@@.   &@@@@@@@@@@@@@@@@@@@@@@@@@@(                        
       @@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@%                          
        @@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@&                            
         @@@@@@@@@@@@@@@   (@@@@@@@@@@@@@@@@@@@@@@                              
          @@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@                                
           @@@@@@@@@@@@&   @@@@@@@@@@@@@@@@@@@                                  
            @@@@@@@@@@@%  ,@@@@@@@@@@@@@@@@@                                    
             @@@@@@@@@@#  @@@@@@@@@@@@@@@@                                      
              @@@@@@@@@#  @@@@@@@@@@@@@@,                                       
               @@@@@@@@* .@@@@@@@@@@@@*                                         
                @@@@@@@. (@@@@@@@@@@(                                           
                 @@@@@@  @@@@@@@@@%                                             
                  @@@@@  @@@@@@@&                                               
                   @@@@ *@@@@@@                                                 
                    @@@ @@@@@                                                   
                     @@ @@@                                                     
                      %,@                                                      ${COL_NC}
"
}

# Compatibility
package_manager_detect() {
    # First check to see if apt-get is installed.
    if is_command apt-get ; then
        apt install -y git 
    else
        # we cannot install required packages
        printf "  %b Only apt package manager is supported at this moment\\n" "${CROSS}"
        # so exit the installer
        exit
    fi
}

 #A function that combines the previous git functions to update or clone a repo
getGitFiles() {
    # Setup named variables for the git repos
    # We need the directory
    local directory="${1}"
    # as well as the repo URL
    local remoteRepo="${2}"
    # A local variable containing the message to be displayed
    local str="Check for existing repository in ${1}"
    # Show the message
    printf "  %b %s..." "${INFO}" "${str}"
    # Check if the directory is a repository
    if is_repo "${directory}"; then
        # Show that we're checking it
        printf "%b  %b %s\\n" "${OVER}" "${TICK}" "${str}"
        # Update the repo, returning an error message on failure
        update_repo "${directory}" || { printf "\\n  %b: Could not update local repository. Contact support.%b\\n" "${COL_LIGHT_RED}" "${COL_NC}"; exit 1; }
    # If it's not a .git repo,
    else
        # Show an error
        printf "%b  %b %s\\n" "${OVER}" "${CROSS}" "${str}"
        # Attempt to make the repository, showing an error on failure
        make_repo "${directory}" "${remoteRepo}" || { printf "\\n  %bError: Could not update local repository. Contact support.%b\\n" "${COL_LIGHT_RED}" "${COL_NC}"; exit 1; }
    fi
    echo ""
    # Success via one of the two branches, as the commands would exit if they failed.
    return 0
}


clone_or_update_repos() {
    getGitFiles ${VITE_TOOLS_LOCAL_REPO} ${viteToolsGitUrl} || \
    { printf "  %bUnable to clone %s into %s, unable to continue%b\\n" "${COL_LIGHT_RED}" "${piholeGitUrl}" "${PI_HOLE_LOCAL_REPO}" "${COL_NC}"; \
    exit 1; \
    }
}



main() {
    ######## FIRST CHECK ########
    # Must be root to install
    local str="Root user check"
    printf "\\n"

    # If the user's id is zero,
    if [[ "${EUID}" -eq 0 ]]; then
        # they are root and all is good
        printf "  %b %s\\n" "${TICK}" "${str}"
        # Show the VITE logo
        show_ascii_logo
    else
        # Otherwise, they do not have enough privileges, so let the user know
        printf "  %b %s\\n" "${INFO}" "${str}"
        printf "  %b %bScript called with non-root privileges%b\\n" "${INFO}" "${COL_LIGHT_RED}" "${COL_NC}"
        printf "      Vite-Tools requires elevated privileges to install and run\\n"
        printf "      Please check the installer for any concerns regarding this requirement\\n"
        printf "      Make sure to download this script from a trusted source\\n\\n"
        printf "  %b Sudo utility check" "${INFO}"

        # If the sudo command exists, try rerunning as admin
        if is_command sudo ; then
            printf "%b  %b Sudo utility check\\n" "${OVER}"  "${TICK}"

            # when run via curl piping
            if [[ "$0" == "bash" ]]; then
                # Download the install script and run it with admin rights
                exec curl -sSL https://raw.githubusercontent.com/vite-tools/master/automated%20install/install.sh | sudo bash "$@"
            else
                # when run via calling local bash script
                exec sudo bash "$0" "$@"
            fi

            exit $?
        else
            # Otherwise, tell the user they need to run the script as root, and bail
            printf "%b  %b Sudo utility check\\n" "${OVER}" "${CROSS}"
            printf "  %b Sudo is needed for the Vite Daemon\\n\\n" "${INFO}"
            printf "  %b %bPlease re-run this installer as root${COL_NC}\\n" "${INFO}" "${COL_LIGHT_RED}"
            exit 1
        fi
    fi

    # Check for supported package managers so that we may install dependencies
    package_manager_detect

     # Download or update the scripts by updating the appropriate git repos
    clone_or_update_repos
}

main
