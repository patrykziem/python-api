all : readme

readme :
	@echo ""
	@less make_instructions.txt

setup_subs :
	@echo "Deleting old submodule locations, if they exist"
	rm -rf plotly/graph_reference
	rm -rf plotly/mplexporter
	rm -rf plotly/chunked_requests
	rm -rf plotly/plotly/chunked_requests
	rm -rf plotly/matplotlylib/mplexporter
	@echo "Initializing submodules listed in project"
	git submodule init
	@echo "Updating submodules to their respective commits"
	git submodule update
	make sync_subs

install : sync_subs
	@echo ""
	@echo "Installing Python API with make"
	python setup.py install

sync_subs : sync_mpl sync_chunked sync_refs
	@echo ""
	@echo "Submodules synced"

pull_subs : pull_mpl pull_chunked pull_refs
	@echo ""
	@echo "Submodules pulled"

sync_mpl : submodules/mplexporter
	@echo ""
	@echo "Syncing mplexporter directories"
	rsync -r submodules/mplexporter/mplexporter plotly/matplotlylib/

sync_chunked : submodules/chunked_requests
	@echo ""
	@echo "Syncing chunked_requests directories"
	rsync -r submodules/chunked_requests/chunked_requests plotly/plotly/

sync_refs : submodules/graph_reference
	@echo ""
	@echo "Syncing graph_reference directories"
	rsync -r submodules/graph_reference plotly/

pull_refs : submodules/graph_reference
	@echo ""
	@echo "Pulling down updates from graph_reference"
	cd submodules/graph_reference; git pull origin master

pull_mpl : submodules/mplexporter
	@echo ""
	@echo "Pulling down updates from mplexporter"
	cd submodules/mplexporter; git pull origin master

pull_chunked : submodules/chunked_requests
	@echo ""
	@echo "Pulling down updates from chunked_requests"
	cd submodules/chunked_requests; git pull origin master

run_coverage : 
	@echo ""
	@echo "Running api nosetests with coverage"
	nosetests -w plotly/tests --with-coverage --cover-erase --cover-package plotly.plotly.plotly --cover-package plotly.graph_objs.graph_objs --cover-package plotly.graph_objs.graph_objs_tools --cover-package plotly.matplotlylib.mpltools --cover-package plotly.matplotlylib.renderer --cover-package plotly.tools --cover-package plotly.exceptions --cover-package plotly.utils --cover-package plotly.version
	@echo "Removing old html if it exists"
	if [ -d plotly/tests/coverage ]; then rm -rf plotly/tests/coverage; fi
	@echo "Generating html with coverage"
	coverage html -d plotly/tests/coverage
	
	
