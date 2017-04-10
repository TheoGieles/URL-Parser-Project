class UrlParser
	attr_accessor :link

	def initialize(link)
		@link = link
		@split_url = @link.split("://")
		@split2 = @link.split("://")[1]
	end

	def scheme
		@split_url[0]
	end

	def domain
		if @split2.include? ":"
			@split2.split(":")[0]
		elsif @split2.include? "/"
			@split2.split("/")[0]
		else
			@split2
		end	
	end

	def port
		if @split2.include? ":"
			@split2.split(":")[1].match(/^\d*/).to_s
		elsif @link.match? "https"
			"443"
		elsif @link.match? "http"
			"80"
		end
	end

	def path
		if @split2.include? "/"
			if @split2.include? "?"
				@split2.split("/", 2)[1].split("?")[0]
				if @split2.split("/", 2)[1].split("?")[0].length == 0
					nil
				else
					@split2.split("/", 2)[1].split("?")[0]
				end
			elsif @split2.include? "#"
				@split2.split("/", 2)[1].split("#")[0]
			end
		end
	end

	def query_string
		query = {}
		if @split2.include? "?"
			if @split2.include? "#"
				myquery = @split2.split("?")[1].split("#")[0]
			else
				myquery = @split2.split("?")[1]
			end
		
			if myquery.include? "&"

				myquery.split("&").each do |param|
					key = param.split("=")[0]
					value = param.split("=")[1]
					query[key] = value
				end
			else
				key = myquery.split("=")[0]
				value = myquery.split("=")[1]
				query[key] = value
			end

		end
		query
	end

	def fragment_id
		if @split2.include? "#"
			@split2.split("#")[1]
		else

		end
	end 
end

# @new_url = UrlParser.new "https://www.google.com:60/search?q=cat&name=Tim#img=FunnyCat"
# p @new_url.scheme
# p @new_url.domain
# p @new_url.port
# p @new_url.path
# p @new_url.query_string
# p @new_url.fragment_id

# @insecure_url = UrlParser.new "https://www.google.com/?q=cat#img=FunnyCat"
# p @insecure_url.path
# p @insecure_url.query_string
# p @insecure_url.port

# @special_url = UrlParser.new "http://www.google.com/search"
# p @special_url.port