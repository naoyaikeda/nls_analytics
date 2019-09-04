FROM nikeda/tabular_analytics:latest
USER root
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
LABEL maintainer="Naoya Ikeda <n_ikeda@hotmail.com>"
RUN echo "now building..."

RUN apt update  && \
    apt install -y mecab libmecab-dev mecab-ipadic-utf8 git make curl xz-utils file sudo wget swig cmake libboost-dev

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git\
    && cd mecab-ipadic-neologd\
    && bin/install-mecab-ipadic-neologd -n -y

RUN conda install -c conda-forge fasttext && \
    conda install gensim nltk lxml && \
    pip install janome mecab-python3
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

RUN curl -L  "https://oscdl.ipa.go.jp/IPAexfont/ipaexg00301.zip" > font.zip && \
    unzip font.zip && \
    cp ipaexg00301/ipaexg.ttf /opt/conda/lib/python3.6/site-packages/matplotlib/mpl-data/fonts/ttf/ipaexg.ttf && \
    echo "font.family : IPAexGothic" >>  /opt/conda/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc && \
    rm -r ./.cache

ADD CRF++-0.58.tar.gz ./
RUN cd CRF++-0.58 && \
    ./configure && \
    make && \
    make install

ADD cabocha-0.69.tar.bz2 ./
RUN cd cabocha-0.69 && \
    ./configure --with-charset=UTF8 && \
    make && \
    make install && \
    swig -python -shadow -c++ swig/CaboCha.i && \
    mv swig/CaboCha.py python/ && \
    mv swig/CaboCha_wrap.cxx python/ && \
    cd python && \
    python setup.py build_ext && \
    python setup.py install && \
    ldconfig /etc/ld.so.conf.d

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2 && \
    tar -jxvf juman-7.01.tar.bz2 && \
    cd juman-7.01 && \
    ./configure && \
    make && \
    make install && \
    ldconfig /etc/ld.so.conf.d

RUN wget http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.01.tar.xz && \
    tar -xvf jumanpp-1.01.tar.xz && \
    cd jumanpp-1.01 && \
    ./configure && \
    make && \
    make install && \
    ldconfig /etc/ld.so.conf.d

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.19.tar.bz2 && \
    tar -jxvf knp-4.19.tar.bz2 && \
    cd knp-4.19 && \
    ./configure && \
    make && \
    make install && \
    ldconfig /etc/ld.so.conf.d
