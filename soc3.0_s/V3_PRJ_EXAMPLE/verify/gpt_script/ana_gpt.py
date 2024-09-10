import requests
import os
import sys
import re
import time
import argparse
import openai

from argparse import Action
def analyze_rtl_file(rtl_text):
    openai.api_key = "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"
    prompt = rtl_text
    response = openai.Completion.create(
    engine="text-davinci-002",
    prompt=prompt,
    max_tokens=1000,
    )
    return response.choices[0].text

def main(cmd_args=any):
    with open(cmd_args.i, 'r') as file:
        rtl_text = file.read()
    rtl_text = "please analysis rtl code below and give the testplan to verfiy the rtl code\n" + rtl_text
    ###print(rtl_text)
    ###exit()

    report = analyze_rtl_file(rtl_text)


    if report:
        print("RTL文件分析报告:")
        print(report)
    else:
        print("无法生成报告")


if __name__== "__main__" :
    global cmd_args

    parser  = argparse.ArgumentParser()
    parser.add_argument("-i",default="",help="anlysis log file")
    cmd_args = parser.parse_args()
    main(cmd_args)
