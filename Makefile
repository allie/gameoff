OS := $(shell uname)
ifeq ($(OS),Darwin)
	LOVE := /Applications/love.app/Contents/MacOS/love
else
	LOVE := love
endif

default: build run

clean:
	@[[ ! -e game.love ]] || rm game.love
	@[[ ! -e pkg ]] || rm -r pkg

build:
	@zip -r game.love assets/
	@zip -r game.love lib/
	@cd src/ && zip -r ../game.love *

run:
	$(LOVE) ./game.love
