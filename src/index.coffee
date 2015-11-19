globToRegExp = require 'glob-to-regexp'
isArray      = require 'is-array'
isRegExp     = require 'is-regexp'
isString     = require 'is-string'

module.exports = (patterns, opts = {}) ->
  return unless patterns?

  opts.extended ?= true

  if isRegExp patterns instanceof RegExp
    return patterns

  if isString patterns
    return globToRegExp patterns, opts

  unless isArray
    throw new Error 'Expected Array, RegExp or String'

  # convert every pattern to RegExp
  for pattern, i in patterns
    if isString pattern
      patterns[i] = globToRegExp pattern, opts
    else if not isRegEx pattern
      throw new Error 'Expected RegExp or String'

  new RegExp (re.source for re in patterns).join '|'
