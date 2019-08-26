For many years, I've been looking for a clean and sensible way to organize my analytical project files and folders. But being mindful of file organization isn't enough, as my half-organized PhD-related files an attest. 

What is a "good" organization system, anyway? Your project folder should have the following traits.

- __Navigable__. Someone going to your project folder should know what's there and where to find it.
- __Reproducible__. Someone that's not current-you should be able to reproduce the analysis. Ideally, with the stroke of a button. 
- __Self-containted__. All files related to the analysis should be in your project folder.

Your project folder is essentially all files that are necessary (and useful) for creating the final manuscript. 

But usually, there are other files that are specific to you, and not required by the manuscript, such as research and meeting notes. I've therefore found that it's useful to keep _two_ folders: your project file, and a companion _developer's folder_ personal to yourself. 


Don't be afraid to duplicate files! For example, your BibTeX documentary should live in the project folder -- even if you only ever draw on one central bibliography. But, this file should be considered as _output_, not a file to be mofidied in itself. For example, make an `automator` script to update the bibliography from your central bibiography, and put that script in your developer's folder. 

https://github.ubc.ca/ubc-mds-2017/general/blob/master/general_lab_instructions.md

- Code files contributing to my analysis go in the `src` directory. 
- Project organization files go in the root directory. This includes:
    - A Makefile or shell scripts This does not include except for the driver scripts (Shell script and Makefile which call your analysis scripts).
- all rendered documents and visualizations you create live in the `results` directory
- any data present goes in the `data` directory
- answers to written questions live in the `doc` directory.