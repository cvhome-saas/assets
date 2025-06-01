#!/bin/bash

# Check if running as root
if [ $(id -u) -ne 0 ]; then
  echo "Please run this script as root or using sudo!"
  exit 1 # It's good practice to exit with a non-zero status on error
fi

# --- Configuration ---
readonly APP_VERSION="latest" # Define the application version here
readonly DOCKER_COMPOSE_URL="https://raw.githubusercontent.com/cvhome-saas/assets/refs/heads/main/fast-run/docker-compose.yml"
readonly DOCKER_COMPOSE_FILE="docker-compose.yml" # Define filename for docker-compose

# --- Functions ---

# Appends a line to a file if it doesn't already exist.
# Arguments:
#   $1: The text to append.
#   $2: The file to append to.
function append_if_not_exists() {
    local text="$1"
    local file="$2"
    if grep -qF -- "$text" "$file"; then # -q for quiet, -F for fixed string (safer), -- to handle text starting with -
      echo "Info: '$text' already exists in '$file'." >&2 # Send info to stderr
    else
      echo -e "\n$text" | sudo tee -a "$file" > /dev/null # tee already handles sudo, no need for sudo before echo
      echo "Info: Appended '$text' to '$file'." >&2
    fi
}

# Configures /etc/hosts entries.
function configure_hosts_file() {
    local file="/etc/hosts"
    echo "Info: Configuring '$file'..." >&2
    append_if_not_exists "127.0.0.1 gateway.com" "$file"
    append_if_not_exists "127.0.0.1 www.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 core-auth.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 store-ui.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 welcome-ui.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 store-pod-1.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 merchant-ui.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 org1-store1.store-pod-saas-gateway-1.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 org1-store2.store-pod-saas-gateway-1.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 org2-store1.store-pod-saas-gateway-1.gateway.com" "$file"
    append_if_not_exists "127.0.0.1 org2-store2.store-pod-saas-gateway-1.gateway.com" "$file"
}

# Pulls necessary Docker images.
function pull_docker_images() {
  echo "Info: Pulling Docker images..." >&2
  docker pull rabbitmq:4.0.2-management
  docker pull postgres:15-alpine
  docker pull bitnami/minio
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/core-auth:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/merchant:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/content:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/catalog:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/order:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/landing-ui:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/merchant-ui:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/store-pod-gateway:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-pod/store-pod-saas-gateway:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/manager:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/subscription:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/store-ui:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/welcome-ui:${APP_VERSION}"
  docker pull "public.ecr.aws/g0a5h6c1/1691275173/store-core/store-core-gateway:${APP_VERSION}"
}

# --- Main Execution ---
echo "Starting Fast Run setup..."

configure_hosts_file
pull_docker_images

echo "Info: Downloading Docker Compose file from ${DOCKER_COMPOSE_URL}..." >&2
if wget -O "${DOCKER_COMPOSE_FILE}" "${DOCKER_COMPOSE_URL}"; then
  echo "Info: Docker Compose file downloaded successfully." >&2
  echo "Info: Starting Docker Compose services..." >&2
  docker compose -f "${DOCKER_COMPOSE_FILE}" up
else
  echo "Error: Failed to download Docker Compose file from ${DOCKER_COMPOSE_URL}." >&2
  exit 1
fi

echo "Fast Run setup finished."