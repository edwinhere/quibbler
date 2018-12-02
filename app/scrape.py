import os
import sys

#os.environ["HTTPS_PROXY"] = "https://127.0.0.1:8118/"

import praw
import pprint as pp
from peewee import *
from models import *

reddit = praw.Reddit(
    client_id='P11aGMxi9hT5YQ',
    client_secret='zTWxHhl7iIfg-K1vFNTNrhrt2wQ',
    user_agent='python:shreddit:v6.0.4',
)

db.connect()
for domain in sys.argv[1:]:
    for submission in reddit.domain(domain).top(time_filter='month', limit=None):
            Submission.upsert(submission, domain)
for domain in sys.argv[1:]:
    for submission in reddit.domain(domain).top(time_filter='week', limit=None):
            Submission.upsert(submission, domain)
for domain in sys.argv[1:]:
    for submission in reddit.domain(domain).top(time_filter='day', limit=None):
            Submission.upsert(submission, domain)
db.close()
