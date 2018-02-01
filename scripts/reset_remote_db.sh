#!/bin/bash
ssh jerome@core-2.esprezzo.io <<-'ENDSSH'
  
  sudo -u postgres bash -c "psql -c \"DROP DATABASE esprezzo_core_prod;\""
  sudo -u postgres bash -c "psql -c \"CREATE DATABASE esprezzo_core_prod;\""

ENDSSH

ssh jerome@core-1.esprezzo.io <<-'ENDSSH'

  sudo -u postgres bash -c "psql -c \"DROP DATABASE esprezzo_core_prod;\""
  sudo -u postgres bash -c "psql -c \"CREATE DATABASE esprezzo_core_prod;\""

ENDSSH

