globToRegex = require 'glob-to-regexp'
isArray     = require 'is-array'
isRegex     = require 'is-regexp'
isString    = require 'is-string'

endOfRegex = /\/([gimy]+)?$/

isRegexString = (s) ->
  (s.charAt 0) == '/' and (endOfRegex.test s)

stringToRegex = (s) ->
  match = endOfRegex.exec s
  flags = match[1]
  index = match.index
  new RegExp (s.substring 1, index), flags

toRegex = (s) ->
  s = s.trim()
  return unless s

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
  regexes = []
  for pattern in patterns
    if isString pattern
      regexes.push toRegex pattern if pattern.trim()
    else if isRegex pattern
      regexes.push pattern
    else
      throw new Error "Expected RegExp or String found '#{pattern}'"

  return unless regexes.length > 0

  new RegExp (re.source for re in regexes).join '|'
