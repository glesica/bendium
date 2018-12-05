.PHONY: analyze
analyze:
	dartanalyzer --fatal-infos --fatal-warnings lib/ test/

.PHONY: check-fast
check-fast:
	pub run test -p vm

.PHONY: check-full
check-full: analyze format check-fast

.PHONY: format
format:
	pub run dart_style:format -l 80 -w --set-exit-if-changed lib/ test/

.PHONY: init
init:
	pub get
