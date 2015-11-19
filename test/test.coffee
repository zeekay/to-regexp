should  = (require 'chai').should()
toRegExp = require '../lib'


describe 'to-regexp', ->
  describe 'toRegExp', ->
    it 'should convert various glob patterns into regex correctly', ->
      patterns =
        'foo*': '/^foo.*$/'
        'foobar*': '/^foobar.*$/'
        '[bc]ar': '/^[bc]ar$/'
        'foo/bar': '/^foo\\/bar$/'
      for glob, re of patterns
        do (glob, re) ->
          regexp = toRegExp glob
          regexp.toString().should.equal re
