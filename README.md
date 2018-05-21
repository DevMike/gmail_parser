# Gmail Parser

It's a small Rails API based application allowing to parse transactions(for now for Airbnb only) from your gmail account.

## Development Setup

* Ruby .ruby-version contain latest version. Use rbenv, rvm or whatever you like
* `bundle exec rake db:setup` - get seeded development db
* `bundle exec rails s` - starts server on 3000 port by default
* `bundle exec rake` - runs tests
* `QUEUE=* bundle exec rake resque:work` - to run jobs to parse gmail accounts

## How to Use

* open `http://localhost:3000/auth/google_oauth2`
* sign in via Google
* if everything is ok, you will be redirected back with status `ok` and a background job will to parse your emails will be created
* when parsing is done, all the transacitons will be stored into db and will be available by `http://localhost:3000/api/v1/transactions` as json data