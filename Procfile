web: bundle exec puma -t 5:10 -p $PORT -e $RAILS_ENV
worker: RAILS_MAX_THREADS=$SIDEKIQ_MAX_THREADS bundle exec sidekiq -c $SIDEKIQ_MAX_THREADS -q default -q algoliasearch -q low_priority
