# Simplified Makefile for jupytext conversions - multiple files
SOURCE_FILES = Ex1_Precipitation.py

# Default target - runs when you just type 'make'
.DEFAULT_GOAL := all

# Convert single file to exercise notebook (remove solutions)
exercise-%:
	mkdir -p ready
	jupytext --to ipynb -o $(basename $*)_temp.ipynb $*
	jupyter nbconvert --to notebook --output=ready/$(basename $*).ipynb \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["solution"]' \
		$(basename $*)_temp.ipynb
	rm -f $(basename $*)_temp.ipynb

# Convert single file to solution notebook (remove empty cells)
solution-%:
	mkdir -p ready
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

.PHONY: exercise solution all clean
