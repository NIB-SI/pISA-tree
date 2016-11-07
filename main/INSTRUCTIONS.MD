# pISA-tree: Standard project directory tree

This set of batch files is used to create standard directory tree for research projects.

## Layers

At the top layer, you have to create a directory (`project` root directory) 
which will contain future investigations. The root directory is the place for initial batch files.
Step one is to copy/download the batch files from the [[set source]] into the root directory.
 
**Investigation** is organized as a collection of one or more **studies**.   
Each **study** has it's own collection of one or more **assays**. Assay can be of different type
(e.g. conected to MicroArray, NGS, Modeling, Statistical analysis, ...) and are structured accordingly.

## Batch files

- `makeInvestigation.bat`	- makes new **investigation** directory tree
- `makeStudy.bat` - makes new **study** (subdirectory tree within the **investigation**)
- `makeAssay.bat` - makes new **assay** (subdirectory tree within the **study**)

## Creation of the directory tree

### Investigation

To create a new investigation, run (double click) the file `makeInvestigation.bat` and enter the study short name (ID). This will make a direcory tree, description files and a local copy of `makeStudy.bat`. Short study name (ID) is used as the name of the directory (no spaces or special characters, file name conventions apply!!). Each study tree has a `_STUDIES` subdirectory, where investigation studies will be rooted.

### Study

Investigation studies are collected in the subdirectory `_STUDIES`. In the main `_STUDIES` directory, you will find the `makeStudy.bat`. To create a new study, run the `makeStudy.bat` and enter the study ID (Short name), This file will make a new directory tree, rooted in the `_STUDIES` subdirectory. Each study tree has a `_ASSAYS` subdirectory and a copy of the `makeAssay.bat` file.

### Assay

Analyses for each study are collected the `_ASSAYS` folder of that study. To make a new assay, run the `makeAssay.bat` file and enter  assay ID (Short name) and assay Type (see documentation for covered types: NGS, MA, STat ...). Short assay name and type are used as the name of the  assay directory tree.

### Description files

Each level has a *description* file, listing the informative items for that level. 
Description files are tab delimited files with two columns:  

1. item name (ended by a colon)
2. item description or value

Item description can be some text (for example investigator's name or a longer description of the study, study, and analysis) 
or a value (for example the path to *phenodata* file). Each item should be typed in one line only. Special escaped characters for line break (`\n`) and tab (`\t`) are allowed. 

For example:

INVESTIGATOR:	Miha Mihav  
PHENODATA:	./data/phenodata.txt

The study level directory contains the file `study.ini`, which is organized in the same way as description files. 
This file contains fields and descriptions that do not change, for example principal investigator name. 
Information in this file will be appended to the description files for studies and assays.

