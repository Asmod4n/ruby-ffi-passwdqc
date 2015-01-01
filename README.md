ruby-ffi-passwdqc
=================

ruby ffi wrapper around http://www.openwall.com/passwdqc/

Basic Usage
===========
```ruby
passwdqc = Passwdqc.new

passwdqc.check('short') # should return "too short"
passwdqc.check('this is a very long password') # should return nil, which means its good enough
```
