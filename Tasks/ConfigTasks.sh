#!/usr/bin/env bash

# Configuration Tasks

# Config - Updates the config file, and ensures the vault is encrypted.
Task::config(){
  : @desc "Creates or Updates the config file as necessary."
  : @param config_dir="settings"

  Task::logo
  Task::build

  highlight "Creating or Updating config file"
  mkdir -p settings/passwords
  [ -f ~/.homelabos_vault_pass ] || Task::generate_ansible_pass
  [ -f settings/vault.yml ] || cp config.yml.blank settings/vault.yml
  [ -f settings/config.yml ] || cp config.yml.blank settings/config.yml

  Task::run_docker ansible-playbook --extra-vars="@$_config_dir/config.yml" --extra-vars="@$_config_dir/vault.yml" -i config_inventory playbook.config.yml
  highlight "Encrypting Secrets in the Vault"
  Task::run_docker ansible-vault encrypt settings/vault.yml || true
  highlight "Configuration Complete"

}

#Show the Configuration settings for a given service
Task::show_config(){
  : @desc "Shows the configuration settings for the specified service"
  : @param service! "The name of the service. Use: service=serviceName"

  Task::run_docker yq r -C "settings/config.yml" $_service

}

# Resets the local settings
Task::config_reset() {
  : @desc "Resets the Configuration"
  Task::logo
  Task::build

  highlight "Reset Local Settings"
  echo "First we'll make a backup of your current settings in case you actually need them \n"
  mv settings settings.bak
  mkdir settings
  Task::config
}

# Set a configuration variable. Requires that you specify key=value pair where
# Key is equal to the configuration key you'd like to set, and the value represents what it will be set to.
Task::set(){
  : @desc "Set a configuration variable"
  : @param rest% "Configuration Key to set"

  Task::decrypt

  # ( set -o posix ; set )
  local key value
  key=(${!_rest[@]})
  value="${_rest[$key]}"

  # Try to figure out where key is defined
  FILE=settings/config.yml
  SETTING_VALUE=$(Task::run_docker yq r "$FILE" "$key" "$value")
  if [ -z ${SETTING_VALUE} ]; then
      FILE=settings/vault.yml
      SETTING_VALUE=$(Task::run_docker yq r "$FILE" "$key" "$value")
      if [ -z ${SETTING_VALUE} ]; then
          echo "Key does not exist in config.yml nor vault.yml."
          # Re-encrypt vault
          Task::encrypt
          exit 1
      fi
  fi

  colorize yellow "Found value in file: $FILE"

  colorize red "Old setting value: " ${SETTING_VALUE}
  # Setting the new value
  Task::run_docker yq w -i "$FILE" "$key" "$value"
  NEW_SETTING_VALUE=$(Task::run_docker yq r "$FILE" "$key" "$value")
  colorize green "New setting value: " ${NEW_SETTING_VALUE}

  Task::encrypt
}
