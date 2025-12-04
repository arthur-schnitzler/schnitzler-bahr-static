if [ -d "saxon" ] && [ -f "saxon/saxon9he.jar" ]; then
    echo "Saxon already exists (found saxon/saxon9he.jar), skipping download"
else
    echo "Saxon not found, downloading..."
    wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/SaxonHE9-9-1-7J.zip/download && unzip -o download -d saxon && rm -rf download
    echo "Saxon download complete"
fi