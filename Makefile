.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
		match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
		if match:
				target, help = match.groups()
				print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
		@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
		rm -fr bld/ || echo 'bld'
		rm -fr build/ || echo 'build removed'
		rm -fr dist/ || echo 'dist removed'
		rm -fr .eggs/ || echo '.eggs removed'
		rm -fr src/*.eggs/ || echo '.eggs removed'
		rm -fr src/*.egg-info/ || echo '.egg-info removed'
		find . -name '*.egg-info' -exec rm -fr {} + || echo '.egg-info removed'
		find . -name '*.egg' -exec rm -f {} + || echo '.egg removed'

clean-pyc: ## remove Python file artifacts
		find . -name '*.pyc' -exec rm -f {} +
		find . -name '*.pyo' -exec rm -f {} +
		find . -name '*~' -exec rm -f {} +
		find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
		rm -fr .tox/
		rm -f .coverage
		rm -fr htmlcov/
		rm -fr .pytest_cache

dist: clean ## builds source and wheel package
		mkdir bld
		python setup.py egg_info --egg-base=bld build --build-base=bld bdist_wheel --universal
		ls -l dist

install: clean ## install the package to the active Python's site-packages
		python setup.py install
