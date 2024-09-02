#!/usr/bin/python3

lower = int(input("lower num is:"))   
upper = int(input("upper num is:"))   
for num in range(lower,upper+1):
    sum=0
    n=len(str(num))
    temp=num
    while temp>0:
        digit=temp%10
        sum+=digit**n
        temp//=10
    if num==sum:
        print(num,"is amstls")    

