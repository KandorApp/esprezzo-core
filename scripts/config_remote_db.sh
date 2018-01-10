#!/bin/bash
ssh jerome@core-2.esprezzo.io <<-'ENDSSH'
  
  sudo -u postgres bash -c "psql -c \"CREATE USER esprezzo_db_user WITH PASSWORD 'E4JgHAotvPcVrYWLhEFzwmPPF1GSAmuTzsGkBYEipWq6SbUcD7zAVDWb8HCSv';\""
  sudo -u postgres bash -c "psql -c \"CREATE DATABASE esprezzo_core_prod;\""
  sudo -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE esprezzo_core_prod TO esprezzo_db_user;\""

ENDSSH

ssh jerome@core-1.esprezzo.io <<-'ENDSSH'

  sudo -u postgres bash -c "psql -c \"CREATE USER esprezzo_db_user WITH PASSWORD 'E4JgHAotvPcVrYWLhEFzwmPPF1GSAmuTzsGkBYEipWq6SbUcD7zAVDWb8HCSv';\""
  sudo -u postgres bash -c "psql -c \"CREATE DATABASE esprezzo_core_prod;\""
  sudo -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE esprezzo_core_prod TO esprezzo_db_user;\""

ENDSSH

