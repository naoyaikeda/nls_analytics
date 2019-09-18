pushd ..
docker run -itd --rm -p 10000:8888 -p 54321:54321 -v %CD%\jovyan:/home/jovyan --name nls_analytics -e GRANT_SUDO=yes --user root nikeda/nls_analytics:0.1.1 start-notebook.sh
popd
