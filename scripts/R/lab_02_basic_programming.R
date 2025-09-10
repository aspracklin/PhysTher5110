# Task 1
# Assigning variables
num1 <- 15
num2 <- 7

# Performing mathematical operations
sum_result <- num1 + num2
diff_result <- num1 - num2
prod_result <- num1 * num2
quotient_result <- num1 / num2

print("Task 1 Results:")
print(paste("Sum:", sum_result))
print(paste("Difference:", diff_result))
print(paste("Product:", prod_result))
print(paste("Quotient:", quotient_result))


# Task 2
# create age vector
ages <- c(25, 30, 22, 40, 28)

# take mean 
average_age <- mean(ages)
# add 5 to each value of ages
updated_ages <- ages + 5

print("\nTask 2 Results:")
print(paste("Average Age:", average_age))
print("Updated Ages:")
print(updated_ages)


# Task 3
# assign temperature value
temperature <- c(20,24,26,30)

# create conditional statement - created a loop to check for various temperatures
for (i in 1:4) {
  temp = temperature[i]
  print(i)
  if (temp > 25) {
    print("It's a hot day!")
  } else {
    print("It's a pleasant day!")
  }
}

# Task 4
print("\nTask 4 Results:")
for (i in 1:10) {
  square <- i^2
  print(paste(i, ":", square))
}

# Added a while loop for the same thing
var <- 1
while (var <= 10) {
  square <- var^2
  print(paste(var, ':', square))
  var = var+1
}


# Task 5
# define function to calculate the area
calculate_area <- function(length, width) {
  area <- length * width
  return(area)
}

# set length and width to use as inputs
rectangle_length <- 8
rectangle_width <- 5

# run function 
area_result <- calculate_area(rectangle_length, rectangle_width)

print("\nTask 5 Results:")
print(paste("Area of Rectangle:", area_result))



# Task 6
# create data structure
students <- data.frame(
  name = character(0), # define name will be characters
  grade = integer(0), # define grade will be integers
  score = numeric(0) # define scores will be numerics
)

# enter data into data structure
student_names <- c("Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan")
grades <- c("Freshman", "Sophomore", "Junior")
scores <- sample(60:100, 9 * length(grades), replace = TRUE)

students <- data.frame(
  name = rep(student_names, length(grades)), # make everything the same size
  grade = rep(grades, each = length(student_names)),
  score = scores
)


# take mean of scores across grades
average_scores <- tapply(students$score, students$grade, mean)
print(average_scores)

# Task 7
# create data
student_names <- c("Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan","Emma")# added one name for 10 students
grades <- c(7,8,9)
alg_scores <- rnorm(10*length(grades),mean = 70, sd = 10) # sample a normal distribution with parameters as assigned
ari_scores <- rnorm(10*length(grades),mean = 85, sd = 5)

# create data frame
students_alg_ari = data.frame(
  name = rep(student_names,length(grades)),
  grade = rep(grades, each = length(student_names)),
  alg_scores = alg_scores,
  ari_scores = ari_scores
)
# Plot
plot(students_alg_ari$grade,students_alg_ari$alg_scores,col='red')
points(students_alg_ari$grade,students_alg_ari$ari_scores,col='blue')
legend("bottom", legend = c("algebra", "arithmetic"), col = c("red", "blue"), lty = 1)

# Bonus question
alg_scores <- rnorm(10*length(grades),mean = 75, sd = 10) # sample a normal distribution with parameters as assigned
ari_scores <- alg_scores + rnorm(10*length(grades),mean = 10, sd = 10) # students score 10 points higher on average in arithmetic than algebra
for (i in 1:length(alg_scores)) { 
  if (ari_scores[i]>=100){
    ari_scores[i] = 100; # no extra credit
  }
}
plot(alg_scores,ari_scores)
