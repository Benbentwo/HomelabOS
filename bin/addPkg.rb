#!/usr/bin/env ruby
# rubocop:disable all
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup
require 'psych'
require 'fileutils'
require 'gitlab'
require 'pry'

gitlab_token = ENV['GITLAB_TOKEN'] || false
HOMELABOS_PROJECT_ID = 6_853_087
if gitlab_token
  gl = Gitlab.client(endpoint: 'https://gitlab.com/api/v4', private_token: gitlab_token)
end

@branch_name = ''
@iid = 0

puts 'Step 0. Gathering Info'
puts 'Enter the package name in title case: '
unsafe_package_name = gets
package_name = unsafe_package_name.chomp
package_file_name = package_name.downcase.gsub(/ /, '')
puts 'Enter the Package URL: '
unsafe_package_url = gets
package_url = unsafe_package_url.chomp
puts 'Enter one-liner package description: '
unsafe_package_one_liner = gets
package_one_liner = unsafe_package_one_liner.chomp

if gl
  puts 'Creating gitlab issue'
  begin
    issue_result = gl.create_issue(HOMELABOS_PROJECT_ID,
                  "Add #{package_name}",
                  :description => "Please add #{package_name}",
                  :labels => 'package', :assignee_id => gl.user.id)
    @branch_name = "#{issue_result.iid}-#{package_name.gsub(/ /, '-')}"
    if issue_result.iid
      @iid = issue_result.iid
      branch_result = gl.create_branch(HOMELABOS_PROJECT_ID,
                                        @branch_name,
                                        'HEAD')
      if !branch_result.nil?
        mr_result = gl.create_merge_request(HOMELABOS_PROJECT_ID,
                                  "WIP: Resolve \"#{issue_result.title}\"",
                                  :source_branch => @branch_name,
                                  :target_branch => 'dev')
      end
    end
  rescue
    puts 'Gitlab returned an error, working in offline mode'
  ensure
    @branch_name ||= "Adds-#{package_name.gsub(/ /, '-')}"
    `git fetch`
    `git checkout dev`
    `git branch #{@branch_name}`
  end
end

`git fetch`
`git checkout #{@branch_name}`

puts 'Step 1. Creating role folder'
FileUtils.copy_entry 'package_template/roles/template', "roles/#{package_file_name}"
puts 'Done!'

puts 'Step 2. Editing role tasks and renaming docker-compose template'
search_and_replace_in_file("roles/#{package_file_name}/tasks/main.yml", 'pkgtemplate', package_file_name)
FileUtils.mv "roles/#{package_file_name}/templates/docker-compose.template.yml.j2", "roles/#{package_file_name}/templates/docker-compose.#{package_file_name}.yml.j2"
search_and_replace_in_file("roles/#{package_file_name}/templates/docker-compose.#{package_file_name}.yml.j2", 'PackageFileName', package_file_name)
`git add roles/#{package_file_name}`
puts 'Done!'

puts 'Step 3. Copying doc template'
FileUtils.copy_entry 'package_template/docs/software/template.md', "docs/software/#{package_file_name}.md"
puts 'Done!'

puts 'Step 4. Editing doc file'
search_and_replace_in_file("docs/software/#{package_file_name}.md", 'PackageURL', package_url.to_s)
search_and_replace_in_file("docs/software/#{package_file_name}.md", 'PackageOneLiner', package_one_liner.to_s)
search_and_replace_in_file("docs/software/#{package_file_name}.md", 'PackageFileName', package_file_name.to_s)
search_and_replace_in_file("docs/software/#{package_file_name}.md", 'PackageTitleCase', package_name.to_s)
`git add docs/software/#{package_file_name}.md`
puts 'Done!'

puts 'Step 5. Adding docs to mkdocs.yml'
# 'nav', 4, 'Included Software'
add_to_array_at_key('mkdocs.yml', ['nav', 6, 'Included Software', 16, 'Misc/Other'], { package_name.to_s => "software/#{package_file_name}.md" })
`git add mkdocs.yml`
puts 'Done!'

puts 'Step 6. Adding service to Inventory file'
add_to_hash_at_key('group_vars/all', ['services'], { package_file_name.to_s => nil })
insert_service_name_into_group_vars_second_instance(package_file_name)
`git add group_vars/all`
puts 'Done!'

puts 'Step 7. Adding service to Readme.md'
insert_in_config 'README.md', '## Available Software', "- [#{package_name}](#{package_url}) - #{package_one_liner}"
`git add README.md`
puts 'Done!'

puts 'Step 8. Adding service to Config Template'
insert_new_service_in_config_template 'roles/homelabos_config/templates/config.yml', package_file_name # to_insert
`git add roles/homelabos_config/templates/config.yml`
puts 'Done!'

puts 'Step 9. Adding service to Changelog'
insert_in_config 'CHANGELOG.md', '#', "- Added #{package_name} - #{package_one_liner}"
`git add CHANGELOG.md`
puts 'Done!'

puts <<-FINAL

Two things:
1. This script places the docs page in the misc/other section.
    Please edit mkdocs.yml to place this package in the appropriate section.
2. Please Don't forget to edit the docker-compose file
FINAL
# puts "\n\nAll files added by this script, with the exception of the docker-compose file have been staged in git."

# Helper Methods
BEGIN {
  def search_and_replace_in_file(filepath, search_for, replace_with)
    begin
      IO.write(filepath, File.open(filepath) do |f|
        f.read.gsub(search_for, replace_with)
      end)
    rescue
      p 'Failed to execute sarch and replace in file'
    end
  end

  def add_to_array_at_key(ymlfile, key, to_append)
    begin
      yml = Psych.load_file ymlfile
      yml.dig(*key) << to_append
      File.write ymlfile, Psych.dump(yml)
    rescue
      p "Failed to add to array at key: #{ymlfile}, #{key}, #{to_append}"
    end
  end

  def add_to_hash_at_key(ymlfile, key, to_append)
    begin
      yml = Psych.load_file ymlfile
      yml.dig(*key).merge!(to_append)
      yml[key.first] = yml[key.first].sort.to_h
      File.write ymlfile, Psych.dump(yml)
    rescue
      p "Failed to add to hash at key: #{ymlfile}, #{key}, #{to_append}"
    end
  end

  def get_array_of_services
    yml = Psych.load_file 'group_vars/all'
    yml['services']
  end

  def find_name_index_for_next_service(to_add)
    ordered = get_array_of_services.keys
    ordered.push to_add
    index = ordered.sort.find_index(to_add)
    ordered[index+1]
  end

  def insert_service_name_into_group_vars_second_instance(to_insert)
    next_name = find_name_index_for_next_service to_insert
    service_name = to_insert + ':'
    filename = 'group_vars/all'
    lines = File.readlines filename
    first_instance_found = false
    lines.dup.each_with_index do |line, index|
      next unless line.strip == "#{next_name}:"
      if first_instance_found
        lines.insert index, service_name
      else
        first_instance_found = true
      end
    end
    File.open(filename, 'w+') do |f|
      f.puts(lines)
    end
  end

  def insert_new_service_in_config_template(filename, to_insert)

config_block = <<~CONFIG
#{to_insert}:
  enable: {{ #{to_insert}.enable | default(enable_#{to_insert}, None) | default(False) }}
  https_only: {{ #{to_insert}.https_only | default(False) }}
  auth: {{ #{to_insert}.auth | default(False) }}
  domain: {{ #{to_insert}.domain | default(False) }}
  subdomain: {{ #{to_insert}.subdomain | default("#{to_insert}")}}
  version: {{ #{to_insert}.version | default("latest") }}
CONFIG
    next_name = find_name_index_for_next_service to_insert
    lines = File.readlines filename
    lines.dup.each_with_index do |line, index|
      next unless line.strip == "#{next_name}:"
      lines.insert index, config_block
    end
    File.open(filename, 'w+') do |f|
      f.puts(lines)
    end
  end

  def insert_in_config(filename, start_tag, to_insert)
    lines = File.readlines filename
    start_tag_found = false
    lines.dup.each_with_index do |l, i|
      if start_tag_found
        if ((to_insert <=> l) == -1) && ((to_insert <=> lines[i - 1]) == 1)
          lines.insert i, to_insert
          break
        end
      else
        start_tag_found = true if l =~ /#{start_tag}/
      end
    end
    File.open(filename, 'w+') do |f|
      f.puts(lines)
    end
  end
}
