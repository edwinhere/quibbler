import pprint as pp
from peewee import *
from playhouse.postgres_ext import *

db = PostgresqlExtDatabase('quibbler', user='lovegood', password='password', host='localhost', port='6543')

class BaseModel(Model):
    class Meta:
        database = db

class Submission(BaseModel):
    id = FixedCharField(
        max_length=10,
        primary_key=True
    )
    clicked = BooleanField(null=True)
    created_utc = DoubleField(null=True)
    distinguished = BooleanField(null=True)
    edited = BooleanField(null=True)
    is_video = BooleanField(null=True)
    link_flair_text = TextField(null=True)
    locked = BooleanField(null=True)
    num_comments = IntegerField(null=True)
    over_18 = BooleanField(null=True)
    permalink = TextField(null=True)
    score = IntegerField(null=True)
    selftext = TextField(null=True)
    stickied = BooleanField(null=True)
    title = TextField(null=True)
    upvote_ratio = DoubleField(null=True)
    author = TextField(null=True, index=True)
    subreddit = TextField(null=True, index=True)
    url = TextField(null=True)
    domain = TextField(null=True, index=True)

    def upsert(submission, domain):
        try:
            pk = (Submission
             .insert(
                id = submission.id,
                author = submission.author.name\
                 if hasattr(submission, 'author')\
                 and hasattr(submission.author, 'name')\
                 and submission.author is not None\
                 and submission.author.name is not None\
                 else None,
                subreddit = submission.subreddit.display_name,
                clicked = submission.clicked,
                created_utc = submission.created_utc,
                distinguished = submission.distinguished,
                edited = submission.edited,
                is_video = submission.is_video,
                link_flair_text = submission.link_flair_text,
                locked = submission.locked,
                num_comments = submission.num_comments,
                over_18 = submission.over_18,
                permalink = submission.permalink,
                score = submission.score,
                selftext = submission.selftext,
                stickied = submission.stickied,
                title = submission.title,
                upvote_ratio = submission.upvote_ratio,
                url = submission.url,
                domain = domain
             )
             .on_conflict(
                 conflict_target=(Submission.id,),
                 preserve=(Submission.created_utc,),
                 update={
                    Submission.clicked: submission.clicked,
                    Submission.distinguished: submission.distinguished,
                    Submission.edited: submission.edited,
                    Submission.is_video: submission.is_video,
                    Submission.link_flair_text: submission.link_flair_text,
                    Submission.locked: submission.locked,
                    Submission.num_comments: submission.num_comments,
                    Submission.over_18: submission.over_18,
                    Submission.permalink: submission.permalink,
                    Submission.score: submission.score,
                    Submission.selftext: submission.selftext,
                    Submission.stickied: submission.stickied,
                    Submission.title: submission.title,
                    Submission.upvote_ratio: submission.upvote_ratio,
                    Submission.url: submission.url,
                    Submission.domain: domain
                 })
             .execute())
        except Exception as e:
            pp.pprint(submission)
            pp.pprint(e)
            exc_type, exc_obj, exc_tb = sys.exc_info()
            fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
            print(exc_type, fname, exc_tb.tb_lineno)
            return None
        else:
            return pk


class SerialField(IntegerField):
    field_type = 'SERIAL'


class Embedding(BaseModel):
    title = TextField(
        primary_key=True
    )
    #vector = ArrayField(DoubleField)
    i = SerialField(
        null=False,
        unique=True
    )
    cluster = IntegerField()
