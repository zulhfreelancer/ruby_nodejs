FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq && \
    apt-get install -y build-essential nodejs && \
    apt-get clean && \
    gem install bundler -v 2.1.4 && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    RELEASE=$(lsb_release -cs) && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main | tee  /etc/apt/sources.list.d/pgdg.list && \
    apt-get update -qq && \
    apt-get install -y postgresql-11 libpq-dev && \
    rm -f /etc/postgresql/11/main/pg_hba.conf

ADD pg-config-old/pg_hba.conf /etc/postgresql/11/main/
RUN service postgresql start && \
    pg_isready && \
    psql -U postgres --command "ALTER USER postgres WITH PASSWORD 'postgres';" && \
    rm -f /etc/postgresql/11/main/pg_hba.conf
ADD pg-config-new/pg_hba.conf /etc/postgresql/11/main/

VOLUME vendor/bundle
ENTRYPOINT bash
