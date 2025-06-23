#!/bin/sh
export PROVIDER=http://127.0.0.1:1234/v1/chat/completions
export MODEL=allenai_olmo-3.1-32b-instruct
raku main.raku artifact.csv article1-kurz.txt