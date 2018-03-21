require "open-uri"
require "nokogiri"


class GamesController < ApplicationController


  # VOWELS = %w(A, E, I, O, U)
  def new
   # @letters = Array.new(5) { VOWELS.sample }
   #  @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
   @letters = Array.new(10) {('A'..'Z').to_a.sample}
   @grid = @letters.shuffle
  end

  def score
	 	@query = params[:query].upcase!
	 	@saved_grid = params[:saved_grid].upcase
	 	included_letters
	 	calculate_score
	 	valid_word
  end

 	protected

  def included_letters
	 	@query_array = Array.new
	 	@query_array = @query.split("")
	 	@comparison_hash = Hash.new
	 	@query_array.each do |letter|
	 		if @comparison_hash[letter]
	 			@comparison_hash[letter] += 1
	 		else 
	 			@comparison_hash[letter] = 1
 			end
 			if (@comparison_hash["#{letter}"]).to_i <= (@saved_grid.count "#{letter}").to_i 
 				@included = true
 			else 
 				@included = false
 			end
 		end
 	end

		 #   	@query.upcase.count(letter) <= @saved_grid.count(letter)
		 #   end
 		# @included = @query.split("").each do |letter|
 		# 	puts @query.upcase.count(letter) <= @saved_grid.count(letter)
 		# end
 		# p @query + "hey"
 		# p @included
 		# p @saved_grid

 		# @included = @query.chars.all? { |letter| @query.upcase.count(letter) <= @saved_grid.count(letter) }


 	def calculate_score
 		if @included == true 
 			@total = 10 
 		else @total = 0
 		end
 	end

 	def valid_word
 		url = "http://www.wordgamedictionary.com/api/v1/references/scrabble/#{@query}?key=1.1666373543697045e30"
 		@doc = Nokogiri::XML(open("http://www.wordgamedictionary.com/api/v1/references/scrabble/#{@query}?key=1.1666373543697045e30"))
 		# @number = @domc.xpath("//Entry").attr("scrabble")
		value = @doc.xpath("//scrabble")
		if @doc.search("scrabble").children.text == "1"
			@valid = "Yup, that works"
		else
			@valid = "Um, that's not a Scrabbleable word"
		end
		@score = @doc.search("scrabblescore").children
	end

end

