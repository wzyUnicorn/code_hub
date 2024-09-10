import os
import re
import sys

def create_compile(
    compile_name       = '',
    compile_option     = '',
    vlogan_option      = '',
    pre_compile_cmd    = '',
    rtl_file           = '',
    verify_file        = '',
    compile_file_name = os.path.basename(sys.argv[0])
):
    compile_file = open(sys.argv[2] + "/" + compile_file_name.replace(".py",'') + "_compile.log", mode ='a')

    tmp_rtl_file = rtl_file.replace("/s",'').replace(" ",'')
    rtl_file_list = []
    if(tmp_rtl_file!=''):
        rtl_file_list = tmp_rtl_file.split(",")
    rtl_file_total = " "
    for rtl in rtl_file_list:
        rtl_file_total = "-f " + rtl + " "

    tmp_verif_file = verify_file.replace("/s",'').replace(" ",'')
    verif_file_list = []
    if(tmp_verif_file!=''):
        verif_file_list = tmp_verif_file.split(",")
    verif_file_total = " "
    for verif in verif_file_list:
        verif_file_total = "-f " + verif + " "

    compile_file.write('''CREAT_COMPILE:COMPILE_NAME=%s::COMPILE_OPTION=%s::VLOGAN_OPTION=%s::PRE_COMPILE_CMD=%s::RTL_FILE=%s::VERIF_FILE=%s::\n'''%(compile_name,compile_option,vlogan_option,pre_compile_cmd,rtl_file_total,verif_file_total))
    compile_file.close()
