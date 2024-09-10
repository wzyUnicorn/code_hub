import os
import sys
import re
import argparse
import time
from argparse import Action
PRJ_ROOT       = os.environ.get('PRJ_ROOT')

def main(cmd_args=any):
    if(cmd_args.list==False):
        tmp_status = re.search("(.*)_(.*)",cmd_args.status)
        test_file = tmp_status.group(1)
        date_time = tmp_status.group(2)
        print("test_file:" + test_file)
        print("date_time:" + date_time)
        if(cmd_args.dir==""):
            result_log = PRJ_ROOT + "/output/regression/report/" +test_file+"_"  + date_time + "/test_result.log"
        else:
            result_log = PRJ_ROOT + "/output/" + cmd_args.dir + "/report/" +test_file+"_"  + date_time + "/test_result.log"
        run_log = result_log.replace("result",'run')
        run_f = open(run_log,"r")
        result_f = open(result_log,"r")
        result_content = result_f.readlines()
        run_content = run_f.readlines()
        test_list = run_content
        test_status_dict = {}
        for test in test_list:
            print(test)
            test = test.replace("\n",'')
            if(test!=""):
                for line in result_content:
                    if(re.search(test+":",line)!=None):
                        tmp =  re.search(test+ ":(.*)?",line)
                        ###print(line)
                        ###print(tmp.group(1))
                        test_status_dict[test] = tmp.group(1)
                        break
                    else:
                        test_status_dict[test] = "running"
        ######print(test_status_dict)
        print("test_name"+ 50*" " + "status")
        for test in test_status_dict:
            test_tmp = test.replace(test_file+".",'')
            print(test_tmp+ (59-len(test_tmp))*" " + test_status_dict[test])
    else:
        list_f = open(PRJ_ROOT+"/output/flow_record.txt","r")
        list_content = list_f.readlines()
        list_f.close()
        status_dict = {}
        tmp22 = re.search("test_file:(.*),dir:(.*),date:(.*)",list_content[-1])
        print(list_content)

        print(tmp22)

        date22 = tmp22.group(3)
        tmp33 = re.search("(.*)-(.*)",date22)
        date_day22 = tmp33.group(1)
        print("latest_date:" + date_day22)
        day2 =date_day22##"20230101"
        list_content_copy = []
        for list in list_content:
            if(list!=""):
                tmp = re.search("test_file:(.*),dir:(.*),date:(.*)",list)
                test_file = tmp.group(1)
                dir = tmp.group(2)
                date = tmp.group(3)
                print("file_name:" + test_file)
                print("dir:" + dir)
                print("date:" + date)
                tmp1 = re.search("(.*)-(.*)",date)
                date_day = tmp1.group(1)
                print("day:" + date_day)
                
                time_array1 = time.strptime(date_day, "%Y%m%d")
                timestamp_day1 = int(time.mktime(time_array1))          
                time_array2 = time.strptime(day2, "%Y%m%d")
                timestamp_day2 = int(time.mktime(time_array2))    
                days_dif = (timestamp_day2 - timestamp_day1) // 60 // 60 // 24
                print(days_dif)
                if(days_dif<30):
                    list_content_copy.append(list)
                    status_dict[date] = {}
                    status_dict[date]["test_file"] = test_file
                    status_dict[date]["status"] = ""
                    status_dict[date]["dir"] = dir.replace(PRJ_ROOT+"/output/","")

                    tmp_status = re.search("(.*)_(.*)",cmd_args.status)
                    status = "null"
                    result_log = dir + "/report/" +test_file+"_"  + date + "/test_result.log"
                    run_log = result_log.replace("result",'run')
                    run_f = open(run_log,"r")
                    result_f = open(result_log,"r")
                    result_content = result_f.readlines()
                    run_content = run_f.readlines()
                    if(len(result_content)!=len( run_content)):
                        status = "running"
                    else:
                        status = "done"
                    status_dict[date]["status"] = status
        #print("status_dict")
        #print(status_dict)
        print("Regression Status")
        print("DATE" + 30*" " + "TEST_FILE" + 30*" " + "DIR" + 30*" " + "STATUS" + 30*" " + "DETAIL")
        for single_date in status_dict:
            tf = status_dict[single_date]["test_file"]
            d  = status_dict[single_date]["dir"]
            st = status_dict[single_date]["status"]
            if(d=="regression"):
                print(single_date + (34-len(single_date))*" " + tf + (39-len(tf))*" " + d + (33-len(d)) * " " + st + (36-len(st))*" " +"ycheck -status " +tf+"_"+single_date)
            else:
                print(single_date + (34-len(single_date))*" " + tf + (39-len(tf))*" " + d + (33-len(d)) * " " + st + (36-len(st))*" " +"ycheck -status " +tf+"_"+single_date + " -dir " + d)
        new_list_f = open(PRJ_ROOT+"/output/flow_record.txt","w")
        for line in list_content_copy:
            new_list_f.write(line)
        new_list_f.close()
if __name__== "__main__" :
    global cmd_args
    parser  = argparse.ArgumentParser()
    parser.add_argument("-list",action="store_true",help="dump waveform option")
    parser.add_argument("-status",default="",help="dump waveform option")
    parser.add_argument("-dir",default="",help="dump waveform option")
    cmd_args = parser.parse_args()
    main(cmd_args)
