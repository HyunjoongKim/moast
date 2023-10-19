# MATERIALS AND METHODS

## Workflow for web-based multi-omics analysis
Researchers register omics data and clinical information, create a R/bash script module in a Java environment, and register/manage the processing results in the database. With Data storytelling, it provides intuitive visualization from registered and real-time data generated through various analyses.

## Implementation of systems and service processes
This multi-omics analysis requires uploading large files and high database processing. To this end, high-spec hardware was used in the Linux environment, and performance tunings of Mysql and Tomcat were also performed. In this system, docker, an operating system-based virtualization, was used to resolve version compatibility between various software, and docker-compose (container) configured for database, web application server, and FastAPI. For easy use by researchers, it was developed as a web service based on Spring Framework.
For multi-omics analysis, various bioinformatic tools were used for expression, methylation, and variation analysis. R-packages were installed in the web application server to secure interoperability. MSP-HTPrimer for DNA methylation primer is only available on Windows system not on Linux in this work, so to solve the dependency problem, Oracle VirtualBox was utilized. CanvasXpress library was used to visualize clinical and omics results.
