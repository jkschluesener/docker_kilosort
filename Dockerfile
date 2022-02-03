# Kilosort v2.5 Container
# https://github.com/jkschluesener/docker_kilosort

FROM mathworks/matlab-deep-learning:r2021b

# Install phy
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends python3-pip
RUN pip install phy --pre --upgrade
# kilosort
RUN git clone --depth 1 --branch v2.5 https://github.com/MouseLand/kilosort.git /home/matlab/Documents/MATLAB/kilosort
# enable matlab to read numpy files
RUN git clone --depth 1 https://github.com/kwikteam/npy-matlab.git /home/matlab/Documents/MATLAB/npy-matlab
# matlab gui layout toolbox
RUN git clone --depth 1 --branch v2.3.5 https://github.com/jkschluesener/matlab_gui_layout_toolbox.git /home/matlab/Documents/MATLAB/gui_layout_toolbox
# startup script
COPY startup.m /home/matlab/Documents/MATLAB/
