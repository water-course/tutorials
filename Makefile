# Simplified Makefile for jupytext conversions - multiple files
SOURCE_FILES = basics_00.py

# Default target - runs when you just type 'make'
.DEFAULT_GOAL := all

# Copy image directory to ready directory
ready/images:
	mkdir -p ready
	cp -r image ready/

# Convert single file to exercise notebook (remove solutions)
exercise-%: ready/images
	jupytext --to ipynb -o $(basename $*)_temp.ipynb $*
	jupyter nbconvert --to notebook --output=ready/$(basename $*).ipynb \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["solution"]' \
		$(basename $*)_temp.ipynb
	rm -f $(basename $*)_temp.ipynb

# Convert single file to solution notebook (remove empty cells)
solution-%: ready/images
	jupytext --to ipynb -o $(basename $*)_temp.ipynb $*
	jupyter nbconvert --to notebook --output=ready/$(basename $*)_solution.ipynb --execute \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["empty-cell"]' \
		$(basename $*)_temp.ipynb
	rm -f $(basename $*)_temp.ipynb

# Generate exercise versions for all files
exercise: $(addprefix exercise-,$(SOURCE_FILES))

# Generate solution versions for all files
solution: $(addprefix solution-,$(SOURCE_FILES))

# Generate all versions for all files
all: exercise solution

# Clean up all generated files
clean:
	rm -f *_temp.ipynb *_solution.ipynb
	rm -rf ready

.PHONY: exercise solution all clean ready/images
