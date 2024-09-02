#!/usr/bin/python3

def zdgys(x,y):
    if x>y:
        smaller=y
    else:
        smaller=x
    for i in range(1,smaller+1):    
        if((x%i==0)and(y%i==0)):
            zdgys=i
    return zdgys 
num1 = int(input("num1 is:"))   
num2 = int(input("num2 is:"))   
print(num1,"and",num2,"dui da gong yue shu is",zdgys(num1,num2))

