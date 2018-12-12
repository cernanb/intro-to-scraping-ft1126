require 'open-uri'
require 'nokogiri'
require 'pry'

base_url = 'https://www.billboard.com'

class Song
    attr_accessor :title, :artist, :artist_url

    @@all = []

    def initialize(title, artist, artist_url)
        @title = title
        @artist = artist
        @artist_url = artist_url
        @@all << self
    end

    def self.all
        @@all
    end
end

html = open('https://www.billboard.com/charts/hot-100')

doc = Nokogiri::HTML(html)

#grab the info on song number 1 and instantiate a new Song object
title =doc.css('.chart-number-one__title').text.strip
artist = doc.css('.chart-number-one__artist').text.strip

Song.new(title, artist, "d")

doc.css('.chart-list-item').each do |song_node|
    title = song_node.css('.chart-list-item__title-text').text.strip
    artist = song_node.css('.chart-list-item__artist').text.strip
    artist_url = song_node.css('.chart-list-item__artist a').empty? ? nil : song_node.css('.chart-list-item__artist a').attr("href").value
    Song.new(title, artist, artist_url)
   
end

Song.all.each.with_index(1) do |song, index|
    puts "#{index}. #{song.title} by #{song.artist}"
end

puts "Select a song to go to the artists page"

input = gets.chomp

song = Song.all[input.to_i - 1]

binding.pry
html2 = open(base_url + song.artist_url)

doc2 = Nokogiri::HTML(html2)

puts "Here is the chart history for #{song.artist}:"
doc2.css('.artist-section--chart-history__title-list__title').each do |artist_node|  
    puts artist_node.css('a')[0].text.strip
end