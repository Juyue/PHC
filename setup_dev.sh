# Exit on error, and print commands
set -ex

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create overall workspace
WORKSPACE_DIR=$SCRIPT_DIR/thirdparty
CONDA_ROOT=$WORKSPACE_DIR/miniconda3
ENV_ROOT=$CONDA_ROOT/envs/phc

mkdir -p $WORKSPACE_DIR

# Install miniconda
if [[ ! -d $CONDA_ROOT ]]; then
  mkdir -p $CONDA_ROOT
  curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o $CONDA_ROOT/miniconda.sh
  bash $CONDA_ROOT/miniconda.sh -b -u -p $CONDA_ROOT
  rm $CONDA_ROOT/miniconda.sh
fi

# Create the conda environment
if [[ ! -d $ENV_ROOT ]]; then
  $CONDA_ROOT/bin/conda install -y mamba -c conda-forge -n base
  MAMBA_ROOT_PREFIX=$CONDA_ROOT $CONDA_ROOT/bin/mamba create -y -n phc python=3.8
fi


source $CONDA_ROOT/bin/activate phc
# Install Isaac Gym
if [[ ! -d $WORKSPACE_DIR/isaacgym ]]; then
  wget https://developer.nvidia.com/isaac-gym-preview-4 -O $WORKSPACE_DIR/IsaacGym_Preview_4_Package.tar.gz
  tar -xzf $WORKSPACE_DIR/IsaacGym_Preview_4_Package.tar.gz -C $WORKSPACE_DIR
  cd $WORKSPACE_DIR/isaacgym/python
  $ENV_ROOT/bin/pip install -e .
fi

# Install PHC
cd $SCRIPT_DIR
pip install -r requirement.txt