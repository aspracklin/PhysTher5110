# 1a. Element-wise multiplication without loops
dat <- matrix(c(16, 2, 3, 13,
                5, 11, 10, 8,
                9, 7, 6, 12,
                4, 14, 15, 1), nrow = 4, ncol = 4, byrow = TRUE)
dat

vect <- 1:4
vect

# Row-wise multiplication
rowMultiplier <- dat * vect # multiplies each row of the matrix by the vector in column form?

# Column-wise multiplication
colMultiplier <- t(t(dat) * vect) # multiplies each row of the matrix by the vector in row form?

cat("Row-wise multiplication:\n")
print(rowMultiplier)

cat("\nColumn-wise multiplication:\n")
print(colMultiplier)

# 1b. Vectorized alternative to replace loops
set.seed(123)  # Setting seed for reproducibility
data <- -2 + (2+2) * matrix(runif(10000 * 20000), nrow = 10000, ncol = 20000)

max(data)
min(data)

data[data>1] = 0
# loop-based solution
#for (i in 1:10000) {
#  for (j in 1:20000) {
#    if (data[i, j] > 1) {
#      data[i, j] <- 0
#    }
#  }
#}

# Vectorized replacement of values greater than 1 with 0
#data[data > 1] <- 0

# 1c. Finding the maximum value without loops
x <- 1:7
y <- 1:5

sinX = sin(x);
cosY = cos(y);

mat = outer(sinX,cosY,'*')

maxVal = max(mat)
print(maxVal)
indices <- which(mat == maxVal, arr.ind = TRUE)
print(indices)


### provided solution
X <- matrix(rep(x, each = length(y)), nrow = length(y), ncol = length(x), byrow = TRUE)
Y <- matrix(rep(y, times = length(x)), nrow = length(y), ncol = length(x), byrow = TRUE)

X
Y

maxVal <- max(max(sin(X) * cos(Y)))

# Finding the location of the maximum value
max_indices <- which(sin(X) * cos(Y) == maxVal, arr.ind = TRUE)
max_indices

cat(paste("The biggest element in XY is", maxVal, "at XY(", max_indices[1], ",", max_indices[2], ")\n"))


# Forward Kinematics
L_UA = 0.32
L_FA = 0.3
q = c(pi/4, pi/3) # relative joint angles

forwardKinematics <- function(q,L_UA, L_FA){
  elbow_position = L_UA*c(cos(q[1]),sin(q[1]))
  hand_position = elbow_position+L_FA*c(cos(q[1]+q[2]),sin(q[1]+q[2]))
  Positions <- list("elbow_position" = elbow_position,"hand_position" = hand_position)
  return(Positions)
}

Positions <- forwardKinematics(q,L_UA,L_FA)
plot(c(0,Positions$elbow_position[1],Positions$hand_position[1]),c(0,Positions$elbow_position[2],Positions$hand_position[2]),'b')

segment_lengths = c(L_UA,L_FA)
fkh <- function(q,segment_lengths){
  N_segments = length(q)
  p = matrix(0:0,nrow=N_segments+1,ncol=2)
  for (i in 1:N_segments) {
    if (i == 1){
      jt_angle = q[1]
    }
    else{
      jt_angle = sum(q[1:i])
    }
    p[i+1,1] = p[i,1] + segment_lengths[i]*cos(jt_angle)
    p[i+1,2] = p[i,2] + segment_lengths[i]*sin(jt_angle)
  }
  return(p) # for the record, I'm pretty sure this would work as long as the problem is 2D
}

fkh2 <- function(q,segment_lengths){
  N_segments = length(q)
  R = array(0:0, dim = c(4,4,2*N_segments))
  for (i in 1:N_segments) {
    R[,,2*i-1] = t(matrix(c(cos(q[i]),-sin(q[i]),0,0,sin(q[i]),cos(q[i]),0,0,0,0,1,0,0,0,0,1),nrow=4,ncol=4))
    R[,,2*i] = t(matrix(c(1,0,0,segment_lengths[i],0,1,0,0,0,0,1,0,0,0,0,1),nrow=4,ncol=4))
  }
  H = diag(4)
  for (i in 1:N_segments){
    H <- H%*%R[,,2*i-1]%*%R[,,2*i]
  }
  return(H)
}

H_elbow = fkh2(q[1],segment_lengths[1])
p0_elbow = c(0,0,0,1)
p_elbow = H_elbow%*%p0_elbow

H_hand = fkh2(q,segment_lengths)
p0_hand = c(0,0,0,1) 
p_hand = H_hand%*%p0_hand

plot(c(0,p_elbow[1],p_hand[1]),c(0,p_elbow[2],p_hand[2]),'b') 
print(Positions$hand_position-c(p_hand[1],p_hand[2]))


## 2C
segment_lengths = c(0.32,0.3,0.4)
q1=c(pi/4,pi/2,-pi/3)
q2=c((2*pi)/3,-pi/4,pi/2)

N_segments = length(q1)
p = matrix(0:0,nrow=N_segments+1,ncol=2)
pp = matrix(0:0,nrow=N_segments+1,ncol=2)
for(i in 1:N_segments){
  Hp = fkh2(q1[1:i],segment_lengths[1:i])
  p0 = c(0,0,0,1)
  p1 = Hp%*%p0
  p[i+1,1]=p1[1]
  p[i+1,2]=p1[2]
  Hpp = fkh2(q2[1:i],segment_lengths[1:i])
  pp0 = c(0,0,0,1)
  pp1 = Hpp%*%pp0
  pp[i+1,1]=pp1[1]
  pp[i+1,2]=pp1[2]
}

plot(c(p[,1],pp[,1]),c(p[,2],pp[,2]),'b')
