import requests
import os
import sys
import re
import time
import argparse
from argparse import Action
def analyze_rtl_file(rtl_text):
    headers = {
        'Content-Type': 'application/json',
        'Authorization': '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'
    }

    data = {
        'prompt': rtl_text,
        'model': 'gpt-3.5-turbo',
        'max_tokens': 1000,  # 根据您的需要调整生成报告的长度限制
    }

    response = requests.post('https://api.openai.com/v1/engines/davinci-codex/completions', headers=headers, json=data)

    if response.status_code == 200:
        result = response.json()
        completion = result['choices'][0]['text'].strip()
        return completion
    else:
        print('Error:', response.status_code)
        return None

def main(cmd_args=any):
    with open(cmd_args.i, 'r') as file:
        rtl_text = file.read()


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
