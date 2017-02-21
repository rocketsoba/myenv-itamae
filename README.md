itamae for me
===

##入れ方
```
bundle install --path vendor/bundle
bundle exec mkunixcrypt > hashed_pass
ruby json_gen.rb > config.json
bundle exec itamae ssh -h hostname -u user recipe.rb -j config.json
```