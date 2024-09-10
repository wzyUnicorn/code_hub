import os
import sys
import re
import time
import argparse
from argparse import Action
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
WORK_DIR       = os.environ.get('PRJ_ROOT') + '/work'
prompt ="\nEnter 'yes' or 'quit' to continue "
def main(cmd_args=any):
    ##print("main")
    result = 0
    #os.system("cd " + PRJ_ROOT+ ";git status")
    os.system("git status")

    print("please confirm the edit file!")
    active=True
    while active:
        message=input(prompt)
        if message=='quit':
            exit()
        elif message=='yes':
            print("continue")
            active=False
    #os.system("cd " + PRJ_ROOT+ ";git fetch origin")
    os.system("python3 $PRJ_ROOT/verify/flow_script/v3flow_run.py -testfile test_file -testname test1 -timestr "+ timestr)
    result_f = open(WORK_DIR+"/report/test_file_"+timestr+"/test_result.log")
    content = result_f.readlines()
    for line in content:
        if(re.search("FAIL",line)!=None):
            result = 1
            break
    if(result==1):
        print("fail to commit")
    else:
        os.system("git commit -m " + cmd_args.m)

if __name__== "__main__" :
    global cmd_args
    timestr = time.strftime("%Y%m%d-%H%M%S")
    parser  = argparse.ArgumentParser()
    parser.add_argument("-m",default="",help="dump waveform option")
    cmd_args = parser.parse_args()
    main(cmd_args)
