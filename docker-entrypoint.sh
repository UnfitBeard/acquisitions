#!/bin/sh

# This script runs as 'root' before the main application starts.
# Its purpose is to fix file permissions on volume-mounted directories.

# 1. Temporarily fix permissions for the volume mount.
# The volume mount from the host often overrides the user/group permissions
# set during the Docker build, leading to EACCES errors for the non-root user.
# We change ownership back to the 'nodejs' user (UID 1001).

echo "Running custom entrypoint script..."
echo "Fixing permissions on /app for non-root user (UID 1001)..."

# Ensure /app is owned by the nodejs user (UID 1001)
# Note: This is necessary because volume mounts override build-time chown.
chown -R 1001:1001 /app

echo "Permission fix complete. Starting application..."

# 2. Execute the main command as the 'nodejs' user (UID 1001).
# 'exec su-exec' ensures signals are passed correctly and switches user ID.
exec su-exec nodejs "$@"