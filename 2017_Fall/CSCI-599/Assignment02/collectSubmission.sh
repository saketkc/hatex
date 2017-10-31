rm -f assignment2.zip 
zip -r assignment2.zip . -i "*.ipynb" "lib/*.py" "lib/tf_models/*.py" -x "*.ipynb_checkpoints*"
