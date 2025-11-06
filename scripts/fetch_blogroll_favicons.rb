#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'fileutils'

BLOGROLL_FILE = File.join(__dir__, '..', '_data', 'blogroll.yml')
FAVICON_DIR = File.join(__dir__, '..', 'assets', 'images', 'blogroll')

def fetch_page(url)
  uri = URI.parse(url)

  # Use HTTPS if not specified
  uri.scheme = 'https' if uri.scheme.nil?

  response = Net::HTTP.get_response(uri)

  # Follow redirects
  if response.is_a?(Net::HTTPRedirection)
    fetch_page(response['location'])
  elsif response.is_a?(Net::HTTPSuccess)
    response.body
  else
    nil
  end
rescue StandardError => e
  puts "Error fetching #{url}: #{e.message}"
  nil
end

def find_favicon_url(html, base_url)
  doc = Nokogiri::HTML(html)

  # Look for various favicon declarations
  favicon_selectors = [
    'link[rel="icon"]',
    'link[rel="shortcut icon"]',
    'link[rel="apple-touch-icon"]'
  ]

  favicon_selectors.each do |selector|
    link = doc.css(selector).first
    next unless link

    href = link['href']
    next unless href

    # Convert relative URLs to absolute
    favicon_uri = URI.parse(href)
    if favicon_uri.relative?
      base_uri = URI.parse(base_url)
      favicon_uri = URI.join("#{base_uri.scheme}://#{base_uri.host}", href)
    end

    return favicon_uri.to_s
  end

  # Fallback to /favicon.ico
  base_uri = URI.parse(base_url)
  "#{base_uri.scheme}://#{base_uri.host}/favicon.ico"
rescue StandardError => e
  puts "Error parsing favicon from #{base_url}: #{e.message}"
  nil
end

def download_favicon(url, filename)
  uri = URI.parse(url)

  response = Net::HTTP.get_response(uri)

  # Follow redirects
  if response.is_a?(Net::HTTPRedirection)
    download_favicon(response['location'], filename)
  elsif response.is_a?(Net::HTTPSuccess)
    File.binwrite(filename, response.body)
    true
  else
    puts "Failed to download favicon from #{url}: #{response.code}"
    false
  end
rescue StandardError => e
  puts "Error downloading favicon from #{url}: #{e.message}"
  false
end

def sanitize_filename(name)
  # Convert name to a safe filename
  name.downcase
      .gsub(/[^a-z0-9\s-]/, '')
      .gsub(/\s+/, '-')
      .gsub(/-+/, '-')
end

def main
  # Ensure favicon directory exists
  FileUtils.mkdir_p(FAVICON_DIR)

  # Load blogroll
  blogroll = YAML.load_file(BLOGROLL_FILE)
  links = blogroll['links']

  puts "Processing #{links.size} blogroll links..."

  updated = false

  links.each_with_index do |link, index|
    name = link['name']
    url = link['url']

    puts "\n[#{index + 1}/#{links.size}] #{name} (#{url})"

    # Fetch the page
    html = fetch_page(url)
    unless html
      puts "  ⚠️  Could not fetch page"
      next
    end

    # Find favicon URL
    favicon_url = find_favicon_url(html, url)
    unless favicon_url
      puts "  ⚠️  Could not find favicon"
      next
    end

    puts "  Found favicon: #{favicon_url}"

    # Determine file extension from URL
    ext = File.extname(URI.parse(favicon_url).path)
    ext = '.ico' if ext.empty?

    # Generate filename (just the basename, not full path)
    favicon_basename = "#{sanitize_filename(name)}#{ext}"
    filename = File.join(FAVICON_DIR, favicon_basename)

    # Download favicon
    if download_favicon(favicon_url, filename)
      puts "  ✓ Saved to #{filename}"
      # Update the link entry with the favicon filename
      link['favicon'] = favicon_basename
      updated = true
    end

    # Be nice to servers
    sleep 0.5
  end

  # Write updated YAML if any favicons were downloaded
  if updated
    File.write(BLOGROLL_FILE, YAML.dump(blogroll))
    puts "\n✓ Updated #{BLOGROLL_FILE} with favicon filenames"
  end

  puts "\n✓ Done! Favicons saved to #{FAVICON_DIR}"

  # Commit changes to git
  if updated
    puts "\nCommitting changes to git..."
    system('git', 'add', BLOGROLL_FILE, FAVICON_DIR)
    system('git', 'commit', '-m', 'chore(blogroll): update favicons')
    puts "✓ Changes committed"
  end
end

main if __FILE__ == $PROGRAM_NAME
