# TV Chat Backend

### Environment variables
Sensitive strings like api_keys should not be checked into git.

Locally these keys should be saved in a `.env` file. That's a file without a name but with an `env` extention. We're using a gem called [dotenv](https://github.com/bkeepers/dotenv) to handle this.


Sample .env file:
```
TMS_API_KEY=abc123
```

Whenever your application loads, these variables will be available in `ENV`:

```ruby
ENV['TMS_API_KEY']
```

In production, we should use [config variables](https://devcenter.heroku.com/articles/config-vars). `heroku config:set TMS_API_KEY=123`.

### Deployment
Make sure you're in the root director of the git repo (`Tv-Share-Backend`).
Then, run this command: `git subtree push --prefix tvsharedb heroku master`

If you need to force-push to heroku use this command: `git push heroku `git subtree split --prefix tvsharedb master`:master --force`. Note: Make sure you know what you're doing as this is a potentially destructive command.
