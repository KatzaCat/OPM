SET APP_NAME=sld-app

odin build ../src -build-mode:exe -out:%APP_NAME%.exe -warnings-as-errors