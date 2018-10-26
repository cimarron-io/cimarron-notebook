ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="chekos <sergio@cimarron.io>"

USER root

# Install other packages
RUN conda install --quiet --yes \
    'altair' \ 
    'vega' \
    'vega_datasets' && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -typsy && \
    pip install jupyterlab_templates && \
    # enable jupyterlab_templates extension
    jupyter labextension install jupyterlab_templates && \
    jupyter serverextension enable --py jupyterlab_templates && \
    # create jupyter_notebook_config.py
    jupyter notebook --generate-config -y && \
    # clone templates into template directory
    git clone https://github.com/chekos/nb_templates.git home/$NB_USER/.jupyter/nb_templates && \
    # add directory path to notebook config file
    echo "c.JupyterLabTemplates.template_dirs = ['home/$NB_USER/.jupyter/nb_templates/nb_templates']" >> home/$NB_USER/.jupyter/jupyter_notebook_config.py

