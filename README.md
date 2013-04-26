# capssh
A utility that allows you to easily SSH into a server defined in a capistrano configuration file.

## Install
```
gem install capssh
```

## Usage
**capssh must be run from your project's root directory.**

```
# SSH to one of the production servers
capssh -e production

# Shortcut for SSHing into one of the production servers
capssh production

# SSH to the production server that is in the db role
capssh -e production -r db

# List the app servers that are configured for production
capssh -e production -r app -l

# If you only have one server defined, you can connect to it by simply running capssh
capssh

# SSH to the production server and kick off the Rails console
capssh -e production -c

# See all available options
capssh -h
```

## Contributing

* Fork capssh
* Create a topic branch - `git checkout -b my_branch`
* Make your changes
* Add tests
* Rebase your branch so that all your changes are reflected in one commit
* Push to your branch - `git push origin my_branch`
* Create a Pull Request from your branch, include as much documentation
  as you can in the commit message/pull request, following these
[guidelines on writing a good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
* That's it!

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
