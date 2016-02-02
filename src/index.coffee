globToRegExp = require 'glob-to-regexp'
isArray      = require 'is-array'
isRegExp     = require 'is-regexp'
isString     = require 'is-string'

endOfRegExp = /\/([gimy]+)?$/

isRegExpString = (s) ->
  (s.charAt 0) == '/' and (endOfRegExp.test s)

stringToRegExp = (s) ->
  match = endOfRegExp.exec s
  flags = match[1]
  index = match.index
  new RegExp (s.substring 1, index), flags

toRegExp = (s) ->
  s = s.trim()
  return unless s

  if isRegExpString s
    stringToRegExp s
  else
    globToRegExp s, extended: true

module.exports = (patterns, opts = {}) ->
  return toRegExp patterns if isString patterns
  return patterns if isRegExp patterns
  return unless patterns?

  unless isArray patterns
    throw new Error "Expected Array, RegExp or String found '#{patterns}'"

  # convert every pattern to RegExp
  regexps = []
  for pattern in patterns
    if isString pattern
      regexps.push toRegExp pattern if pattern.trim()
    else if isRegExp pattern
      regexps.push pattern
    else
      throw new Error "Expected RegExp or String found '#{pattern}'"

  return unless regexps.length > 0

  new RegExp (re.source for re in regexps).join '|'
