PY = python
VENV = .venv
BIN=$(VENV)/bin

setup: requirements.txt
	$(PY) -m venv $(VENV) 
	$(BIN)/pip install --upgrade -r requirements.txt

build:
	$(BIN)/pylint  ./src/app

tests:
	$(BIN)/pytest --cov=src/app/ --cov-report=html:reports/html_dir --cov-report=xml:reports/coverage.xml --feature features -vv src/tests/ 

clean:
	rm -rf __pycache__
	rm -rf .venv
