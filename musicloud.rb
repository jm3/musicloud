#!/usr/bin/env ruby

gems = %w(rubygems mp3info find)
begin
  gems.each { |g| gem g }
rescue
  puts "Please install the following ruby gems: #{gems.join(', ')}."
  exit
end

songs_dir = '~/Dropbox/Music/'
# you should need to change nothing below this line:

tags = {}
songs_dir = File.expand_path( songs_dir )
Find.find( songs_dir ) do |song|
  next unless song =~ /mp3$/
  begin
    Mp3Info.open( song ) do |id3|
      song_tags = id3.tag2.TIT1.to_s.split( "," ).collect{ |x| x.strip }
      song_tags.each do |tag| 
        tags.has_key?( tag ) ? tags[tag] += 1 : tags[tag] = 1
        print "."
      end
      print " "
      STDOUT.flush
    end
  rescue
    print "(sad song)"
  end
end
puts

# output each tag once per instance; a good format for creating wordle.net tag clouds
tags.keys.each{ |tag| puts ("#{tag.to_s} " * tags[tag])}
