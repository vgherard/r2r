# Comments for CRAN submission of r2r (v0.1.1)

### Comments for resubmission (v2)

From the CRAN staff's review:
	
	Missing Rd-tags:
		hashtable_methods.Rd:  \value
		hashtable_properties.Rd: \value
		subsetting_hashtables.Rd: \value
	
	Please fix and resubmit.
	
For the `subsetting_hashtables` documentation entry this was a typo in 
roxygen code, and has been fixed.

The entry `hashtable_properties` was spurious and has been eliminated.

The `hashtable_methods` entry, however, does not document any specific function,
but rather provides a global overview of the methods for the S3 classes exported
by the package. As such, a \\value tag is in my opinion not appropriate here.


### Test environments
* local: 

        - Ubuntu 20.04 LTS, R 4.1.0 (OK)
* winbuilder:

        - release (1 NOTE)
        - oldrelease (1 NOTE)
        - devel (1 NOTE)
* rhub: 

        - Windows Server 2008 R2 SP1, R-devel, 32/64 bit (1 ERROR, see below)
        - Fedora Linux, R-devel, clang, gfortran (1 NOTE)
        - Ubuntu Linux 20.04.1 LTS, R-release, GCC (1 NOTE)
        - Debian Linux, R-devel, GCC ASAN/UBSAN (OK)
* GitHub Actions:

        - macOS Catalina 10.15.7, R-release (OK)
        - Windows Server x64, R-release (OK)
        - Windows Server x64, R 3.6 (OK)
        - Ubuntu 18.04, R-devel (OK)
        - Ubuntu 18.04, R-release (OK)
        - Ubuntu 18.04, R-oldrel (OK)
        - Ubuntu 18.04, R 3.6 (OK)
        - Ubuntu 18.04, R 3.5 (OK)
        - Ubuntu 18.04, R 3.4 (OK)

### R CMD check results

Testing the package on the rhub platform 'Windows Server 2008 R2 SP1, R-devel, 32/64 bit' resulted in an ERROR:
* Bioconductor does not yet build and check packages for R version 4.2

I believe this ERROR to be spurious, and due to the bug already reported here:
https://github.com/r-hub/rhub/issues/471

An other platforms, the result was either (OK) or:

0 errors | 0 warnings | 1 note

* This is a new release.
