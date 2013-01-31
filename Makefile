SRCS := window.js settings.js soy/task.js

SRCDIR := scripts
APPDIR := app
PROJECT := $(shell basename `pwd`)
STATIC_DEPS := $(shell find app -type f)
APP_DEPS := $(STATIC_DEPS) $(patsubst %,$(APPDIR)/%,$(SRCS))

all : $(PROJECT).zip

$(APPDIR)/%.js : $(SRCDIR)/%.js
	java -jar compiler.jar --js $< --js_output_file $@ || (rm $@ && false)

$(APPDIR)/soy/%.js : soy/%.js
	java -jar compiler.jar --js $< --js_output_file $@ || (rm $@ && false)

soy/%.js : $(SRCDIR)/%.soy
	java -jar SoyToJsSrcCompiler.jar --outputPathFormat $@ --srcs $< || (rm $@ && false)

.PHONY : test build

build : $(APP_DEPS)
$(APP_DEPS) : Makefile

test : build
	echo built

$(PROJECT).zip : $(APP_DEPS)
	cd $(APPDIR) && zip ../$(PROJECT).zip $(patsubst app/%,%,$(APP_DEPS))
