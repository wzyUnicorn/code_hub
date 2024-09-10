import os
import re
import sys
import argparse
from argparse import Action
import multiprocessing
from multiprocessing import Process
import time
from time import sleep
import random
import subprocess
import random 

PRJ_ROOT       = os.environ.get('PRJ_ROOT')
WORK_DIR       = os.environ.get('PRJ_ROOT') + '/work'
DV_DIR         = os.environ.get('PRJ_ROOT') + "/verify"


def fail_test_collect(log =""):
    log = log.replace("result.log",'test_result.log')
    fail_content_dict = {}
    print("collect fail test: "+ log)
    fail_log_f = open(log,'r') 
    fail_content = fail_log_f.readlines()
    for line in fail_content:
        if(re.search("fail",line)!=None):
            ###print("line:" + line)
            tmp = re.search("(.*)\.(.*?):.*seed=(\d+)",line)
            #print("test_file: " + tmp.group(1))
            #print("test_name: " + tmp.group(2).replace(tmp.group(3),""))
            #print("test_seed: " + tmp.group(3))
            test_file = tmp.group(1)
            test_name = tmp.group(2).replace("_"+tmp.group(3),"")
            test_seed = tmp.group(3)
            if(test_file not in fail_content_dict):
                fail_content_dict[test_file] = {}
            if(test_name not in fail_content_dict[test_file]):
                fail_content_dict[test_file][test_name] = []
            fail_content_dict[test_file][test_name].append(test_seed)
            cmd_args.testfile = test_file
    print("fail_content")
    print(fail_content_dict)
    ###exit()
            
    return fail_content_dict


def compile_information_collect(compile_file_name='',compile_list=list,work_location=''):
    collect_compile_content_dict = {}
    collect_compile_content_dict[compile_file_name] = {}
    compile_f = open(work_location+"/tmp_log/"+compile_file_name+"_compile.log","r")
    content = compile_f.readlines()
    ####print(content)
    for line in content:
        tmp_match = re.search("CREAT_COMPILE:COMPILE_NAME=(.*)::COMPILE_OPTION=(.*)::VLOGAN_OPTION=(.*)::PRE_COMPILE_CMD=(.*)::RTL_FILE=(.*)::VERIF_FILE=(.*)::", line)
        
        if(cmd_args.debug==True):
            print("COMPILE_NAME: " + tmp_match.group(1))
        compile_name = tmp_match.group(1)
        ####print(compile_list)
        if(compile_name in compile_list):
            compile_list.remove(compile_name)
            collect_compile_content_dict[compile_file_name][compile_name] = {}
            collect_compile_content_dict[compile_file_name][compile_name]["COMPILE_OPTION"] = tmp_match.group(2) +" " + cmd_args.comp_opt
            collect_compile_content_dict[compile_file_name][compile_name]['VLOGAN_OPTION']  = tmp_match.group(3)
            collect_compile_content_dict[compile_file_name][compile_name]['PRE_COMPILE_CMD']= tmp_match.group(4)
            collect_compile_content_dict[compile_file_name][compile_name]['RTL_FILE']       = tmp_match.group(5)
            collect_compile_content_dict[compile_file_name][compile_name]['VERIF_FILE']     = tmp_match.group(6)
            if(cmd_args.coverage!=""):
                 collect_compile_content_dict[compile_file_name][compile_name]["COMPILE_OPTION"] += " -cg_coverage_control=1 -cm_libsyv -cm_dir " + work_location + "/coverage/" + cmd_args.testfile + " -cm cond+line+tgl+cond+fsm+branch -cm_noconst -cm_hier " + cmd_args.coverage
    if(len(compile_list)!=0):
        print(compile_list)
        print("build number not correct")
    return collect_compile_content_dict

def test_information_collect(test_file_name="",test_list='',work_location='',select_seed_list =[]):
    global compile_dict
    global compile_number
    collect_test_content_dict = {}
    collect_test_content_dict[test_file_name] = {}
    testcase_f = open(work_location+"/tmp_log/"+test_file_name+"_testcase.log","r")
    content = testcase_f.readlines()
    if("all_test" == test_list):
        for line in content:
            tmp_match = re.search("TESTCASE:TEST_NAME=(.*)::COMPILE_FILE=(.*)::COMPILE_NAME=(.*)::SIM_OPTION=(.*):PRE_SIM_CMD=(.*)::TAG=(.*)::", line)
            if(cmd_args.debug==True):
                print("TEST_NAME: " + tmp_match.group(1))
            test_name = tmp_match.group(1)
            if(tmp_match.group(6)==cmd_args.tag or cmd_args.tag==""):
                collect_test_content_dict[test_file_name][test_name] = {}
                collect_test_content_dict[test_file_name][test_name]['COMPILE_FILE']   = tmp_match.group(2)
                collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   = tmp_match.group(3)
                collect_test_content_dict[test_file_name][test_name]['SIM_OPTION']     = tmp_match.group(4) + " " + cmd_args.sim_opt
                collect_test_content_dict[test_file_name][test_name]['PRE_SIM_CMD']    = tmp_match.group(5)
                collect_test_content_dict[test_file_name][test_name]['TAG']            = tmp_match.group(6)
                collect_test_content_dict[test_file_name][test_name]['SEED'] = []
                if(cmd_args.presim == True):
                     collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_presim"	
                if(cmd_args.postsim == True):
                     collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_postsim"	
                if(cmd_args.upf == True):
                     collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_upf"
                if(cmd_args.fpga == True):
                     collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_fpga"
                		
                if(len(select_seed_list)==0):
                    for i in range(int(cmd_args.repeat)):
                        if(cmd_args.repeat==1 and cmd_args.seed !=""):
                            seed = cmd_args.seed
                        else:
                            seed = str(random.randint(1,1000000000000000))
                        collect_test_content_dict[test_file_name][test_name]['SEED'].append(seed)
                else:
                    collect_test_content_dict[test_file_name][test_name]['SEED'] = select_seed_list

                compile_file = collect_test_content_dict[test_file_name][test_name]['COMPILE_FILE']
                compile_name = collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']
                if( compile_file not in compile_dict):
                    compile_dict[compile_file] = []
                    compile_dict[compile_file].append(compile_name)
                    compile_number +=1 
                else:
                    if(compile_name not in compile_dict[compile_file]):
                        compile_dict[compile_file].append(compile_name)
                        compile_number +=1 
    else:
        for line in content:
            tmp_match = re.search("TESTCASE:TEST_NAME=(.*)::COMPILE_FILE=(.*)::COMPILE_NAME=(.*)::SIM_OPTION=(.*)::PRE_SIM_CMD=(.*)::TAG=(.*)::", line)
            if(cmd_args.debug==True):
                print("TEST_NAME: " + tmp_match.group(1))
            test_name = tmp_match.group(1)
            ####print("test_list:" +test_list)
            if(tmp_match.group(1) == test_list):
                collect_test_content_dict[test_file_name][test_name] = {}
                collect_test_content_dict[test_file_name][test_name]['COMPILE_FILE']   = tmp_match.group(2)
                collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   = tmp_match.group(3)
                collect_test_content_dict[test_file_name][test_name]['SIM_OPTION']     = tmp_match.group(4)  + " " + cmd_args.sim_opt
                collect_test_content_dict[test_file_name][test_name]['PRE_SIM_CMD']    = tmp_match.group(5)
                collect_test_content_dict[test_file_name][test_name]['TAG']            = tmp_match.group(6)
                collect_test_content_dict[test_file_name][test_name]['SEED'] = []
                if(cmd_args.presim == True):
                    collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_presim"	
                elif(cmd_args.postsim == True):
                    collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_postsim"	
                if(cmd_args.upf == True):
                    collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_upf"
                if(cmd_args.fpga == True):
                    collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']   += "_fpga"

                if(len(select_seed_list)==0):
                    for i in range(int(cmd_args.repeat)):
                        if(cmd_args.repeat==1 and cmd_args.seed !=""):
                            seed = cmd_args.seed
                        else:
                            seed = str(random.randint(1,1000000000000000))
                        collect_test_content_dict[test_file_name][test_name]['SEED'].append(seed)
                else:
                    collect_test_content_dict[test_file_name][test_name]['SEED'] = select_seed_list

                compile_file = collect_test_content_dict[test_file_name][test_name]['COMPILE_FILE']
                compile_name = collect_test_content_dict[test_file_name][test_name]['COMPILE_NAME']
                if( compile_file not in compile_dict):
                    compile_dict[compile_file] = []
                    compile_dict[compile_file].append(compile_name)
                    compile_number +=1 
                else:
                    if(compile_name not in compile_dict[compile_file]):
                        compile_dict[compile_file].append(compile_name)
                        compile_number +=1
    ##print("collect_test_content_dict") 
    ##print(collect_test_content_dict)
    return collect_test_content_dict


def excute_the_py_file(file_name,work_location,loc):
    os.system("python3 " + loc + "/" + file_name + ".py -dir " + work_location+ "/tmp_log")
    #print("python3 " + loc + "/" + file_name + ".py -dir " + work_location+ "/tmp_log")


def show_all_select_test(test_content_dict=any):
    print("collect fail test")

def creat_compile_dir(compile_content_dict=any, work_location=""):
    global run_num
    for compile_file in compile_content_dict:
        if(os.path.exists(work_location+"/compile_loc/" + compile_file)==False):
            os.makedirs(work_location+"/compile_loc/" + compile_file)
        for compile_name in compile_content_dict[compile_file]:
            if(os.path.exists(work_location+"/compile_loc/" + compile_file + "/" +compile_name)==False):
                os.makedirs(work_location+"/compile_loc/" + compile_file + "/" +compile_name)
            loc = work_location+"/compile_loc/" + compile_file + "/" +compile_name
            if(cmd_args.debug == True):
                print("compile loc: " + loc)
            if(compile_content_dict[compile_file][compile_name]["PRE_COMPILE_CMD"]!=''):
                pre_compile_f = open(loc+"/pre_compile_cmd.csh","w+")
                pre_compile_cmd_list = compile_content_dict[compile_file][compile_name]["PRE_COMPILE_CMD"].split(",")
                for cmd in pre_compile_cmd_list:
                    pre_compile_f.write(cmd+"\n")
                    pre_compile_f.close()
                os.system("cd "+loc+";chmod 777 pre_compile_cmd.csh;")
            compile_f = open(loc+"/compile.csh","w+")
            if(compile_content_dict[compile_file][compile_name]["VLOGAN_OPTION"]!=''):
                compile_f.write("vlogan -full64 -ntb_opts uvm-1.1 +v2k -sverilog -kdb -error=noMPD +libext+.v+.vlib+.sv+.svh+.vp+.sva+.svp -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a -Mupdate -lca -debug_access+f -CFLAGS -DVCS +define+UVM_PACKER_MAX_BYTES=1500000 +define+UVM_DISABLE_AUTO_ITEM_RECORDING " +compile_content_dict[compile_file][compile_name]["VLOGAN_OPTION"]+" "+compile_content_dict[compile_file][compile_name]["RTL_FILE"]+ " "+ compile_content_dict[compile_file][compile_name]["VERIF_FILE"] + " -l vlogan.log \n")
            compile_f.write("vcs -full64 -ntb_opts uvm-1.1 +v2k -sverilog -kdb -error=noMPD +libext+.v+.vlib+.sv+.svh+.vp+.sva+.svp -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a -Mupdate -lca -debug_access+f -CFLAGS -DVCS +define+UVM_PACKER_MAX_BYTES=1500000 +define+UVM_DISABLE_AUTO_ITEM_RECORDING " + compile_content_dict[compile_file][compile_name]["COMPILE_OPTION"]+" "+compile_content_dict[compile_file][compile_name]["RTL_FILE"]+ " "+ compile_content_dict[compile_file][compile_name]["VERIF_FILE"] + " -l compile.log \n")
            compile_f.close()
            os.system("cd "+loc+";chmod 777 compile.csh;")

def creat_simulation_dir(test_content_dict=any, work_location=""):
    global compile2test_dict
    global run_num
    global compile_number
    #run_test_list = {}

    for test_file in test_content_dict:
        if(os.path.exists(work_location+"/report/"+test_file+"_"+timestr)==False):
            os.makedirs(work_location+"/report/"+test_file+"_"+timestr)
        test_result_report_f = open(work_location+"/report/"+test_file+"_"+timestr+"/test_run.log","w+")
        result_report_f = open(work_location+"/report/"+test_file+"_"+timestr+"/result.log","w+")
        result_report_f.write("TEST_FILE:"+ test_file + "\n")
        result_report_f.write("TEST_NAME"+ 21*' ' + "STATUS" +24*" "+"SEED"+26*" "+"FAIL REASON" + 20*" " +"\n")
        #run_test_list[test_file]={}
        if(os.path.exists(work_location+"/" + test_file)==False):
            os.makedirs(work_location+"/" + test_file)
        #print(test_content_dict[test_file])
        for one_test in test_content_dict[test_file]:
            #print(test_content_dict[test_file][one_test])
            for seed in test_content_dict[test_file][one_test]["SEED"]:
                # seed = ""
                # if(cmd_args.repeat==1 and cmd_args.seed !=""):
                #     seed = cmd_args.seed
                # else:
                #     seed = str(random.randint(1,1000000000000000))

                if(cmd_args.repeat==1 and cmd_args.seed =="" and cmd_args.rerun_fail==""):
                    if(os.path.exists(work_location+"/" + test_file + "/" + one_test)==False):
                        os.makedirs(work_location+"/" + test_file + "/" + one_test)
                    loc = work_location+"/" + test_file + "/" + one_test    
                else:
                    if(os.path.exists(work_location+"/" + test_file + "/" + one_test+"_"+seed)==False):
                        os.makedirs(work_location+"/" + test_file + "/" + one_test+"_"+seed)
                    loc = work_location+"/" + test_file + "/" + one_test +"_"+seed
                if(cmd_args.debug == True):
                    print("LOC: "+ loc)
                compile_file =test_content_dict[test_file][one_test]["COMPILE_FILE"]
                compile_name =test_content_dict[test_file][one_test]["COMPILE_NAME"]
                if(cmd_args.repeat==1 and cmd_args.seed =="" and cmd_args.rerun_fail==""):
                    one_test_tmp = one_test
                else:
                    one_test_tmp = one_test+"_"+seed
                if(compile_file not in compile2test_dict):
                    compile2test_dict[compile_file] ={}
                    compile2test_dict[compile_file][compile_name] = {}
                    compile2test_dict[compile_file][compile_name][test_file]= {}
                    compile2test_dict[compile_file][compile_name][test_file][one_test_tmp] ={}
                    compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["LOC"]= loc
                    compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["SEED"]= seed
                    test_result_report_f.write(test_file+"."+one_test_tmp+"\n")
                else:
                    if(compile_name not in compile2test_dict[compile_file]):
                        compile2test_dict[compile_file][compile_name] = {}
                        compile2test_dict[compile_file][compile_name][test_file]= {}
                        compile2test_dict[compile_file][compile_name][test_file][one_test_tmp] ={}
                        compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["LOC"]= loc
                        compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["SEED"]= seed
                        test_result_report_f.write(test_file+"."+one_test_tmp+"\n")
                    else:
                        if(test_file not in compile2test_dict[compile_file][compile_name]):
                            compile2test_dict[compile_file][compile_name][test_file]= {}
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp] ={}
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["LOC"]= loc
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["SEED"]= seed
                            test_result_report_f.write(test_file+"."+one_test_tmp+"\n")
                        else:
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp] ={}
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["LOC"]= loc
                            compile2test_dict[compile_file][compile_name][test_file][one_test_tmp]["SEED"]= seed
                            test_result_report_f.write(test_file+"."+one_test_tmp+"\n")
                os.system("rm -f " + loc + "/pre_compile_cmd.csh")
                os.system("rm -f " + loc + "/pre_sim_cmd.csh")
                sim_f = open(loc+"/run_sim.csh","w+")
                if(test_content_dict[test_file][one_test]["PRE_SIM_CMD"]!=''):
                    pre_sim_cmd_list = test_content_dict[test_file][one_test]["PRE_SIM_CMD"].split(",")
                    pre_sim_f = open(loc+"/pre_sim_cmd.csh","w+")
                    for cmd in pre_sim_cmd_list:
                        pre_sim_f.write(cmd+"\n")
                    pre_sim_f.close()
                    os.system("cd "+loc+";chmod 777 pre_sim_cmd.csh;")
                compile_loc = work_location+"/compile_loc/" + test_content_dict[test_file][one_test]["COMPILE_FILE"] + "/" +test_content_dict[test_file][one_test]["COMPILE_NAME"]
                if(cmd_args.coverage!=""):
                    test_content_dict[test_file][one_test]["SIM_OPTION"] += " -cm cond+line+tgl+fsm+branch +cov -cm_name " + one_test
                sim_f.write(compile_loc+"/simv +vcs+lic+wait +no_notifier +dontStopOnSimulError=1 +UVM_NO_RELNOTES +ntb_random_seed="+seed+" "+ test_content_dict[test_file][one_test]["SIM_OPTION"] + " -l simv.log\n")

                sim_f.close()
                os.system("cd "+loc+";chmod 777 run_sim.csh;")
                os.system("cd "+loc+";chmod 777 run_sim.csh;")
                run_num+=1
    test_result_report_f.close()


def run_compile(compile_file='',compile_name='',run_test_dict=any,compile_number=0,run_num=0,work_location=''):
    pre_comp_result = 0
    compile_result = 0
    run_compile_location = work_location + "/compile_loc/" + compile_file+"/"+compile_name
    if(compile_number>1):
        if(cmd_args.sim==False):
            if(os.path.exists(run_compile_location+"/pre_compile_cmd.csh")):
                pre_comp_result = subprocess.call("./pre_compile_cmd.csh;",cwd=run_compile_location,shell=True,stdout=subprocess.DEVNULL)
        if(pre_comp_result==0):
            if(cmd_args.sim==False):
                compile_result = subprocess.call("./compile.csh;",cwd=run_compile_location,shell=True,stdout=subprocess.DEVNULL)
            test_list = ""
            seed_list = ''
            for test_file in run_test_dict:
                for test_nmae in run_test_dict[test_file]:
                    test_list += test_file+"."+test_nmae + ","
                    seed_list += run_test_dict[test_file][test_nmae]["SEED"]+ ","
            test_list = test_list.rstrip(',')
            seed_list = seed_list.rstrip(',')
            ####print(seed_list)
            if(compile_result!=0):
                for test_file in run_test_dict:
                    log_analysis(run_compile_location+"/compile.log",'comp',test_list,work_location,seed_list,test_file,compile_number=compile_number)
            else:
                if(cmd_args.co==False):
                    run_test_proc_list = []
                    for test_file in run_test_dict:
                        for test in run_test_dict[test_file]:
                            run_test_proc =Process(target=run_test,args=(run_test_dict[test_file][test]["LOC"],run_test_dict[test_file][test]["SEED"],test_file+"."+test,run_num,work_location,test_file))
                            run_test_proc_list.append(run_test_proc)
                            run_test_proc.start()
                    
                    for single_run in run_test_proc_list:
                        single_run.join()
        else:
            for test_file in run_test_dict:
                log_analysis(run_compile_location+"/pre_compile.log",'pre_compile',test_list,work_location,seed_list,test_file,compile_number)
    else:
        if(cmd_args.sim==False):
            if(os.path.exists(run_compile_location+"/pre_compile_cmd.csh")):
                pre_comp_result = os.system("cd %s;./pre_compile_cmd.csh;"%(run_compile_location))
        if(pre_comp_result==0):
            if(cmd_args.sim==False):
                compile_result = os.system("cd %s;./compile.csh;"%(run_compile_location))
            test_list = ""
            seed_list = ''
            for test_file in run_test_dict:
                for test_nmae in run_test_dict[test_file]:
                    test_list += test_file+"."+test_nmae + ","
                    seed_list += run_test_dict[test_file][test_nmae]["SEED"]+ ","
            test_list = test_list.rstrip(',')
            seed_list = seed_list.rstrip(',')
            ######print(seed_list)
            #####print("compile_result: " + str(compile_result))
            if(compile_result!=0):
                ###print("111111")
                ###print(run_test_dict)
                for test_file in run_test_dict:
                    ####print(run_compile_location+"/compile.log"+test_list + "-" +work_location + "-" +seed_list + "-" +test_file )
                    log_analysis(run_compile_location+"/compile.log",'comp',test_list,work_location,seed_list,test_file,compile_number=compile_number)
            else:
                if(cmd_args.co==False):
                    print("TEST RUNING: ")
                    for test_file in run_test_dict:
                        print("log: "+work_location+"/report/" + test_file+"_"+timestr+"/result.log")
                    run_test_proc_list = []
                    for test_file in run_test_dict:
                        for test in run_test_dict[test_file]:
                            run_test_proc =Process(target=run_test,args=(run_test_dict[test_file][test]["LOC"],run_test_dict[test_file][test]["SEED"],test_file+"."+test,run_num,work_location,test_file))
                            run_test_proc_list.append(run_test_proc)
                            run_test_proc.start()
                
                    for single_run in run_test_proc_list:
                        single_run.join()
        else:
            for test_file in run_test_dict:
                log_analysis(run_compile_location+"/pre_compile.log",'pre_compile',test_list,work_location,seed_list,test_file,compile_number)

def run_test(run_location='',seed='',test_case="",run_num=0,work_location='',test_file=''):
    pre_sim_result = 0
    sim_result = 0
    # print("start run the test")
    # print("test_case: "+test_case)
    # print("run_location: "+run_location)
    if(run_num>1):
        if(os.path.exists(run_location+"/pre_sim_cmd.csh")):
            pre_sim_result = subprocess.call("./pre_sim_cmd.csh;",cwd=run_location,shell=True,stdout=subprocess.DEVNULL)
        if(pre_sim_result==0):
            sim_result = subprocess.call("./run_sim.csh;",cwd=run_location,shell=True,stdout=subprocess.DEVNULL)
            log_analysis(run_location+"/simv.log",'sim',test_case,work_location,seed,test_file)
        else:
            log_analysis(run_location+"/pre_sim_cmd.log",'pre_sim',test_case,work_location,seed,test_file)
    else:
        if(os.path.exists(run_location+"/pre_sim_cmd.csh")):
            pre_sim_result =  os.system("cd "+run_location+";./pre_sim_cmd.csh;")
            print("pre_sim_result: " +str(pre_sim_result))
        if(pre_sim_result==0):
            sim_result =  os.system("cd "+run_location+";./run_sim.csh;")
            log_analysis(run_location+"/simv.log",'sim',test_case,work_location,seed,test_file)
        else:
            log_analysis(run_location+"/pre_sim_cmd.log",'pre_sim',test_case,work_location,seed,test_file)
def log_analysis(log = '',type = '',test_case='',work_location="",seed="",test_file="",compile_number=0):
    os.system("python3 $PRJ_ROOT/verify/flow_script/analysis_log.py -case %s -log %s -type %s -dir %s -num %s -seed %s"%(test_case,log,type,work_location+"/report/"+cmd_args.testfile+"_"+timestr,str(compile_number),seed))
    ###print("seed:" +seed)

def main(cmd_args=any):
    global run_num
    global compile_number
    global compile_dict
    global compile2test_dict
    if(cmd_args.testfile=="" and cmd_args.rerun_fail==""):
        print("CMD WRONG")
        exit()
    compile_dict = {}
    compile2test_dict = {}
    test_select = ''
    run_num = 0
    compile_number = 0

    if(cmd_args.testname=='' and cmd_args.rerun_fail==""):
        work_location = WORK_DIR + "/regression" 
    elif(cmd_args.rerun_fail!=""):
        work_location = WORK_DIR + "/rerun_fail" 
    else:
        work_location = WORK_DIR

    print("work_location: "+ work_location)

    if(os.path.exists(work_location)==False):
        os.makedirs(work_location)


    if(os.path.exists(work_location+"/tmp_log/")==False):
        os.makedirs(work_location+"/tmp_log/")

    if(os.path.exists(work_location+"/report/")==False):
        os.makedirs(work_location+"/report/")
    if(os.path.exists(work_location+"/compile_loc/")==False):
        os.makedirs(work_location+"/compile_loc/")
    ####clean old tmp file
    os.system("rm -rf " + work_location + "/tmp_log/*")
    #print("rm -rf " + work_location + "/tmp_log/*")
    testcase_loc = DV_DIR + "/tests_simlist"
    compile_loc  = DV_DIR + "/tests_cmplist"
    test_content_dict    = {}
    compile_content_dict = {}
    fail_test_dict       = {}
    if(cmd_args.rerun_fail != ''):
        fail_content_dict = fail_test_collect(cmd_args.rerun_fail)
        print("fail_content_dict")
        print(fail_content_dict)
        for signle_test_file in fail_content_dict:
            test_content_dict[signle_test_file] = {} 
            excute_the_py_file(signle_test_file,work_location,testcase_loc)
            ##print("test_file_name: "+signle_test_file)
            for test_list in fail_content_dict[signle_test_file]:
                #print("test_name: "+test_list)
                test_content_dict_tmp    = test_information_collect(signle_test_file,test_list,work_location,fail_content_dict[signle_test_file][test_list]) 
                test_content_dict[signle_test_file].update(test_content_dict_tmp[signle_test_file])

        print("test_content_dict")
        print(test_content_dict)
        for compile_file in compile_dict:
            excute_the_py_file(compile_file,work_location,compile_loc)
            compile_content_dict.update(compile_information_collect(compile_file,compile_dict[compile_file],work_location))
        creat_compile_dir(compile_content_dict,work_location)
        creat_simulation_dir(test_content_dict,work_location)
    else:
        test_file_select_list = cmd_args.testfile.split(",")
        if(len(test_file_select_list)>1):
            test_list = "all_test"
        elif(cmd_args.testname==""):
            test_list = "all_test"
        else:
            test_list = cmd_args.testname
        for signle_test_file in test_file_select_list:
            excute_the_py_file(signle_test_file,work_location,testcase_loc)
            print("test_file_name: "+signle_test_file)
            print("test_name: "+test_list)
            test_content_dict.update(test_information_collect(signle_test_file,test_list,work_location))
        #if(cmd_args.list == True):
            #show_all_select_test(test_content_dict)
        if(cmd_args.debug == True):
            print("test_content_dict")
            print(test_content_dict)
            print("compile_dict")
            print(compile_dict)
        if(cmd_args.sim==False):
            for compile_file in compile_dict:
                excute_the_py_file(compile_file,work_location,compile_loc)
                compile_content_dict.update(compile_information_collect(compile_file,compile_dict[compile_file],work_location))
            if(cmd_args.debug == True):
                print("compile_content_dict")
                print(compile_content_dict)
            creat_compile_dir(compile_content_dict,work_location)
        
        creat_simulation_dir(test_content_dict,work_location)
        if(cmd_args.debug == True):
            print("compile2test_dict")
            print(compile2test_dict)
    if(cmd_args.coverage!=""):
        if(os.path.exists(work_location+"/coverage/" + cmd_args.testfile)==False):
            os.makedirs(work_location+"/coverage/" + cmd_args.testfile)
    if(compile_number>1):
        print("TEST RUNING: ")
        print("log: "+work_location+"/report/"+ cmd_args.testfile +"_"+timestr+"/result.log")
        if(cmd_args.rerun_fail!=""):
            print("ycheck -status " + cmd_args.testfile +"_"+timestr+ " -dir rerun_fail")
        else:
            print("ycheck -status " + cmd_args.testfile +"_"+timestr)
    k = []
    if(run_num>1):
    	regression_record_f =open(PRJ_ROOT+"/flow_record.txt","a")
    	regression_record_f.write("test_file:"+ cmd_args.testfile + ",dir:" + work_location+",date:"+timestr+'\n')
    	regression_record_f.close()
    for compile_file in compile2test_dict:
        for compile_name in compile2test_dict[compile_file]:
            p =Process(target=run_compile,args=(compile_file,compile_name,compile2test_dict[compile_file][compile_name],compile_number,run_num,work_location))
            k.append(p)
            p.start()

    for i in k:
        i.join()

    ####print("ALL TEST FINISH")
    if(cmd_args.co==False):
        if(cmd_args.email!=""):
            os.system("python3 $PRJ_ROOT/verify/flow_script/analysis_log.py -report %s -email %s"%(work_location+"/report/"+cmd_args.testfile+"_"+timestr+"/test_result.log", cmd_args.email))
        else:
            os.system("python3 $PRJ_ROOT/verify/flow_script/analysis_log.py -report %s "%(work_location+"/report/"+cmd_args.testfile+"_"+timestr+"/test_result.log"))
        if(run_num==1):
            for compile_file in compile2test_dict:
                for compile_name in compile2test_dict[compile_file]:
                    for test_file in compile2test_dict[compile_file][compile_name]:
                        for test in compile2test_dict[compile_file][compile_name][test_file]:
                            print("sim_location: " + compile2test_dict[compile_file][compile_name][test_file][test]["LOC"])
            print("reprot_location: " + work_location+"/report/"+cmd_args.testfile+"_"+timestr+"/result.log")
        else:
            print("reprot_location: " + work_location+"/report/"+cmd_args.testfile+"_"+timestr+"/result.log")
    os.system("rm -rf "+work_location+"/tmp_log")
    if(cmd_args.coverage!=""):
        os.system("urg -full64 -dir " + work_location + "/coverage/" + cmd_args.testfile)

if __name__== "__main__" :
    global cmd_args

    parser  = argparse.ArgumentParser()
    parser.add_argument("-testfile",default="",help="test_file,only one test file")
    parser.add_argument("-testname",default="",help="test_name,only one test name")
    parser.add_argument("-sim_opt",default="",help="tmp add sim option from cmd")
    parser.add_argument("-comp_opt",default="",help="tmp add sim option from cmd")

    parser.add_argument("-repeat",default=1,help="repeat times")
    parser.add_argument("-seed",default="",help="random seed select ")
    parser.add_argument("-tag",default="",help="select case with special tag")
    parser.add_argument("-rerun_fail",default="",help="rerun the fail case in the result file")
    parser.add_argument("-coverage",default="",help="coverage option")
    parser.add_argument("-postsim",action="store_true",help="post gate sim")
    parser.add_argument("-presim",action="store_true",help="pre gate sim")
    parser.add_argument("-fpga",action="store_true",help="fpga sim")
    parser.add_argument("-upf",action="store_true",help="upf sim")
    parser.add_argument("-sim",action="store_true",help="only simulation")
    parser.add_argument("-co",action="store_true",help="only compile")
    parser.add_argument("-debug",action="store_true",help="only for deug")
    parser.add_argument("-email",default="",help="email the result to who")
    parser.add_argument("-timestr",default="",help="only for v3 commit flow")
    cmd_args = parser.parse_args()
    if(cmd_args.timestr==""):
        timestr = time.strftime("%Y%m%d-%H%M%S")
    else:
        timestr = cmd_args.timestr
    main(cmd_args)
