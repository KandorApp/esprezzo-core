#!/bin/bash
mix edeliver build release;
mix edeliver deploy release production --clean-deploy --verbose;
mix edeliver restart production;
