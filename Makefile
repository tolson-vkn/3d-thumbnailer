MAKE_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help:
	@echo "+---------------------+"
	@echo "| thumbnailer targets |"
	@echo "+---------------------+"
	@grep -E '^[a-zA-Z\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: ## Install Deps (Manjaro)

	@echo Installing Deps
	sudo pacman -Syu openscad xorg-server-xvfb

.PHONY: install
install: ## Install Thumbmailer

	@echo Installing thumbmailer
	sudo cp stl.thumbnailer /usr/share/thumbnailers/
	sudo cp stl_thumbnailer.sh /usr/local/bin/

.PHONY: install-extras
install-extras: ## Update MIME

	@echo Update MIME
	sudo update-mime-database /usr/share/mime
	sudo xdg-mime install --novendor stl.xml

.PHONY: install-all
install-all: ## Do all the things

	@echo Do all the things!
	make deps
	make install
	make install-extras

