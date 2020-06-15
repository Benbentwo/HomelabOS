#!/usr/bin/env bash

# Contains Tasks related to adding a new package to HomelabOS

# Use this task to walk through a wizard that helps you add a new package.
Task::add_package(){
  : @desc "Wizard to add a new package"

  colorize red "This isn't yet implemented"
}


# Task::add_package() {
#   : @desc "Wizard to add a new Package"

#   colorize green "This wizard will ask you a few questions and help you prototype the required changes to add a package"
#   read -p "What's the name of this package in Title Case? " package_name
#   read -p "What's a good URL for the package? " url
#   read -p "Enter a one-line-ish description for the packge? " description

#   nospaces="${package_name// /''}"
#   package_file_name=$( echo $nospaces | awk '{print tolower($0)}')
#   branch_name="Adds-${package_name// /-}"
#   Task::create_git_branch $branch_name

#   highlight "Creating role folder"
#   cp -R package_template/roles/template "roles/${package_file_name}"

#   highlight "Editing Role Tasks & Renaming docker-compose template"
#   search_and_replace_in_file 'pkgtemplate' $package_file_name "roles/$package_file_name/tasks/main.yml"
#   mv roles/$package_file_name/templates/docker-compose.template.yml.j2 roles/$package_file_name/templates/docker-compose.$package_file_name.yml.j2
#   search_and_replace_in_file 'PackageFileName' $package_file_name roles/$package_file_name/templates/docker-compose.$package_file_name.yml.j2

#   highlight "Copying Doc Template"
#   cp package_template/docs/software/template.md docs/software/$package_file_name.md

#   highlight "Editing Doc Template"
#   local template="docs/software/$package_file_name.md"

#   search_and_replace_in_file 'PackageURL' "$url" $template
#   search_and_replace_in_file 'PackageOneLiner' "$description" $template
#   search_and_replace_in_file 'PackageFileName' $package_file_name $template
#   search_and_replace_in_file 'PackageTitleCase' "$package_name" $template

#   highlight "Adding Docs to mkdocs.yml"

#   highlight "Adding Package to the group_vars/all file"
#   Task::run_docker yq w -i group_vars/all "services.$package_file_name" ''

#   #puts 'Step 7. Adding service to Readme.md'
#   highlight "Adding Service to Readme.md"

#   highlight "Adding service to Config Template"
#   # Create Template File for Merging
#   cat > package_template/tmpfile.yml <<EOL
# package_file_name:
#   enable: {{package_file_name.enable | default(enable_package_file_name, None) | default(False)}}
#   https_only: {{ package_file_name.https_only | default(False) }}
#   auth: {{ package_file_name.auth | default(False) }}
#   domain: {{ package_file_name.domain | default(False) }}
#   subdomain: {{ package_file_name.subdomain | default("package_file_name") }}
# EOL
#   # Edit the config tempfile
#   search_and_replace_in_file 'package_file_name' $package_file_name package_template/tmpfile.yml
#   # yq merge -i roles/homelabos_config/templates/config.yml tmpfile
#   Task::run_docker yq merge -i roles/homelabos_config/templates/config.yml package_template/tmpfile.yml
#   # Remove tmp file
#   rm package_template/tmpfile.yml

#   highlight "Adding service to Changelog"
# }

# Task::create_git_branch() {
#   git fetch
#   git checkout dev && git pull
#   git branch $1

#   git checkout $1
# }

# function search_and_replace_in_file(){
#   sed -i "s~$1~$2~g" $3
# }
