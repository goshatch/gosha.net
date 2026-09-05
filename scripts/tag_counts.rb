#!/usr/bin/env ruby
# frozen_string_literal: true

# Lists every category used across blog posts with the number of posts using it.
# Usage: ruby scripts/tag_counts.rb [--drafts]

require 'yaml'
require 'date'

dirs = ['_posts']
dirs << '_drafts' if ARGV.include?('--drafts')

counts = Hash.new(0)
Dir.glob("{#{dirs.join(',')}}/*.md").each do |path|
  front = File.read(path)[/\A---\n(.*?)\n---/m, 1] or next
  Array(YAML.safe_load(front, permitted_classes: [Time, Date])['categories']).each { |tag| counts[tag] += 1 }
end

counts.sort_by { |tag, n| [-n, tag] }.each { |tag, n| puts format('%4d  %s', n, tag) }
