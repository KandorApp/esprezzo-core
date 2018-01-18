#!/bin/bash

# Install Erlang and Elixir
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb;
sudo apt-get update;
sudo apt-get install esl-erlang;
sudo apt-get install elixir;
sudo apt-get install build-essential
curl https://sh.rustup.rs -sSf | sh
# Install postgeres
sudo apt-get install postgresql;

