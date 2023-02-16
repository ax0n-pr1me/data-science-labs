# Data Science Stacks

```sh
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

```sh
conda config --set auto_activate_base false
conda config --set changeps1 false
conda update conda
```

```sh
cd ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
```

## make environment

```sh
conda create --prefix ./env python=3.10 numpy matplotlib scikit-learn imageio jupyterlab rasterio 

ssh -L 8888:localhost:8888 sysadmin@172.21.19.105
jupyter lab --no-browser
```
