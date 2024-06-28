FVM = fvm flutter

.PHONY: f_setup
f_setup:
	$(FVM) clean
	make f_build_runner

.PHONY: f_pub_get
f_pub_get:
	$(FVM) pub get

.PHONY: f_build_runner
f_build_runner:
	make f_pub_get
	$(FVM) pub run build_runner clean
	$(FVM) gen-l10n
	$(FVM) packages pub run build_runner build --delete-conflicting-outputs

.PHONY: f_clean
f_clean:
	$(FVM) clean
	make f_pub_get
	make clean_pod

.PHONY: f_format
f_format:
	$(FVM) pub run import_path_converter:main
	$(FVM) pub run import_sorter:main
	dart format -l 120 lib/* test/*
	$(FVM) analyze


.PHONY: apk_stg
apk_stg:
	make f_setup
	$(FVM) build apk --flavor stag --dart-define=FLAVOR=stag -t ./lib/main.dart

.PHONY: ios_stg
ios_stg:
	make f_setup
	$(FVM) build ios --flavor stag --dart-define=FLAVOR=stag -t ./lib/main.dart

.PHONY: abb_stg
abb_stg:
	make f_setup
	$(FVM) build appbundle --flavor stag --dart-define=FLAVOR=stag -t ./lib/main.dart

.PHONY: ios_prod
ios_prod:
	make f_setup
	$(FVM) build ios --flavor prod --dart-define=FLAVOR=prod -t ./lib/main.dart

.PHONY: abb_prod
abb_prod:
	make f_setup
	$(FVM) build appbundle --flavor prod --dart-define=FLAVOR=prod -t ./lib/main.dart

.PHONY: apk_prod
apk_prod:
	make f_setup
	$(FVM) build apk --flavor prod --dart-define=FLAVOR=prod -t ./lib/main.dart