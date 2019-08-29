FROM nikeda/tabular_analytics:latest
USER root
LABEL maintainer="Naoya Ikeda <n_ikeda@hotmail.com>"
RUN echo "now building..." 
RUN conda install gensim

