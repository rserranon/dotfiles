.PHONY: test-dotfiles install

test-dotfiles:
	@bash tests/run_all.sh

install:
	@bash install.sh
