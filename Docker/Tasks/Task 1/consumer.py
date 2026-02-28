import time
# Wait 15 seconds before continue the code after container starts
time.sleep(15)
# Allocate 45MB of memory 
data1 = bytearray(45 * 1024 * 1024) 
time.sleep(5)
#Allocate 15MB of memory now the allocated is 60MB
data2 = bytearray(15 * 1024 * 1024)

# Infinite loop to keep the container running as if py code end container will die
while True:
    time.sleep(1)