#!/bin/bash
# mix edeliver build release;
mix edeliver update production --skip-mix-clean --verbose;
mix edeliver restart production;
