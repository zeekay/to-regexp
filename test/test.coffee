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

    it 'should convert an array of glob patterns into regex correctly', ->
      patterns = [
        'foo*'
        'foobar*'
        '[bc]ar'
        'foo/bar'
      ]

      regexp = toRegExp patterns
      regexp.toString().should.equal '/^foo.*$|^foobar.*$|^[bc]ar$|^foo\\/bar$/'

    it 'should convert stringified regexes correctly', ->
      regexes = [
        '/foo/'
        '/bar/i'
        '/baz/gi'
        '/^foo.*$/'
        '/^foobar.*$/'
        '/^[bc]ar$/'
        '/^foo\\/bar$/'
      ]

      for re in regexes
        regexp = toRegExp re
        regexp.toString().should.equal re

    it 'should ignore empty arrays and/or non-sensical arguments', ->
      should.not.exist toRegExp []
      should.not.exist toRegExp ''
      should.not.exist toRegExp null
      should.not.exist toRegExp()

    it 'should merge array of regular expressions/globs', ->
      re = toRegExp [ /foo/, /bar/, /baz.*/ ]
      re.toString().should.be.eq '/foo|bar|baz.*/'
