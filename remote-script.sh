#!/bin/bash

grep -oP "Identity: '\\K.*(?=')" ../gvite/node_config.json
git pull