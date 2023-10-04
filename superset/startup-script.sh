#!/bin/bash

# Initialize the database
echo_step "1" "Starting" "Applying DB migrations"
superset db upgrade
echo_step "1" "Complete" "Applying DB migrations"

# Create an admin user
echo_step "2" "Starting" "Setting up admin user"
superset fab create-admin \
              --username ${SUPERSET_USERNAME} \
              --firstname ${SUPERSET_FIRSTNAME} \
              --lastname ${SUPERSET_LASTNAME} \
              --email ${SUPERSET_EMAIL} \
              --password ${SUPERSET_PASSWORD}
echo_step "2" "Complete" "Setting up admin user"
# Create default roles and permissions
echo_step "3" "Starting" "Setting up roles and perms"
superset init
echo_step "3" "Complete" "Setting up roles and perms"
