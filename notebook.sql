-- dbext:profile=quibbler
ALTER ROLE lovegood SET search_path TO public, private;
\du+
\dn+
\dt+
\dm+
\dv+
\d+ private.submission
\d+ private.vectors

SELECT COUNT(*) from private.submission;
SELECT COUNT(*) from private.vectors;

INSERT INTO private.vectors (id, vector)
SELECT
    s.id AS id,
    to_tsvector('english', s.title) AS vector
FROM
    private.submission s LEFT JOIN private.vectors v ON s.id = v.id
WHERE
   v.id IS NULL;

--CREATE INDEX private.vectorss_ts_gin ON private.vectors USING GIN (private.vectors);
DROP FUNCTION public.search;
CREATE OR REPLACE FUNCTION public.search (query TEXT)
    RETURNS TABLE(
        _created_utc TIMESTAMPTZ,
        _score INTEGER,
        _our_score DOUBLE PRECISION,
        _title TEXT,
        _url TEXT
    )
AS $$
BEGIN
    RETURN QUERY
    WITH uniq AS (
        SELECT DISTINCT ON(s.url)
            s.created_utc AS created_utc,
            s.url AS url,
            s.title AS title,
            s.score AS score,
            log(s.score + 1) - ((extract(epoch FROM now()) - s.created_utc) / 45000.0) AS our_score
        FROM
            private.submission s INNER JOIN private.vectors v ON s.id = v.id
        WHERE
            v.vector @@ plainto_tsquery(query)
    )
    SELECT
        to_timestamp(created_utc),
        score,
        our_score,
        title,
        url
    FROM uniq
    ORDER BY our_score DESC;
END; $$
LANGUAGE 'plpgsql';

DROP MATERIALIZED VIEW topics;
CREATE MATERIALIZED VIEW topics AS
    WITH histogram AS (
        SELECT
            word,
            ndoc,
            nentry
        FROM ts_stat('SELECT vector FROM private.vectors')
        ORDER BY nentry DESC, ndoc DESC, word
        LIMIT 1000
    ), uniq AS (
        SELECT DISTINCT ON(s.url)
            s.url AS url,
            s.score AS score,
            v.vector AS vector,
            log(s.score + 1) - ((extract(epoch FROM now()) - s.created_utc) / 45000.0) AS our_score
        FROM
            private.submission s INNER JOIN private.vectors v ON s.id = v.id
    )
    SELECT
        h.word AS word,
        avg(u.our_score) AS avg_score
    FROM
        histogram h CROSS JOIN uniq u
    WHERE
        u.vector @@ to_tsquery(h.word)
    GROUP BY h.word
    --HAVING avg(u.our_score) < 500
    ORDER by avg_score DESC;

REFRESH MATERIALIZED VIEW public.topics;

SELECT
    domain,
    COUNT(DISTINCT url)
FROM
    submission
GROUP BY
    domain
ORDER BY COUNT(DISTINCT url) DESC;

CREATE VIEW public.hot_subreddits AS
    WITH scores AS (
        SELECT
            s.subreddit AS subreddit,
            log(s.score + 1) - ((extract(epoch FROM now()) - s.created_utc) / 45000.0) AS our_score
        FROM
            private.submission s
    )
    SELECT
        subreddit,
        avg(our_score) AS score
    FROM scores
    GROUP BY subreddit
    ORDER BY avg(our_score) DESC;

CREATE VIEW public.hot_domains AS
    WITH scores AS (
        SELECT
            s.domain AS domain,
            log(s.score + 1) - ((extract(epoch FROM now()) - s.created_utc) / 45000.0) AS our_score
        FROM
            private.submission s
    )
    SELECT
        domain,
        avg(our_score) AS score
    FROM scores
    GROUP BY domain
    ORDER BY avg(our_score) DESC;

SELECT * FROM topics;
SELECT * FROM hot_domains;
SELECT * FROM hot_subreddits;
\copy (
    SELECT _created_utc AS "date", '[' || _title || '](' || _url || ')' AS "story" FROM search('21 trillion')) TO '/tmp/21trillion.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM search('khashoggi');
SELECT * FROM submission WHERE domain = 'archive.fo';
