#!/bin/bash
mix edeliver build release;
mix edeliver update production;
mix edeliver restart production;
