SET APP_NAME=app

odin build ../src -build-mode:exe -out:%APP_NAME%.exe -warnings-as-errors