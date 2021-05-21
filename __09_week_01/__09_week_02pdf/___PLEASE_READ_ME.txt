
The directory that encloses this file is your working directory for R and shell.

What is this?

This project illustrates several interesting and practical functionalities.

1) We use R to build and write a script

2) when this script is run in bash, it will extract and save textual and graphic information from a PDF (in this example, our photo roster)

What exactly does this do?
It extracts photos from the PDF, saving each as its own PNG, and also extracts student UIDs and saves them, along with the corresponding picture file name as a TSV.


How do I run this amazing resource?

You must have ImageMagick installed

(brew install imagemagick)

You must have bash (usually the default shell on MacOS, available on Windows 10)

Rlib pdftools



To run, use Terminal (make sure you're in bash shell) and cd to the folder that encloses this file.
Then do:


make rms

source script_uids_out.sh






