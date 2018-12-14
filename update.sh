#!/bin/bash

git submodule foreach git checkout stable
git submodule foreach git reset --hard origin/stable
git submodule foreach git pull origin stable

