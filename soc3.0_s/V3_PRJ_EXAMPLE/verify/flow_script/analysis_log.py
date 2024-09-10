import os
import sys
import re
import argparse
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from argparse import Action
PRJ_ROOT       = os.environ.get('PRJ_ROOT')
if "ERROR_LEVEL" in os.environ:
    ERROR_LEVEL = 0
else:
    ERROR_LEVEL = 1

def print_pass():
    print("pass")


def print_fail():
    print("fail")

def analysis_pre_sim_log(dir=''):
    report_pre_sim_f = open(dir+"/test_result.log","a")
    report_pre_tmp_sim_f = open(dir+"/result.log","a")
    report_pre_sim_f.write(cmd_args.case+ ":PRE SIM FAIL"+",seed=" + cmd_args.seed + "\n")
    tmp = re.search("(.*)\.(.*)",cmd_args.case)
    test_name = tmp.group(2)
    test_file = tmp.group(1)
    report_pre_tmp_sim_f.write(test_name + (30-len(test_name)) * " " + "PRE COMP FAIL" + 17*" " +  cmd_args.seed + (30-len( cmd_args.seed))*' '+"\n")
    report_pre_sim_f.close()
    report_pre_tmp_sim_f.close()

def analysis_pre_comp_log(dir=''):
    report_pre_comp_f = open(dir+"/test_result.log","a")
    report_pre_tmp_comp_f = open(dir+"/result.log","a")
    report_pre_comp_f.write(cmd_args.case+ ":PRE COMP FAIL"+",seed=" + cmd_args.seed + "\n")
    tmp = re.search("(.*)\.(.*)",cmd_args.case)
    test_name = tmp.group(2)
    test_file = tmp.group(1)
    report_pre_tmp_comp_f.write(test_name + (30-len(test_name)) * " " + "PRE SIM FAIL" + 18*" " +  cmd_args.seed + (30-len( cmd_args.seed))*' '+"\n")
    report_pre_comp_f.close()
    report_pre_tmp_comp_f.close()

def analysis_sim_log(file='',dir=''):
    fail = 0
    ####print("analysis_sim_log")
    sim_f = open(file,"r")
    content = sim_f.readlines()
    fail_reason = ''
    for line in content:
        if(ERROR_LEVEL==1):
            if(re.search("(^Error)|(^FATAL)|(^fail)|(UVM_ERROR)|(UVM_FATAL)",line,re.I)!=None):   
                if(re.search("UVM_ERROR :.*(\d+)|(UVM_FATAL :.*(\d+))",line)==None):
                    if(error_waiver_get(line)):
                        fail_reason = line.replace("\n",'')
                        fail = 1
                        break
        else:
            if(re.search("(Error)|(FATAL)|(fail)|(UVM_ERROR)|(UVM_FATAL)",line,re.I)!=None):   
                if(re.search("UVM_ERROR :.*(\d+)|(UVM_FATAL :.*(\d+))",line)==None):
                    if(error_waiver_get(line)):
                        fail_reason = line.replace("\n",'')
                        fail = 1
                        break
    sim_f.close()
    report_sim_f = open(dir+"/test_result.log","a")
    report_tmp_sim_f = open(dir+"/result.log","a")
    tmp = re.search("(.*)\.(.*)",cmd_args.case)
    test_name = tmp.group(2)
    test_file = tmp.group(1)
    if(fail==1):
        report_sim_f.write(cmd_args.case+ ":SIM FAIL,fail message: "+ fail_reason+",seed=" + cmd_args.seed + "\n")
        report_tmp_sim_f.write(test_name + (30-len(test_name)) * " " + "COMPILE FAIL" + 18*" " +  cmd_args.seed + (30-len( cmd_args.seed))*' ' + fail_reason+"\n")
    else:
        report_sim_f.write(cmd_args.case+ ":SIM FASS,\n")
        report_tmp_sim_f.write(test_name + (30-len(test_name)) * " " + "SIM FASS" + 22*" " +  cmd_args.seed + (30-len( cmd_args.seed))*' '+"\n")
    report_sim_f.close()
    report_tmp_sim_f.close()

def analysis_compile_log(file='',dir=''):
    ###print("analysis_compile_log")
    fail = 0
    comp_f = open(file,"r")
    content = comp_f.readlines()
    fail_reason = ''
    for line in content:
        if(ERROR_LEVEL==1):
            if(re.search("(^Error)|(^FATAL)",line,re.I)!=None):   
                if(1):
                    fail_reason = line.replace("\n",'')
                    fail = 1
                    break
        else:
            if(re.search("(Error)|(FATAL)",line,re.I)!=None):   
                if(1):
                    fail_reason = line.replace("\n",'')
                    fail = 1
                    break
    comp_f.close()
    report_comp_f = open(dir+"/test_result.log","a")
    report_tmp_comp_f = open(dir+"/result.log","a")
    if(fail==1):
        #####print("case:::"+cmd_args.case)
        test_list = cmd_args.case.split(",")
        seed_list = cmd_args.seed.split(",")
        # print(test_list)
        # print(seed_list)
        # print(len(test_list))
        for i in range(len(test_list)):
            tmp = re.search("(.*)\.(.*)",test_list[i])
            test_name = tmp.group(2)
            test_file = tmp.group(1)
            report_comp_f.write(test_list[i]+ ":COMPILE FAIL,fail message: "+ fail_reason+",seed=" + seed_list[i] + "\n")
            report_tmp_comp_f.write(test_name + (30-len(test_name)) * " " + "COMPILE FAIL" + 18*" " + seed_list[i] + (30-len(seed_list[i]))*' ' + fail_reason+"\n")
        if(cmd_args.num==1):
            print("COMPILE FAIL")
            print("compile.log: "+file)
    report_comp_f.close()
    report_tmp_comp_f.close()
def waiver_get():
    global waiver_message
    #waiver_message= {}
    waiver_message["all"] = []
    waiver_f = open(PRJ_ROOT+"/verify/flow_script/error_waiver.txt","r")
    content = waiver_f.readlines()
    for line in content:
        if(line!=''):
            if(re.search(":",line)!=None):
               tmp = re.search("(.*):(.*)",line)
               message = tmp.group(2)
               if(re.search("\.",line)!=None):
                   tmp2 = re.search("(.*)\.(.*)",tmp.group(1))
                   test_file = tmp2.group(1)
                   test_name = tmp2.group(2)
                   if(test_file not in waiver_message):
                       waiver_message[test_file] = {}
                       waiver_message[test_file]["all"] = []
                   if(test_name not in waiver_message[test_file]):
                       waiver_message[test_file][test_file] = []
                   waiver_message[test_file][test_file].append(message)
               else:
                   test_file = tmp.group(1)
                   if(test_file not in waiver_message):
                       waiver_message[test_file] = {}
                       waiver_message[test_file]["all"] = []
                   waiver_message[test_file]["all"].append(message)
            else:
                waiver_message["all"].append(line.replace("\n",'').replace(" ",''))     
def error_waiver_get(line ='',test_file=''):
    global waiver_message
    result = 1
    tmp111 = re.search("(.*)\.(.*)",cmd_args.case)
    test_name = tmp111.group(2)
    test_file_sel = tmp111.group(1)

    ###print("error_waiver_get: " + line)
    for test_file in waiver_message:
        if(test_file=="all"):
            for all_waiver in waiver_message["all"]:
                if(re.search(all_waiver,line)!=None):
                    result = 0
        else:
            for test in waiver_message[test_file_sel]:
                if(test == "all"):
                    for all_waiver1 in waiver_message["all"]:
                        if(re.search(all_waiver1,line)!=None):
                            result = 0
                else:
                    for all_waiver2 in waiver_message[test]:
                        if(re.search(all_waiver2,line)!=None):
                            result = 0
                        
    return result

def print_report_message(file= ''):
    fail_num = 0 
    case_num = 0
    ####print("print_report_message")
    report_f = open(file,"r")
    content = report_f.readlines()
    line_tmp =''
    for line in content:
        if(re.search("(fail)|(FAIL)",line)!=None):
            fail_num+=1
            line_tmp = line
        case_num +=1    
    print("RUN RESULT: ")
    if(fail_num!=0):
        print_fail()
    else:
        print_pass()
    if(case_num>1):
        print("PASS RATA: " + str((1-fail_num/case_num)*100) + "%")
    else:
        if(line_tmp!=''):
            print("fail_meassge: " + line_tmp)
    if(cmd_args.email!=''):
        report_f1 = open(file.replace("test_result.log","result.log"),"r")
        content11 = report_f1.readlines()
        total_message = ""
        for line1 in content11:
            total_message += line1
        send_email(cmd_args.email,total_message)
        report_f1.close()
    report_f.close()

def send_email(email="",message="hello world"):
    sender_email = "1111@qq.com"
    sender_pwd = "1111"
    receiver_email = email
    print(receiver_email)
    subject = "regression result"
    smtp_server = "smtp.qq.com"
    smtp_port = 465
    ret = True
    try:
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = receiver_email
        msg['Subject'] = subject
        body =cmd_args.report + "\n" + message
        msg.attach(MIMEText(body, 'plain'))

        with smtplib.SMTP_SSL(smtp_server, smtp_port) as smtp:
            smtp.login(sender_email, sender_pwd)
            smtp.sendmail(sender_email, receiver_email.split(","), msg.as_string())
        print("email success!")
    except Exception as e:
           print("email fail", e) 

def main(cmd_args=any):
    ##print("main")
    global waiver_message
    #waiver_message ={}
    #waiver_get()
    ###print(waiver_message)
    if(cmd_args.type=='pre_sim'):
        analysis_pre_sim_log(cmd_args.dir)
    if(cmd_args.type=='pre_compile'):
        analysis_pre_comp_log(cmd_args.dir)    
    if(cmd_args.type=='sim'):
        waiver_message ={}
        waiver_get()
        analysis_sim_log(cmd_args.log,cmd_args.dir)
    if(cmd_args.type=='comp'):
        analysis_compile_log(cmd_args.log,cmd_args.dir)
    if(cmd_args.report!=''):
        print_report_message(cmd_args.report)
        #if(cmd_args.email!=''):
            #send_email(cmd_args.email)


if __name__== "__main__" :
    global cmd_args
    parser  = argparse.ArgumentParser()
    parser.add_argument("-case",default="",help="dump waveform option")
    parser.add_argument("-num",default=1,help="dump waveform option")
    parser.add_argument("-seed",default="",help="dump waveform option")
    parser.add_argument("-type",default="",help="dump waveform option")
    parser.add_argument("-dir",default="",help="dump waveform option")
    parser.add_argument("-log",default="",help="dump waveform option")
    parser.add_argument("-report",default="",help="dump waveform option")
    parser.add_argument("-email",default="",help="dump waveform option")
    parser.add_argument("-debug",action="store_true",help="dump waveform option")
    cmd_args = parser.parse_args()
    main(cmd_args)
