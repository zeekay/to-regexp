globToRegex = require 'glob-to-regexp'
isArray     = require 'is-array'
isRegex     = require 'is-regexp'
isString    = require 'is-string'

endOfRegex = /\/(\w+)?$/

isRegexString = (s) ->
  (s.charAt 0) == '/' and endOfRegex.test s

stringToRegex = (s) ->
  match = endOfRegex.exec s
  flags = match[1]
  index = match.index
  new RegExp (s.substring 1, index), flags

toRegex = (s) ->
  s = s.trim()

  if isRegexString s
    stringToRegex s
  else
    globToRegex s, extended: true

module.exports = (patterns, opts = {}) ->
  return toRegex patterns if isString patterns
  return patterns if isRegex patterns
  return unless patterns?

  unless isArray patterns
    throw new Error "Expected Array, RegExp or String found '#{patterns}'"

  # convert every pattern to RegExp
  for pattern, i in patterns
    if isString pattern
      patterns[i] = toRegex pattern
    else if not isRegex pattern
      throw new Error "Expected RegExp or String found '#{pattern}'"

  new RegExp (re.source for re in patterns).join '|'
