import openai
import argparse
from argparse import Action
# Replace with your OpenAI API key
api_key = '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'

def get_answer_to_question(context, question):
    openai.api_key = api_key

    # Concatenate the question and context
    prompt = f"Question: {question}\nContext: {context}\n"

    # Using OpenAI API for question answering
    response = openai.Completion.create(
        engine="text-davinci-002",
        prompt=prompt,
        temperature=0.7,
        max_tokens=500
    )

    # Get the answer from the generated text
    answer = response.choices[0].text.strip()
    return answer

def split_text_into_segments(text, max_tokens=4096):
    segments = []
    current_segment = ""
    for word in text.split():
        tokens_in_word = len(openai.tokenize(word))
        if len(current_segment) + tokens_in_word > max_tokens:
            segments.append(current_segment.strip())
            current_segment = word + " "
        else:
            current_segment += word + " "
    if current_segment:
        segments.append(current_segment.strip())
    return segments

if __name__ == "__main__":
    # Sample long document
    global cmd_args
    parser  = argparse.ArgumentParser()
    parser.add_argument("-fname",default="",help="file name,only one file can be checked")
    cmd_args = parser.parse_args()
    file_path = cmd_args.fname
    with open(file_path, "r", encoding="utf-8") as file:
        long_document = file.read()

    while True:
        user_question = input("Please enter your question (or type 'exit' to end): ")
        if user_question.lower() == 'exit':
            break

        answer = get_answer_to_question(long_document, user_question)
        print("Answer:")
        print(answer)

