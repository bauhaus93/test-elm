#!/bin/sh

scripts/build_elm.sh && \
scripts/build_env.sh && \
scripts/run_container.sh
