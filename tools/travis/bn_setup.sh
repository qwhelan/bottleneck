#!/usr/bin/env bash

set -ev # exit on first error, print commands

if [ "${TEST_RUN}" = "style" ]; then
    flake8
    black . --check --exclude "(build/|dist/|\.git/|\.mypy_cache/|\.tox/|\.venv/\.asv/|env|\.eggs)"
else
    if [ "${TEST_RUN}" = "sdist" ]; then
        python setup.py sdist
        ARCHIVE=`ls dist/*.tar.gz`
        pip install "${ARCHIVE[0]}"
    else
        pip install "."
    fi
    python setup.py build_ext --inplace
    set +e
    if [ "${TEST_RUN}" = "doc" ]; then
	make doc
    else
	# Workaround for https://github.com/travis-ci/travis-ci/issues/6522
	python "tools/test-installed-bottleneck.py"
    fi
fi
