require 'csv' #first basic assumption is that I can use ruby library 
require 'json' #also assume i can use json library 

#read file from first argument
csvFile = ARGV[0]
jsonFile = ARGV[1]


input = CSV.read(csvFile, {headers:true, converters: :numeric}) #header:true because we have a header at row 1, converters numeric is for integer and float data to not treated as string, however $ sign will cause "price" and "cost" to be treated as string
#print input 
  
  
#puts "hi I am mark, my github: markthelaw.github.io" 
  
result = Array.new # Arrray is used because it is a table, to store result 


input.each do |input_row| 

                # to store each row after matching title with data. Used hash because hash can be accessed with object as key, array is not suitable here b/c headers are names, which is object.
                eachRow = Hash.new 
				
				#to loop through, Googled how to loop, each_index is used for Array to get loop through each index, similar to "each" but return index instead 
				input.headers.each_index { 
				|i| 
				#eachRow[input.headers[i]] = input_row[i]
				#I noticed that result.to_json treat $ sign data as string. Example "Price":"$1.25", but sample output wants "Price":1.25
				# so I Googled how to remove that $ sign from a string. 
				# if value = nil, then don't use gsub, because gsub can't be used on null string, 2nd condition checks if the hash value variable type is String, b/c gsub can only be used on non-empty string 
				#I tried to come up a better checking mechanism, but this is the best working and basic I have created.
				if input_row[i].to_s!= '' and input_row[i].class == String and (input.headers[i] =="price" or input.headers[i] =="cost" )   
					#to_f converts a string to float variable, which is what we want, we don't want double quotes around price or cost in our case.
					eachRow[input.headers[i]] = input_row[i].gsub(/[^0-9A-Za-z.]/, '').to_f 
				else
					eachRow[input.headers[i]] = input_row[i]
				end
					} 


				result << eachRow # << is to push stuff into result
                #puts "eachRow is=" 
                #puts eachRow 
				
	end



#puts "result is: " 
#puts result 
                
#Googled how to convert Array to JSON             
#output << result.to_json # deprecated this, used JSON beautiful instead
#output.puts JSON.pretty_generate(result) #deprecated
               


#if else just to check if user provided argument for output file, if not create a new file call output.txt
if(jsonFile == nil)
	outputFile = File.open("output.txt","w") {|f| f.write JSON.pretty_generate(result)}
else
	outputFile = File.open(jsonFile,"w") {|f| f.write JSON.pretty_generate(result)}
end
