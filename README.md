My blerg.

## to get up and running
I tend to batch update this after a long time away and I'm always
refiguring it out. So here are my steps from the latest attempt:

```bash
rbenv local 2.3.0               # hopefully these shouldn't need to be repeated
rbenv gemset create 2.3.0 blog  #

bundle update   # to regenerate new Gemfile.lock for new stuff
bundle install  
rbenv rehash    # to remake shims

rackup          # start the server
```
