.PHONY: help install sync test test-deps test-dry-run stow-common stow-os unstow clean update

# Default target
help:
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║          neonid0's Dotfiles - Makefile Commands            ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Installation:"
	@echo "  make install          - Run full installation (install.sh)"
	@echo "  make test-dry-run     - Test installation without changes"
	@echo ""
	@echo "Sync & Update:"
	@echo "  make sync             - Sync local configs to dotfiles repo"
	@echo "  make update           - Pull latest changes and update submodules"
	@echo ""
	@echo "Testing:"
	@echo "  make test             - Run all tests"
	@echo "  make test-deps        - Test if all dependencies are installed"
	@echo "  make test-structure   - Test dotfiles repository structure"
	@echo ""
	@echo "Stow Management:"
	@echo "  make stow-common      - Stow common packages (interactive)"
	@echo "  make stow-os          - Stow OS-specific packages (interactive)"
	@echo "  make unstow           - Remove all symlinks"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean            - Clean temporary files"
	@echo "  make status           - Show git status"
	@echo ""

# Installation
install:
	@echo "Running full installation..."
	@./install.sh

# Sync local configs to dotfiles
sync:
	@echo "Syncing local configs to dotfiles..."
	@./sync.sh

# Update dotfiles from git
update:
	@echo "Pulling latest changes..."
	@git pull
	@echo "Updating submodules..."
	@git submodule update --init --recursive
	@echo "Update complete!"

# Testing
test: test-structure test-deps
	@echo "All tests complete!"

test-deps:
	@echo "Testing dependencies..."
	@./test_dependencies.sh

test-dry-run:
	@echo "Running dry-run test..."
	@./test_dry_run.sh

test-structure:
	@echo "Testing dotfiles structure..."
	@./test_install.sh

# Stow management
stow-common:
	@echo "Stowing common packages..."
	@cd common && stow -R -t ~ */

stow-os:
	@if [ "$$(uname -s)" = "Linux" ]; then \
		echo "Stowing Linux packages..."; \
		cd linux && stow -R -t ~ */; \
	elif [ "$$(uname -s)" = "Darwin" ]; then \
		echo "Stowing macOS packages..."; \
		cd mac && stow -R -t ~ */; \
	else \
		echo "Unknown OS"; \
		exit 1; \
	fi

unstow:
	@echo "Removing symlinks..."
	@cd common && stow -D -t ~ */ || true
	@if [ "$$(uname -s)" = "Linux" ]; then \
		cd linux && stow -D -t ~ */ || true; \
	elif [ "$$(uname -s)" = "Darwin" ]; then \
		cd mac && stow -D -t ~ */ || true; \
	fi
	@echo "Symlinks removed!"

# Maintenance
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.bak" -delete
	@find . -name "*~" -delete
	@find . -name ".DS_Store" -delete
	@echo "Clean complete!"

status:
	@git status
