#' ---
#' title: Introduction to R and RStudio
#' reference: Chapter 1 & 2 of R in Action Second Edition
#' created by: Jian Yang
#' last modified by: Jian Yang
#' last modified date: 8/26/2022
#' ---

# use Edit -> Folding to collapse (Alt+O or +L) the coding blocks
#                     or expand (Alt+Shift+O or +L) the coding blocks

# use at least four hyphens ----  at the end of the comment 
#               or double hyphens ==== or pounds #### to denote a section

# Chapter 1 (Introduction) ----
# * A Sample R Session ====
# see the reference book 1.3.1 
age <- c(1,3,5,2,11,9,3,9,12,3) # infant age in months
weight <- c(4.4,5.3,7.2,5.2,8.5,7.3,6.0,10.4,10.2,6.1) # unit in kg
mean(weight)
sd(weight)
cor(age,weight)
plot(age,weight)

# * Demo (Graphics) ====
# see the reference book 1.3.1 
demo(graphics)
demo(persp)
# demo(plotmath)
demo()

# * Workspace ====
# see the reference book 1.3.3
getwd() # get current working directory
# the working directory would be the project directory if this is RStudio Project
# for non-project, this parameter can be changed in Tools->Global Options

options(digits = 2)
x <- runif(20)
summary(x)

ls() # list the objects in the current workspace
save.image() # creating ".RData" in current working directory
rm(list = ls()) # remove all objects
ls()
# Note the changes in the Global Environment Window
load(".RData")

# * Packages ====
# see the reference book 1.4
# Many many packages (>18,000) available in R
# https://cran.r-project.org/web/packages/

# where the packages are stored in the local computer?
library() # listing of packages
search() # listing of attached packages and R objects

installed.packages() # details of installed packages
temp <- installed.packages()
fix(temp) # use data editor to view the information of installed packages
# you can also view this information from RStudio Packages panel

# * Demo (package) ====
# see the reference book 1.8

# vcd: visualizing categorical data
# load data and run example coding from online help of a package
help.start()
# check if the library exists before installing the package
if (!require(vcd)) {install.packages("vcd"); library(vcd)}
help(package = vcd)

data() # list all available data from loaded packages
data(package = "vcd") # list data only from a specific package
help(Arthritis)
example(Arthritis)
# negative side-effects of example function 
#    may include changing graphic parameters and never restoring back
par()$ask
par(ask = FALSE)

# Chapter 2 (Data) ----
# Creating a dataset

# * R Data Structures ====
# see the reference book 2.2
# see Figure 2.1 and the corresponding box for details (pg. 22)

#   Five basic data structures: vector, matrix, array, data frame, list
#   R objects include constants, data structures, functions, and graphs
#   each R object has a mode (how it is stored) and a class (how to handle it)

# ** vector ====
# see the reference book 2.2.1
a <- c(1, 2, 3, 4, 5, 6, 7) # combine function is used to combine a vector
b <- c("one", "two", "three")
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
# Note that the data in a vector must be only one type or mode (numeric, character, or logical)
mode(a); mode(b); mode(c) # storage mode
# refer to elements of a vector based on positions
a[c(1:3, 5)] # the colon operator generates a sequence of numbers
a[-c(1,3)]
rev(a) # reverse the order

# ^^ combine vectors of different modes ####
c(a,b) 
mode(c(a,b))
c(a,c)
mode(c(a,c))
c(a,b,c)

# ** matrix ====
y <- matrix(1:20, nrow=5, ncol=4) 
y # default the matrix is filled by columns

cells    <- c(1,2,3,4)   
rnames   <- c("R1", "R2")
cnames   <- c("C1", "C2")
mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,
                   dimnames=list(rnames, cnames))
mymatrix
mymatrix <- matrix(cells, nrow=2, ncol=2,  
                   dimnames=list(rnames, cnames))   
mymatrix

# ** array ====
# Arrays are similar to matrices but can have more than two dimensions
dim1 <- c("A1", "A2")
dim2 <- c("B1", "B2", "B3")
dim3 <- c("C1", "C2", "C3", "C4")
z <- array(1:24, dim = c(2, 3, 4), dimnames=list(dim1, dim2, dim3))
z # data is filled by columns just like vectors
dim(z)
# compared with a matrix
dim(mymatrix) 

# ** data frame ====
patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
patientdata <- data.frame(patientID, age, diabetes, status)
patientdata
# Each column must have only one mode, 
# but you can put columns of different modes together to form the data frame

# cross-tabulate diabetes type by status
table(patientdata$diabetes, patientdata$status) 
# use $ to access a specific column 

# ^^ attach and with functions ####
help("mtcars")
# use $ to access a specific column 
# repetitive references to the same data frame object
summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)
plot(mtcars$mpg, mtcars$wt)

# attach the data frame object in the search path
attach(mtcars)
  summary(mpg)
  plot(mpg, disp) # note x, y labels become much neat
  plot(mpg, wt)
detach(mtcars)

# the problem of using attach function
# name conflicts 
mpg <- c(25, 36, 47)
attach(mtcars) 
# mpg object has already been defined in the global environment
# but mtcars data frame also has a column named mpg
# when attaching mtcars, the mtcars$mpg is masked by global env.
# that is to say, the original object takes precedence
plot(mpg, wt) 
# this plot fn. no longer works, as the original mpg object only has three elements

# using with function to
#      evaluate an expression in a data environment
# syntax: with (data, expr, ...)
#    where expr is often a "compound" expression enclosed by brackets
#   { statements ... } 
with(mtcars, { 
  print(summary(mpg))
  plot(mpg, wt)
}) 

# The limitation of the with() function is that 
#     assignments exist only within the compound expression brackets

# If you need to create objects that will exist outside of the with()
#  use the special assignment operator <<- 
#  instead of the standard one <-
with(mtcars, {
  nokeepstats <- summary(mpg)
  keepstats <<- summary(mpg) # global assignment operator <<-
})
nokeepstats # this object doesn't exist outside the with block
keepstats # this object exists outside the with block

# ** factor ====
# Three types of variables: nominal, ordinal, continuous (pg.28)
# Factors include categorical (nominal) 
#         and ordered categorical (ordinal) variables 

# ^^ nominal factor ####
diabetes <- c("Type1", "Type2", "Type1", "Type1")
diabetes
class(diabetes) # character vector
mode(diabetes)

diabetes <- factor(diabetes)
# The function factor() stores the categorical values 
#    as a vector of integers in the range [1 ... k]
#    (where k is the number of unique values in the nominal variable)
#    and an internal vector of character strings 
#    (the original values) mapped to these integers
diabetes
class(diabetes)
mode(diabetes) 
# the real value is c(1,2,1,1) with 1 indicating Type1 
#     and 2 indicating Type2
as.numeric(diabetes)
# diabetes is a nominal variable

# ^^ ordinal factor ####
status <- c("Poor", "Improved", "Excellent", "Poor")
status <- factor(status, ordered=TRUE)
# Add the parameter ordered=TRUE to the factor() function
status 
#  factor levels for character vectors are created 
#         in alphabetical order
as.numeric(status)
# ^^ order of the levels ####
# By default, factor levels are in alphabetical order
# You can override the default by specifying a levels option
status <- factor(status, order=TRUE,
                 levels=c("Poor", "Improved", "Excellent"))
status
as.numeric(status)

# ^^ labels for the levels ####
# numeric variables can be coded as factors using the levels 
#        and labels options
gender <- c(1,1,2,1,2,2)
gender <- factor(gender, levels=c(1, 2), labels=c("Male", "Female"))
gender
as.numeric(gender)

# ** list ====
# A list is an ordered collection of objects (components)
g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- c("one", "two", "three")
mylist <- list(title = g, age = h, j, k)
mylist # print entire list


# ^^ double vs. single brackets ####
# use double brackets to access the list component by index or name
mylist[[1]] 
mylist[["age"]]
mylist[[3]]
mylist$title # For named components, $ operator also works

# use single brackets to access a sub-list
mylist[1]
mylist[3]

class(mylist[1])
class(mylist[[1]])
class(mylist[3])
class(mylist[[3]])

mode(mylist[3])
mode(mylist[[3]])

# * Import Data ====
# # see reference book 2.3
# A definitive guide  http://mng.bz/urwn

# ** from keyboard ====
# see reference book 2.3.1
# edit () and fix()

# create an empty data frame
mydata <- data.frame(age=numeric(0), 
                     gender=character(0), weight=numeric(0))
# invoke the text editor to add data and save the results
mydata <- edit(mydata)
mydata
# invoke edit and then assign the newly edited version data
fix(mydata)

# ** from text file ====
# see reference book 2.3.2
# read.table()

# Create a data from keyboard, then output it to a text file
mydata.txt <- "StudentID,First,Last,Math,Science,Social Studies
011,Bob,Smith,90,80,67
012,Jane,Weary,75,,80
010,Dan,\"Thornton, III\",65,75,70
040,Mary,\"O\'Leary\",90,95,92"
# output the data
writeLines(mydata.txt, "grades_data.csv")

# read a table directly from a CVS file
grades <- read.table(file = "grades_data.csv", header=TRUE, sep=",",
                      stringsAsFactors = TRUE) 
grades
str(grades)
# see pg. 36 for nuances of this importing process

# read the table with updated parameters
grades <- read.table(file = "grades_data.csv", header=TRUE, sep=",",
                     row.names="StudentID",
                     colClasses = c(rep("character", 3), rep("numeric", 3))
                     ) 
grades
str(grades)