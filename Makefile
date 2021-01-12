SRC=core
COMPILED_DIR=core/compiled
IOS_DIR=ios/iosrepl/iosrepl
IOS_RACKET_ROOT=~/sandbox/racket-ios/racket
IOS_RACKET_LIB_DIR=$(IOS_RACKET_ROOT)/lib
IOS_RACKET_ETC_DIR=$(IOS_RACKET_ROOT)/etc
IOS_RACKET_COLLECTS_DIR=$(IOS_RACKET_ROOT)/collects

$(IOS_DIR)/vendor/repl.zo: $(SRC)/*.rkt
	racket \
		-M -C -R "compiled_host:tarm64osx" \
		--cross-compiler tarm64osx $(IOS_RACKET_LIB_DIR) \
		-G $(IOS_RACKET_LIB_DIR) \
		-X $(IOS_RACKET_COLLECTS_DIR) -l- \
		raco ctool --mods "$@" $(SRC)/main.rkt

.PHONY: clean
clean:
	find core -name compiled -type d | xargs rm -rf
	rm -fr $(COMPILED_DIR) $(COCOA_DIR)/vendor/repl.zo
	rm -fr $(COMPILED_DIR) $(IOS_DIR)/vendor/repl.zo
