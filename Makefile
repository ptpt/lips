README.md: README.md.in lips/* examples/*
	sh.awk $< > $@

install:
	install lips/* /usr/local/bin

.PHONY: install
