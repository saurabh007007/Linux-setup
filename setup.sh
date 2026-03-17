#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_LIST_FILE="${SCRIPT_DIR}/common/applist.txt"
CASK_LIST_FILE="${SCRIPT_DIR}/common/casklist.txt"
SHELL_CONFIG_FILE="${HOME}/.zshrc"

print_banner() {
	cat <<'EOF'
 __  __    _    ____ ___  ____    ____  _____ _____ _   _ ____
|  \/  |  / \  / ___/ _ \/ ___|  / ___|| ____|_   _| | | |  _ \
| |\/| | / _ \| |  | | | \___ \  \___ \|  _|   | | | | | | |_) |
| |  | |/ ___ \ |__| |_| |___) |  ___) | |___  | | | |_| |  __/
|_|  |_/_/   \_\____\___/|____/  |____/|_____| |_|  \___/|_|

                by Saurabh
EOF
}

# Installing theh brew package manager
function install_brew(){
    echo "Installing Homebrew..."
   if [ -x "$(command -v brew)" ]; then
        echo "Homebrew is already installed."
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

}



function install_apps_from_list(){
    echo "Reading apps from ${APP_LIST_FILE}..."

    if [[ ! -f "${APP_LIST_FILE}" ]]; then
        echo "App list file not found: ${APP_LIST_FILE}"
        return 1
    fi

    while IFS= read -r app || [[ -n "${app}" ]]; do
        if [[ -z "${app}" || "${app}" == \#* ]]; then
            continue
        fi

        if brew list "${app}" >/dev/null 2>&1; then
            echo "${app} is already installed."
            continue
        fi

        echo "Installing ${app}..."
        brew install "${app}"
    done < "${APP_LIST_FILE}"
}

function install_casks_from_list(){
    echo "Reading casks from ${CASK_LIST_FILE}..."

    if [[ ! -f "${CASK_LIST_FILE}" ]]; then
        echo "Cask list file not found: ${CASK_LIST_FILE}"
        return 1
    fi

    while IFS= read -r cask || [[ -n "${cask}" ]]; do
        if [[ -z "${cask}" || "${cask}" == \#* ]]; then
            continue
        fi

        if brew list --cask "${cask}" >/dev/null 2>&1; then
            echo "${cask} is already installed."
            continue
        fi

        echo "Installing ${cask}..."
        brew install --cask "${cask}"
    done < "${CASK_LIST_FILE}"
}

function rust_install(){
    echo "Installing Rust..."
    if [ -x "$(command -v rustc)" ]; then
        echo "Rust is already installed."
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source "$HOME/.cargo/env"
    fi
}

function java_config(){
    local maven_prefix
    local gradle_prefix
    local block_start="# >>> macos-setup java >>>"
    local block_end="# <<< macos-setup java <<<"
    local temp_file

    echo "Configuring Java build tools..."

    if brew list maven >/dev/null 2>&1; then
        echo "maven is already installed."
    else
        echo "Installing maven..."
        brew install maven
    fi

    if brew list gradle >/dev/null 2>&1; then
        echo "gradle is already installed."
    else
        echo "Installing gradle..."
        brew install gradle
    fi

    maven_prefix="$(brew --prefix maven)"
    gradle_prefix="$(brew --prefix gradle)"

    mkdir -p "$(dirname "${SHELL_CONFIG_FILE}")"
    touch "${SHELL_CONFIG_FILE}"

    if grep -Fq "${block_start}" "${SHELL_CONFIG_FILE}"; then
        temp_file="$(mktemp)"
        awk -v start="${block_start}" -v end="${block_end}" '
            $0 == start { skip = 1; next }
            $0 == end { skip = 0; next }
            skip != 1 { print }
        ' "${SHELL_CONFIG_FILE}" > "${temp_file}"
        mv "${temp_file}" "${SHELL_CONFIG_FILE}"
    fi

    cat >> "${SHELL_CONFIG_FILE}" <<EOF

${block_start}
export MAVEN_HOME="${maven_prefix}/libexec"
export M2_HOME="${maven_prefix}/libexec"
export GRADLE_HOME="${gradle_prefix}/libexec"
export PATH="${maven_prefix}/bin:${gradle_prefix}/bin:\$PATH"
${block_end}
EOF

    export MAVEN_HOME="${maven_prefix}/libexec"
    export M2_HOME="${maven_prefix}/libexec"
    export GRADLE_HOME="${gradle_prefix}/libexec"
    export PATH="${maven_prefix}/bin:${gradle_prefix}/bin:${PATH}"

    echo "Java tool paths written to ${SHELL_CONFIG_FILE}"
    echo "Open a new terminal or run: source ${SHELL_CONFIG_FILE}"
}


main() {
	print_banner
	echo "Starting MacOS Setup..."
    install_brew
    install_apps_from_list
    install_casks_from_list
    rust_install
    java_config
    echo "MacOS Setup Completed!"
}

main "$@"