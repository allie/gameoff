OS := $(shell uname)
ifeq ($(OS),Darwin)
	LOVE := /Applications/love.app/Contents/MacOS/love
else
	LOVE := love
endif

default: build doc run

clean:
	@[[ ! -e game.love ]] || rm game.love
	@[[ ! -e pkg ]] || rm -r pkg
	@[[ ! -e doc ]] || rm -r doc

build:
	@zip -r game.love assets/
	@zip -r game.love lib/
	@cd src/ && zip -r ../game.love *

.PHONY: doc
doc:
	@ldoc -d doc -p game -f markdown src

run:
	$(LOVE) ./game.love
