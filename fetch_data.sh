# bin/bash

rm -rf data
wget https://github.com/arthur-schnitzler/schnitzler-bahr-data/archive/refs/heads/main.zip
unzip main

mv ./schnitzler-bahr-data-main/data .
rm main.zip
rm -rf ./schnitzler-bahr-data-main
