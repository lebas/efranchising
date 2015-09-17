require "efranchising/version"

module Efranchising

	autoload :Document, 'efranchising/document'
	autoload :Cielo, 		'efranchising/cielo'

  class Shop
  	def initialize
  		puts 'initialize ShopS4M'
  	end
  end
end
