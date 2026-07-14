pkgname <- "usefulfunctions"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('usefulfunctions')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("get_batlow")
### * get_batlow

flush(stderr()); flush(stdout())

### Name: Get.batlow
### Title: Batlow colour palette
### Aliases: Get.batlow get_batlow

### ** Examples

get_batlow(5)



cleanEx()
nameEx("make_transparent")
### * make_transparent

flush(stderr()); flush(stdout())

### Name: makeTransparent
### Title: Make a colour transparent
### Aliases: makeTransparent make_transparent

### ** Examples

make_transparent("red", percent = 50)



cleanEx()
nameEx("moving_average")
### * moving_average

flush(stderr()); flush(stdout())

### Name: calc.moving.average
### Title: Moving average of a numeric vector
### Aliases: calc.moving.average moving_average

### ** Examples

moving_average(c(1, 2, 3, 4, 5), n = 3)
moving_average(c(1, NA, 3, 4, 5), n = 2, centered = TRUE)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
