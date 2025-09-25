# Simplified Makefile for jupytext conversions - multiple files
SOURCE_FILES = basics_00.py basics_01.py basics_02.py Ex1_Precipitation.py

# Default target - runs when you just type 'make'
.DEFAULT_GOAL := all

# Copy image directory to ready directory
ready/images:
	mkdir -p ready
	cp -r image ready/

# Download and extract MDB boundaries zip file
MDB_boundaries:
	@if [ ! -f MDB_boundaries.zip ]; then \
		echo "Downloading MDB_boundaries.zip..."; \
		curl -L -o MDB_boundaries.zip https://data.gadopt.org/water-course/MDB_boundaries.zip; \
	fi
	unzip -o MDB_boundaries.zip

# Download rain_day_2025.nc file
CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc:
	@if [ ! -f CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc ]; then \
		echo "Downloading CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc..."; \
		curl -L -o CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc https://data.gadopt.org/water-course/CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc; \
	fi

# Download rain_day_2025.nc file
rain_day_2025.nc:
	@if [ ! -f rain_day_2025.nc ]; then \
		echo "Downloading rain_day_2025.nc..."; \
		curl -L -o rain_day_2025.nc https://data.gadopt.org/water-course/rain_day_2025.nc; \
	fi

# Download RainfallData_Exercise_001.csv file
RainfallData_Exercise_001.csv:
	@if [ ! -f RainfallData_Exercise_001.csv ]; then \
		echo "Downloading RainfallData_Exercise_001.csv..."; \
		curl -L -o RainfallData_Exercise_001.csv https://data.gadopt.org/water-course/RainfallData_Exercise_001.csv; \
	fi

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

# Special dependency for basics_01.py solution (requires MDB extraction and rain data)
solution-basics_01.py: ready/images MDB_boundaries rain_day_2025.nc
	jupytext --to ipynb -o basics_01_temp.ipynb basics_01.py
	jupyter nbconvert --to notebook --output=ready/basics_01_solution.ipynb --execute \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["empty-cell"]' \
		basics_01_temp.ipynb
	rm -f basics_01_temp.ipynb

solution-basics_02.py: ready/images CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc
	jupytext --to ipynb -o basics_02_temp.ipynb basics_02.py
	jupyter nbconvert --to notebook --output=ready/basics_01_solution.ipynb --execute \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["empty-cell"]' \
		basics_02_temp.ipynb
	rm -f basics_02_temp.ipynb

# Special dependency for Ex1_Precipitation.py solution (requires rainfall data)
solution-Ex1_Precipitation.py: ready/images RainfallData_Exercise_001.csv
	jupytext --to ipynb -o Ex1_Precipitation_temp.ipynb Ex1_Precipitation.py
	jupyter nbconvert --to notebook --output=ready/Ex1_Precipitation_solution.ipynb --execute \
		--TagRemovePreprocessor.enabled=True \
		--TagRemovePreprocessor.remove_cell_tags='["empty-cell"]' \
		Ex1_Precipitation_temp.ipynb
	rm -f Ex1_Precipitation_temp.ipynb

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

.PHONY: exercise solution all clean ready/images MDB_boundaries rain_day_2025.nc RainfallData_Exercise_001.csv
