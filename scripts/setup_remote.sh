#!/bin/bash
ssh jerome@core-2.esprezzo.io <<-'ENDSSH'
  sudo ls -lah

  # Install Erlang and Elixir
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb;
  sudo apt-get update -y;
  sudo apt-get install esl-erlang -y;
  sudo apt-get install elixir -y;

  # Install postgres
  sudo apt-get install postgresql -y;

  sudo -u postgres bash -c "psql -c \"CREATE USER esprezzo_db_user WITH PASSWORD 'E4JgHAotvPcVrYWLhEFzwmPPF1GSAmuTzsGkBYEipWq6SbUcD7zAVDWb8HCSv';\""

ENDSSH

ssh jerome@core-1.esprezzo.io <<-'ENDSSH'
  sudo ls -lah

  # Install Erlang and Elixir
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb;
  sudo apt-get update -y;
  sudo apt-get install esl-erlang -y;
  sudo apt-get install elixir -y;

  # Install postgres
  sudo apt-get install postgresql -y;

  sudo -u postgres bash -c "psql -c \"CREATE USER esprezzo_db_user WITH PASSWORD 'E4JgHAotvPcVrYWLhEFzwmPPF1GSAmuTzsGkBYEipWq6SbUcD7zAVDWb8HCSv';\""


ENDSSH

# scp ./config/config.prod.secret jerome@core-1.esprezzo.io:
# scp ./config/config.prod.secret jerome@core-2.esprezzo.io: