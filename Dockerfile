#既存のプロジェクトのrubyのバージョンを指定
FROM ruby:2.7

#パッケージの取得
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends\
    nodejs  \
    yarn \
    mariadb-client  \
    build-essential

WORKDIR /myproject

COPY Gemfile /myproject/Gemfile
COPY Gemfile.lock /myproject/Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY . /myproject
