
############ Run the following code in R session.  ~Quantslob



n <- 3 ### number of doors
r <- 1 ### number of losing doors revealed by host, must be > 0 AND < n - 1
nn <- 20000 #### total number of simulations

#############

os_wins <- logical(nn)
sw_wins <- logical(nn)
d_space <- I(1:n)

xxnow <- Sys.time()

kk <- 0
while(kk < nn) {
    kk <- kk + 1
    door_prize <- sample(d_space, size=1)
    door_select <- sample(d_space, size=1)
    
    doors_can_reveal <- setdiff(d_space, c(door_prize, door_select))
    doors_revealed <- doors_can_reveal[ sample(length(doors_can_reveal), size=r) ]
    
    doors_can_switch <- setdiff(d_space, c(door_select, doors_revealed))
    door_switch <- doors_can_switch[ sample(length(doors_can_switch), size=1) ]
    
    os_wins[kk] <- door_prize == door_select
    sw_wins[kk] <- door_prize == door_switch
}

cat("proportion original selection wins: ", sum(os_wins) / nn, "\n")

cat("proportion switching wins: ", sum(sw_wins) / nn, "\n")

cat("run time:", difftime(Sys.time(), xxnow, units="sec"), "secs", "\n")


