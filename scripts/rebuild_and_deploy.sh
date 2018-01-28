#!/bin/bash
# mix edeliver build release;
mix edeliver update production --verbose;
mix edeliver restart production;
