FROM rocker/tidyverse:4.1.2

ENV TZ Asia/Tokyo

RUN apt-get update && apt-get install -y \
    fonts-ipaexfont \
    libxt6 \
    libv8-dev \
    librsvg2-dev \
    neovim \
    curl \
    git \
    python3-pip \
    nkf \
    python3-tk \
    sqlite3 \
    less \
    x11-apps

RUN cd ~ && \
    curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && \
    sh ./nodesource_setup.sh && \
    apt-get install -y nodejs

RUN Rscript -e "install.packages(c('reticulate', \
                                   'renv', \
                                   'readxl', \
                                   'writexl', \
                                   'RSQLite', \
                                   'survival', \
                                   'Rmisc', \
                                   'pROC', \
                                   'gtsummary', \
                                   'cowplot', \
                                   'ggsci', \
                                   'ggbeeswarm', \
                                   'shiny', \
                                   'shinydashboard', \
                                   'DiagrammeR', \
                                   'revealjs', \
                                   'ggmcmc', \ 
                                   'webshot', \
                                   'tinytex', \
                                   'languageserver'))"

RUN Rscript -e "devtools::install_github(c('sachsmc/ggkm', \
                                           'sachsmc/plotROC', \
                                           'stan-dev/posterior', \
                                           'stan-dev/cmdstanr'))"

RUN pip3 install \
    msoffcrypto-tool \
    openpyxl \
    numpy \
    Flask \
    matplotlib \
    pandas \
    xlsx2csv

USER rstudio
RUN sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

RUN Rscript -e "webshot::install_phantomjs()"

RUN Rscript -e "cmdstanr::install_cmdstan()"
RUN Rscript -e "cmdstanr::set_cmdstan_path()"

RUN Rscript -e "tinytex::install_tinytex()"

RUN mkdir -p ~/.config/nvim
RUN echo "Sys.setenv(TZ = 'JST')" > ~/.Rprofile
 
USER root
WORKDIR /home/rstudio/Projects

