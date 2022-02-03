# Kilosort Container

This is a docker container for [Kilosort](https://github.com/MouseLand/Kilosort.git) and is built on the [Matlab Docker Image](https://hub.docker.com/r/mathworks/matlab-deep-learning).

The conatiner uses __Matlab 2021b__ and __Kilosort v2.5__.
All dependencies for Kilosort are configured, including [phy](https://github.com/cortex-lab/phy) and the [python packages](https://github.com/cortex-lab/phy/blob/master/requirements.txt) it depends on.

The base container contains several [mathworks matlab toolboxes](https://hub.docker.com/r/mathworks/matlab-deep-learning) and third-party toolboxes (npy-matlab,gui_layout_toolbox).

## Building the container

You can use this template directory for your project:

```terminal
git clone https://github.com/jkschluesener/docker_kilosort.git your_awesome_spikesorting

cd your_awesome_spikesorting

docker build -t kilosort .
```

This is a very large image, just under 17gb, as it is an entire matlab install with several packages that are not needed but cannot be removed easily.
This repo adds only a few MB on top of the existing image.

If you don't want to use this structure, all you need is the Dockerfile.

## Running the container

### Default directory

The default directory in the container is `/home/matlab/Documents/MATLAB`

### startup.m

The `startup.m` file that is included in this directory is copied to the container during the build process and specifies which directories to add to the matlab search path.

### A quick overview of run flags

| Command         | Explanation                                                                              |
|-----------------|------------------------------------------------------------------------------------------|
| --gpus          | GPUs to give to the container, can be `all`                                              |
| -e              | environment variables, here optionally used for `MLM_LICENSE_FILE=27000@MyLicenseServer` |
| -it             | creates an interactive connection to the container tty                                   |
| --rm            | remove container on exit                                                                 |
| --shm-size=512M | size of /dev/shm (shared memory)                                                         |

### Licensing

Matlab is not open source, so you have to log in during container start.
Please see the [official documentation](https://hub.docker.com/r/mathworks/matlab-deep-learning) about this issue.

In summary:

#### Option A: License server

Use the following flag:
`-e MLM_LICENSE_FILE=27000@MyLicenseServer`

#### Option B: License File

Use the following flag:
`-e MLM_LICENSE_FILE=filepath`

#### Option C: Mathworks Account

If no license file flag was supplied uring startup, the container will ask for your email and password.

### Mounting your data and code

If you use this repo as a template, otherwise adapt the mount to your needs.

```terminal
docker run --gpus all -it --rm --mount type=bind,source="$(pwd)"/workspace,destination=/home/matlab/Documents/MATLAB/workspace kilosort
```

#### `mount` command

The mount command is comprised of 3 parts:

| Command       | Meaning                                                   |
|---------------|-----------------------------------------------------------|
| `type`        | use `bind` for a bind mount                               |
| `source`      | source folder on the host, use "$(pwd)" for a global path |
| `destination` | destination folder in the container                       |

Typically used: `type=bind,source="$(pwd)"/workspace,destination=/home/matlab/Documents/MATLAB/workspace`

## Compilation of mex files

The first time kilosort is run in the container, it needs to compile some mex files.
Compilation of this code is done by the matlab function [mexcuda](https://de.mathworks.com/help/parallel-computing/mexcuda.html).

As this function is not open source, it can only be run after you authenticate your container with Mathworks.  
This means, everytime you start the container, you will need to wait a moment for compilation to finish.  
Compilation will start on the first call of `kilosort`.

### Perserve compiled files

Run your container how you normally would, but ommit the `--rm` flag to prevent automatic erasure.  
Upon exiting the container, find the `container ID` using `docker ps -a`.  
The container can then be saved in its current state including the compiled files using `docker commit <container ID> kilosort_done`
