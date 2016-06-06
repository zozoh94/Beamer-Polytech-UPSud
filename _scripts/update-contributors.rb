#!/usr/bin/env ruby

require 'json'
require 'open-uri'

#
# Given an array of strings, return a human-readable concatenation of that list.
# For example, ['foo', 'bar', 'baz'] will become 'foo, bar and baz'.
# In fact, this function assumes that items are hashes with a :name and :url and
# will generate links in the returned result.
#
def csl(arr)
  return '' if arr.length === 0
  return lnk(arr[0]) if arr.length === 1

  arr.map!{ |c| '<a href="%{url}">%{name}</a>' % c }
  last = arr.pop
  ret = arr.join(', ')
  ret += ' and ' + last
end

repo_contributors = JSON.parse(open('https://api.github.com/repos/Caster/Beamer-TUe/contributors').read)
contributors = []
out = 'With contributions by '

repo_contributors.each{ |c| contributors.push({name: c['login'], url: c['html_url']}) unless c['login'] === 'Caster' }
out += csl(contributors)

write = File.join(File.dirname(__FILE__), '..', '_includes', 'contributors.html')
if File.exists?(write) and File.writable?(write)
  File.open(write, 'w') { |f| f.puts out }
else
  puts out
end
