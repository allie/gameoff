OS := $(shell uname)
ifeq ($(OS),Darwin)
	LOVE := /Applications/love.app/Contents/MacOS/love
	# A workaround to circumvent the issue mentioned here: https://love2d.org/forums/viewtopic.php?t=85784&p=223279
	WORKAROUND := rm -r ~/Library/Saved\ Application\ State/org.love2d.love.savedState
else
	LOVE := love
	WORKAROUND := 
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
	$(WORKAROUND) || true
	$(LOVE) ./game.love
