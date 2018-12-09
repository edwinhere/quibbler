-- dbext:profile=quibbler

-- Delete submissions from archive.* domains
-- which are not from following subreddits
DELETE FROM submission WHERE
subreddit NOT IN (
    'The_Donald',
    'KotakuInAction',
    'TumblrInAction',
    'TheBluePill',
    'MensRights',
    'metacanada',
    'conspiracy',
    'MGTOW',
    'GamerGhazi',
    'SargonofAkkad',
    'ShitPoliticsSays',
    'GunsAreCool',
    'The_Farage',
    'KiAChatroom',
    'WikiLeaks',
    'Firearms',
    'pussypassdenied',
    'SocialJusticeInAction',
    'syriancivilwar',
    'Conservative',
    'JordanPeterson',
    'TrueReddit',
    'DarkEnlightenment',
    'russia',
    'Identitarians',
    'The_DonaldUnleashed',
    'TheNewRight',
    'TheRedPillStories',
    'TIL_Uncensored',
    'undelete',
    'WikiInAction',
    'AltRightChristian',
    'ChristianEnclave',
    'CoincidenceTheorist',
    'ConspiracyFacts',
    'DNCleaks',
    'EducatingLiberals',
    'Eurosceptics',
    'gunpolitics',
    'HateCrimeHoaxes',
    'HeadlineCorrections',
    'IslamUnveiled',
    'Libertarian',
    'multiculturalcancer',
    'polfacts',
    'Republican',
    'Right_Wing_Politics',
    'ShitCosmoSays'
) AND domain LIKE 'archive%';

-- Create full text search vectors
INSERT INTO private.vectors (id, vector)
SELECT
    s.id AS id,
    to_tsvector('english', s.title) AS vector
FROM
    private.submission s LEFT JOIN private.vectors v ON s.id = v.id
WHERE
   v.id IS NULL;

-- Refresh topics
REFRESH MATERIALIZED VIEW public.topics;
