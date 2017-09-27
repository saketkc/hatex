rm -f assignment1.zip 
zip -r assignment1.zip . -i "*.ipynb" "lib/*.py" "lib/tf_models/*.py" -x "*.ipynb_checkpoints*"
