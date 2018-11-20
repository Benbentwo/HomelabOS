.PHONY: logo deploy docs_build restore develop docs_deploy lint

logo:
	cat homelaboslogo.txt

get_roles:
	sudo ansible-galaxy install toke.tor

# Deploy HomelabOS
deploy: logo get_roles
	ansible-playbook -i hosts homelabos.yml

# Initial setup
setup: logo
	ansible-playbook --extra-vars="@settings.yml" -i setup_hosts setup.yml
	echo "Setup completed! Now just run `make`

# Update just HomelabOS Services (skipping slow initial setup steps)
update: logo
	ansible-playbook -i hosts -t deploy homelabos.yml

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo
	which mkdocs && mkdocs build || echo "Unable to build the documentation. Please install mkdocs."

# Update just the docs
docs_deploy: logo docs_build
	ansible-playbook -i hosts -t docs homelabos.yml

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo
	ansible-playbook -i hosts restore.yml

# Spin up a development stack
develop: logo get_roles
	vagrant plugin install vagrant-disksize
	vagrant up
	vagrant provision

# Execute against a test server
test: logo
	ansible-playbook -i test_hosts homelabos.yml

# Run linting scripts
lint: logo
	pip install yamllint
	find . -type f -name '*.yml*' | sed 's|\./||g' | egrep -v '(\.kitchen/|\[warning\]|\.molecule/)' | xargs yamllint -f parsable
